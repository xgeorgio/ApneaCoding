
// Signed integer multiplication with the Russian algorithm (shift/additions)
// It uses only additions and bit shifts, with complexity log2(Nbits)
// where Nbits is the bit length of the smallest multiplication term.

// replacement sign() to avoid Float conversions
fun sign_i( x : Int ) : Int
{
    if (x > 0)  return 1
    else if (x < 0)  return -1
    else  return 0
}

// multiplication function, log2(Nbits) complexity
fun mult_rus_i( a : Int, b : Int ) : Int
{
    var a_term : Int = Math.abs(a)
    var b_term : Int = Math.abs(b)
    var ssum   : Int = 0
    val ssign  : Int = sign_i(a)*sign_i(b)
 
    // swap if needed, use smaller as second term
    if (b_term > a_term)
    {
        ssum = a_term
        a_term = b_term
        b_term = ssum
        ssum = 0
        println("\tSwapped: $a_term, $b_term -> $ssum")
    }
    
    // loop for all bits in second term
    while (b_term > 1)
    {
        println("\tIteration: $a_term, $b_term -> $ssum")
        if (b_term and 0b1 == 1 )   // b_term % 2 == 1
          ssum += a_term

        a_term = a_term shl 1       // a_term *= 2
        b_term = b_term ushr 1      // b_term /= 2
    }
    // add last term, adjust the sign in result
    ssum += a_term
    if (ssign<0)  ssum = -ssum
    println("\tIteration: $a_term, $b_term -> $ssum")
    
    return ssum
}


// ..... main routine used for unit testing .....

fun main() {
    val na  : Int =-4759
    val nb  : Int = 13179
    var res : Int
    
    println("Signed integer multiplication, Russian algorithm\n")
    res = mult_rus_i(na,nb)
    println("Result: $na x $nb = $res")
}

