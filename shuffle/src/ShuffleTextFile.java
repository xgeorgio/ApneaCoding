// Shuffle the lines of a text file.
// Useful for preparing training datasets
// in .csv or other text format

import java.lang.*;
import java.io.*;
import java.util.*;

// source code is for depricated JDK 1.0 (legacy code)
// compile with:
//     javac -Xlint:unchecked ShuffleTextFile.java

public class ShuffleTextFile extends Object
{
    public Vector txtLines;   // text file buffer


    public ShuffleTextFile()
    {
        txtLines=new Vector();
    }


    public boolean readFile( String txtFilename )
    {
        File    txtFile;
        BufferedReader  txtStream;
        String  txtBuff;
        boolean res;

        txtFile=new File(txtFilename);
        if (txtFile.isFile() && txtFile.canRead())
        {
            try 
            {
                // use buffered reader for faster file read
                txtStream=new BufferedReader(new FileReader(txtFilename),1000);

                while (txtStream.ready())
                {
                    try
                    {
                        txtBuff=txtStream.readLine();
                        // warning: legacy code (Java generics not supported in JDK 1.0)
                        txtLines.add(txtBuff);
                    }
                    catch (IOException e1)
                    { break; }
                }

                txtStream.close();
                res=true;
            }
            catch (FileNotFoundException e2)
            {
                System.out.println("Error: File not found ("+txtFilename+")");
                res=false;
            }
            catch (IOException e3)
            {
                System.out.println("Error: Unable to read from file ("+txtFilename+")");
                res=false;
            }
        }
        else     // access file error (may be sharing lock)
        {
            System.out.println("Error: Unable to open file ("+txtFilename+")");
            res=false;
        }

        // uncomment when testing file read
        //if (res) System.println(txtLines.size()+" text lines read");

        return(res);
    }


    public void shuffleLines()
    {
        Vector  newLines=new Vector();
        Random  rnd=new Random();
        int     pos;

        while(txtLines.size()>0)
        {
            // step 1: select a random offset, convert to int
            pos = (int)(rnd.nextFloat()*(txtLines.size()));
            // step 2: add element to the new lines buffer
            // warning: legacy code (generics not supported in JDK 1.0)
            newLines.add(txtLines.elementAt(pos));
            // step 3: remove selected line from old buffer
            txtLines.removeElementAt(pos);
        }
    
        txtLines=newLines;
        //System.out.prinln(txtLines.size()+" text lines shuffled.");
    }


    public boolean writeFile( String txtOutfilename )
    {
        File     outFile;
        PrintWriter outStream;
        boolean  res=false;
        int      pos;

        try
        {
            outStream=new PrintWriter(new FileWriter(txtOutfilename),true);
        
            for ( pos=0; pos<txtLines.size(); pos++ )
            {
                // Note: <CR><LF> is always added at the end of the new line.
                // even if there is none at the end of the original file.
                outStream.println(txtLines.elementAt(pos));
            }

            outStream.close();
            res=true;
        }
        catch (FileNotFoundException e)
        {
            System.out.println("Error: File not found ("+txtOutfilename+")");
            res=false;
        }
        catch (IOException e)
        {
            System.out.println("Error: Unable to write to output file ("+txtOutfilename+")");
            res=false;
        }

        return(res);
    }


    public static void main( String args[] )
    {
        ShuffleTextFile tf=new ShuffleTextFile();

        if (args.length != 2)
        {
            System.out.println("Usage: ShuffleTextFile <inpfile> <outfile>");
            return;
        }
        
        tf.readFile(args[0]);
        tf.shuffleLines();
        tf.writeFile(args[1]);
    }

}





















            














