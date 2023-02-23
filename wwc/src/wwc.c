/* wwc: word counter for text files, similar to
        'wc' available in Unix/Linux platforms. */

#include <stdio.h>
#include <stdlib.h>


void usage( void )
{
    printf("Usage:  wwc [filelist]\n\n");
}


int main( int argc, char **argv )
{
    FILE    *fh;
    char    ch;
    int     fcount=1;
    long    files=0, lines=0, words=0, chars=0, pl=0, pw=0, pc=0;


    /* check for error or query in the command line */
    if ((argc<2)||(argv[fcount][0]=='-')||(argv[fcount][0]=='?'))
    {
        usage();
        exit(EXIT_FAILURE);
    }

    while(argv[fcount])
    {
        if ((fh=fopen(argv[fcount++],"rb"))==NULL)
            continue;
        else
        {
            files++;
            printf("%10s:\t",argv[fcount-1]);

            /* update global counters before new processing */
            pl=lines; pw=words; pc=chars;
            fseek(fh,0,SEEK_SET);    /* just to make sure... */
            while((ch=fgetc(fh))!=EOF)
            {
                /* Note: Lines are detected with \n character,
                   and words counted only when non-empty */
                switch(ch)
                {
                    case '\n':  lines++;
                    case '\t':
                    case  ' ':  if (chars>0) words++;
                }
                chars++;
            }

            printf(" %ld lines(s), %ld words, %ld chars\n",lines-pl,words-pw,chars-pc);
        }
    }

    /* when all files in the list are processed, exit with results */
    printf("\nTOTALS: %ld files, %ld lines, %ld words, %ld chars\n\n",files,lines,words,chars);

    exit(EXIT_SUCCESS);
}


