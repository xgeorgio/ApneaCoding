// BAM: Bi-directional Associative Memory
// Demo code of how Arduino-type microcontrollers
// can implement FPGA-like NN-based functionality

#include <stdio.h>

// training data specifications
#define   dataN      2 
#define   inp_sz     6  
#define   out_sz     4

// type definitions for internal use
typedef   float      value_t;
typedef   float      weight_t;
typedef   float      tmpval_t;
typedef   unsigned int    count_t;
typedef   unsigned short  bool_t;
	
// define matching input-output vector associations
value_t data_inp[dataN][inp_sz] = { {1,0,1,0,1,0}, {1,1,1,0,0,0} };
value_t data_out[dataN][out_sz] = {     {1,1,0,0},     {1,0,1,0} };

// 'fuzzy' input vector for retrieval
value_t fvec[inp_sz] = { 0.9, 0, 0.85, 0, 0.8, 0 };

// allocate internal buffers (static)
weight_t w[inp_sz][out_sz];
value_t  retrvec[ ((inp_sz>out_sz)?inp_sz:out_sz) ];


// vector comparison for equality (utility function)
bool_t vec_isequal( const value_t *vec1, const value_t *vec2, count_t sz )
{
	count_t c=0;
	bool_t  res=1;
	
	while ((res)&&(c<sz))
	{
		res=(vec1[c]==vec2[c]);
		c++;
	}
	return(res);
}

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

// clear BAM weight matrix
void clear_weights( void )
{
    for ( count_t x=0; x<inp_sz; x++ )
        for ( count_t y=0; y<out_sz; y++ )
            w[x][y]=0;
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

// display vector contents in a single line
void display_vector( const value_t *vec, count_t sz )
{
	for ( count_t c=0; c<sz-1; c++ )
        printf("%.2f,",(float)vec[c]);
	printf("%.2f",(float)vec[sz-1]);
}

// display BAM weight matrix (multi-line)
void display_weights( void )
{
    printf("W =\n");
    for ( count_t x=0; x<inp_sz; x++ )
	{
		printf("\t");
	    /*for ( count_t y=0; y<out_sz-1; y++ )
			printf("%.2f,",(float)w[x][y]);
        printf("%.2f\n",(float)w[x][y]);*/
		display_vector(&(w[x][0]),out_sz);  printf("\n");
    }
}

// BAM retrieval, forward: input => output
void recall_out( const value_t *ivec, value_t *ovec )
{
    tmpval_t tmp[out_sz];    // internal vec, avoid overflows
	
	printf("recall_out: ivec = ");  display_vector(ivec,inp_sz);  printf("\n==> ");
    for ( count_t c=0; c<out_sz; c++ )
	{
		tmp[c]=0;
        for ( count_t r=0; r<inp_sz; r++ )
            tmp[c] += w[r][c]*ivec[r];
		printf("%.3f ",(float)tmp[c]);
		ovec[c]=((tmp[c]>=0)?1:0);
	}
	printf("\nrecall_out: ovec = ");  display_vector(ovec,out_sz);  printf("\n");
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


//..... main program for sample test runs .....
int main()
{
	printf("BAM demo code - v1.0\n\n");
	
    display_vector(&(data_inp[0][0]),inp_sz);  printf("\n");
    convert_to_signed(&(data_inp[0][0]),inp_sz);
    display_vector(&(data_inp[0][0]),inp_sz);  printf("\n");

	printf("is_equal? = %d\n",vec_isequal(&(data_inp[0][0]),&(data_inp[0][0]),inp_sz));
	printf("is_equal? = %d\n",vec_isequal(&(data_inp[0][0]),&(data_inp[1][0]),inp_sz));
	
    convert_to_binary(&(data_inp[0][0]),inp_sz);
    display_vector(&(data_inp[0][0]),inp_sz);  printf("\n");	
	
	clear_weights();
	train_weights();
	display_weights();
	
	printf("BAM: input => output\n");
	recall_out(&(data_inp[0][0]),retrvec);
	display_vector(retrvec,out_sz);

	printf("\nBAM: input <= output\n");
	recall_inp(&(data_out[0][0]),retrvec);
	display_vector(retrvec,inp_sz);

	printf("\nBAM: input(f) => output\n");
	recall_out(fvec,retrvec);
	display_vector(retrvec,out_sz);
	
	return 0;
}

