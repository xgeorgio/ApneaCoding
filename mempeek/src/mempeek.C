// Memory peek - DOS style

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <dos.h>
#include <conio.h>

#define    LINELEN      16
#define    LINECOUNT    16
#define    STRLEN       10

// this is the common XMS callback address
#define    INIT_SEG     0xC83F
#define    INIT_OFF     0x0010


// display one page of memory and wait for user
void display_mem( unsigned char far *fptr0 )
{
    //struct SREGS segs;
    unsigned char far *fptr;
    int    r=0, c=0;
    
    //segread(&segs);
    //printf("CS=%04X, DS=%04X, ES=%04X, SS=%04X\n\n",
    //    segs.cs, segs.ds, segs.es, segs.ss);
    //fptr0=MK_FP(INIT_SEG,INIT_OFF);
    
    for ( r=0; r<LINECOUNT; r++,fptr0=fptr )
    {
        fptr=fptr0;
	printf("%04X:%04X> ",FP_SEG(fptr),FP_OFF(fptr));
	
	// print memory contents in hex mode
	for ( c=0; c<LINELEN; c++ )
	{
	    // every 8 bytes add a space separator
	    if (c%8==0) printf(" ");
	    printf("%02X ",*fptr);
	    fptr++;
	}
	fptr=fptr0;  // print from the start again
	
	// print memory contents in ASCII mode
	for ( c=0; c<LINELEN; c++ )
	{
	    if (c%8==0) printf(" ");
	    // print only printable characters
	    printf("%c",(isprint(*fptr)?(*fptr):'.'));
	    fptr++;
	}
	printf("\n");
	
	// every 8 lines print a new line separator
	if ((r+1)%8==0)  printf("\n");
    }
    
    // print command prompt and wait for user input
    printf("Commands: F,N=next B,P=prev S=segment O=offset X,Q=quit\n");
    printf("\n? ");
}


// main routine (with user input)
int main( void )
{
    // 'far' pointers necessary for seg:off addressing
    unsigned char far *fptr, far *fptr_st;
    unsigned int segm=0, offm=0;  // raw 16-bit addresses
    char    addrstr[STRLEN];      // user input string
    int     ch=0;           // for user prompt input
    
    // initialize the display with the XMS entry point
    // normally you should see something like 'EMMXXXX0'
    fptr_st=MK_FP(INIT_SEG,INIT_OFF);
    
    while ((ch!='Q')&&(ch!='X'))  // continue until quit
    {
        display_mem(fptr_st);     // display current page

        ch=toupper(getch());      // get user input
	printf("%c\n",ch);
	
	switch(ch)
	{
	    // move a full page forwards
	    case 'N':
	    case 'F': fptr_st += LINELEN*LINECOUNT; break;
	    // move a full page backwards
	    case 'P':
	    case 'B': fptr_st -= LINELEN*LINECOUNT; break;
	    // set new memory segment address
	    case 'S': printf("Segment (hex): ");
	              // safe string input with length limit
		      //scanf("%s",addrstr);
		      if (fgets(addrstr,STRLEN,stdin))
		      {
		          // use strtol() for proper hex conversion
		          // Note: zero is returned on invalid input
		          segm=(unsigned)strtol(addrstr,NULL,16);
		          //printf("Read %04X",segm);
		          printf("\n");
		          // use offset address as-is
		          fptr_st=MK_FP(segm,FP_OFF(fptr_st));
		      }
		      break;
            // set new memory offset address
            case 'O': printf("Offset (hex): ");
	              // safe string input with length limit
		      // scanf("%s",addrstr);
		      if (fgets(addrstr,STRLEN,stdin))
		      {
		          // use strtol() for proper hex conversion
		          // Note: zero is returned on invalid input
		          offm=(unsigned)strtol(addrstr,NULL,16);	      
		          //printf("Read: %04X",offm);
		          printf("\n");
		          // use segment address as-is
		          fptr_st=MK_FP(FP_SEG(fptr_st),offm);
		      }
		      break;    
	    // exit choices, not necessary here
	    case 'X':
	    case 'Q': break;
	}	
    }
    
    return 0;
}

