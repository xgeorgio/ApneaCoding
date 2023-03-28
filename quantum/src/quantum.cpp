/*
    Quantum numbers calculation
    These are the 4 basic numbers that define trajectories and
    properties for electrons in every atom in the Periodic Table.
*/

#include <iostream>
#include <iomanip>

using namespace std;

int main( void )
{
	int nn=0;
	unsigned long count=0;

    cout << "Quantum numbers calculator\n\n";
    cout << "Give primary quantum nuumber (n=1,2,...): ";
    cin >> nn;
    if (nn<1)
    {
    	cout << "\nPrimary quantum number must be >0.";
    	return 1;
    }

    cout << "Calculating quantum numbers:\n\n";
    cout << "(n=primary, l=secondary, ml=magneitic, ms=spin)\n\n";
    cout << "\t          n         l         ml        ms\n";
    cout << "\t      ---------+---------+---------+---------\n\n";

    for ( int l=0; l<=(nn-1); l++ )
    {
    	for ( long ml=-1; ml<l; ml++ )
    	{
    		for ( float ms=-0.5; ms<=0.5; ms++ )
    		{
    			cout << "\t      " << setw(5) << nn << "    :"
    			     << setw(5) << l << "    :" 
    			     << setw(5) << ml << "    :"
    			     << setw(7) << setprecision(1) << ms << endl;
    			count++;
    			
    		}
    	}
    }

    cout << "\nTotal positions calculated: " << count << endl;
    return 0;
}
