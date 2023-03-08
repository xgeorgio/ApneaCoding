// BAM: Bi-directional Associative Memory
// Demo code of how Arduino-type microcontrollers
// can implement FPGA-like NN-based functionality

#include <stdio.h>
#include <LiquidCrystal_I2C.h>

// use 2x16 LCD display for simple 'console' output
LiquidCrystal_I2C lcd(0x27, 20, 4);

// configuration parameters
#define   PRINT_DELAY     1000
#define   PRINT_BUFFSZ    50

// training data specifications
#define   dataN    2 
#define   inp_sz   6  
#define   out_sz   4

// type definitions for internal use
typedef   signed short    value_t;     // vector contents
typedef   signed int      weight_t;    // weight matrix
typedef   signed long     tmpval_t;    // intermediate calculations
typedef   unsigned int    count_t;     // position counters
typedef   unsigned short  bool_t;      // replacement for booleans

// define matching input-output vector associations
value_t data_inp[dataN][inp_sz] = { {1,0,1,0,1,0}, {1,1,1,0,0,0} };
value_t data_out[dataN][out_sz] = {     {1,1,0,0},     {1,0,1,0} };

// allocate internal buffers (static)
weight_t w[inp_sz][out_sz];
value_t  retrvec[max(inp_sz,out_sz)];
char     str[PRINT_BUFFSZ];


// convert vector of {0,1} to {-1,+1}
void convert_to_signed( value_t *vec, count_t sz )
{
	for ( count_t c=0; c<sz; c++ )
		vec[c] = ((vec[c])?1:-1);
}

// convert vector of {-1,+1} to {0,1}
void convert_to_binary( value_t *vec, count_t sz )
{
	for ( count_t c=0; c<sz; c++ )
		vec[c] = ((vec[c]<=0)?0:1);
}

// calculate BAM weight matrix
void train_weights( void )
{
  // convert boolean input to signed
	for ( count_t q=0; q<dataN; q++ )
	{
		convert_to_signed(&(data_inp[q][0]),inp_sz);
		convert_to_signed(&(data_out[q][0]),out_sz);
	}
	
  // calculate correlations
  for ( count_t x=0; x<inp_sz; x++ )
	{
    for ( count_t y=0; y<out_sz; y++ )
		{
      for ( count_t q=0; q<dataN; q++ )
        w[x][y] += data_inp[q][x]*data_out[q][y];
		}
	}
			
  // convert signed back to boolean
	for ( count_t q=0; q<dataN; q++ )
	{
		convert_to_binary(&(data_inp[q][0]),inp_sz);
		convert_to_binary(&(data_out[q][0]),out_sz);
	}
}

// BAM retrieval, forward: input => output
void recall_out( const value_t *ivec, value_t *ovec )
{
  tmpval_t tmp[out_sz];    // internal vec, avoid overflows

  for ( count_t c=0; c<out_sz; c++ )
	{
		tmp[c]=0;
    for ( count_t r=0; r<inp_sz; r++ )
        tmp[c] += w[r][c]*ivec[r];
		ovec[c]=((tmp[c]>=0)?1:0);
	}
}

// BAM retrieval, backward: input <= output
void recall_inp( const value_t *ovec, value_t *ivec )
{
  tmpval_t tmp[inp_sz];    // internal vec, avoid overflows

  for ( count_t r=0; r<inp_sz; r++ )
	{
		tmp[r]=0;
    for ( count_t c=0; c<out_sz; c++ )
        tmp[r] += w[r][c]*ovec[c];
		ivec[r]=((tmp[r]>=0)?1:0);
	}
}

// display vector contents in a single line
void display_vector( const value_t *vec, count_t sz )
{
	for ( count_t c=0; c<sz-1; c++ )
  {
      sprintf(str,"%d,",vec[c]);
      lcd.print(str);
  }
  sprintf(str,"%d",vec[sz-1]);
  lcd.print(str);
}

// display BAM weight matrix (multi-line)
void display_weights( void )
{
  for ( count_t r=0; r<inp_sz; r++ )
	{
    lcd.clear();
    lcd.setCursor(0, 0);
    sprintf(str,"W [%d,0..%d]:",r,out_sz);
    lcd.print(str);
    lcd.setCursor(0, 1);
		display_vector(&(w[r][0]),out_sz);
    delay(PRINT_DELAY);
  }
}

// run all forward BAM retrievals
void display_input_tests( void )
{
  for ( count_t q=0; q<dataN; q++ )
  {
    // given data vector
    lcd.clear();
    sprintf(str,"[%d]=> input:",q);
    lcd.setCursor(0,0);
    lcd.print(str);
    //delay(500);
    lcd.setCursor(0,1);
    display_vector(&(data_inp[q][0]),inp_sz);
    delay(PRINT_DELAY);

    // expected retrieval
    lcd.clear();
    sprintf(str,"[%d]=> expected:",q);
    lcd.setCursor(0,0);
    lcd.print(str);
    //delay(500);
    lcd.setCursor(0,1);
    display_vector(&(data_out[q][0]),out_sz);
    delay(PRINT_DELAY);

    // actual retrieval from BAM
    lcd.clear();
    sprintf(str,"[%d]=> retrieved:",q);
    lcd.setCursor(0,0);
    lcd.print(str);
    //delay(500);
    recall_out(&(data_inp[q][0]),retrvec);
    lcd.setCursor(0,1);    
    display_vector(retrvec,out_sz);
    delay(PRINT_DELAY);
  }
}

// run all backward BAM retrievals
void display_output_tests( void )
{
  for ( count_t q=0; q<dataN; q++ )
  {
    // given data vector
    lcd.clear();
    sprintf(str,"[%d]<= output:",q);
    lcd.setCursor(0,0);
    lcd.print(str);
    //delay(500);
    lcd.setCursor(0,1);
    display_vector(&(data_out[q][0]),out_sz);
    delay(PRINT_DELAY);

    // expected retrieval
    lcd.clear();
    sprintf(str,"[%d]<= expected:",q);
    lcd.setCursor(0,0);
    lcd.print(str);
    //delay(500);
    lcd.setCursor(0,1);
    display_vector(&(data_inp[q][0]),inp_sz);
    delay(PRINT_DELAY);

    // actual retrieval from BAM
    lcd.clear();
    sprintf(str,"[%d]<= retrieved:",q);
    lcd.setCursor(0,0);
    lcd.print(str);
    //delay(500);
    recall_inp(&(data_out[q][0]),retrvec);
    lcd.setCursor(0,1);    
    display_vector(retrvec,inp_sz);
    delay(PRINT_DELAY);
  }
}

//..... standard code components .....

// initialization routine
void setup( void ) 
{
  lcd.init();
  lcd.backlight();

  lcd.clear();
  lcd.setCursor(0,0);
  //lcd.print("0123456789012345");
  lcd.print(" BAM demo code");
  lcd.setCursor(0,1);
  lcd.print("     1.0.0");
  delay(PRINT_DELAY);

  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Training...");

  train_weights();
  delay(PRINT_DELAY);    // just for display pause

  lcd.setCursor(0,1);
  lcd.print("=> Finished!");
  delay(PRINT_DELAY);
}

// continuous loop routine
void loop( void ) 
{
  display_weights();
  display_input_tests();
  display_output_tests();
}
