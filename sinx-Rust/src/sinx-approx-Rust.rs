
// Approximation of sin(x) via dynamic series


// core function for dynamic series of sin(x)
fn sinx_approx( 
  x : f32,      // x = angle in radians
  n : i32 )     // n = number of terms used 
  -> f32        // returns sin(x) approximation 
{
  let mut res:f32 = x;        // used for result
  let mut xdiv:f32 = x/2.0;   // argument in first term
  
  // print intermediate output for tracing
  println!("iter 1 xdiv={}, res={}",xdiv,res);
  // loop for terms 2 through n 
  for k in 2..n+1
  {
    res=res*xdiv.cos();   // update series result
    xdiv=xdiv/2.0;        // argument for next term
    // print intermediate output for tracing
    println!("iter {}: xdiv={}, res={}",k,xdiv,res);
  }
  
  return res;
}


// ..... main routine for testing purposes .....

fn main() 
{
  let  pi:f32 = 3.141592653589793;   // pi constant
  let  x:f32 = pi/4.0;    // sin(pi/4) = 1/sqrt(2) = 0.70709...
  let  n:i32 = 12;        // works fine for n <= 12
  
  println!("\nsin({}), approx({}) : {}", x, n, sinx_approx(x,n));
  println!("sin({}), accurate : {}", x, x.sin());
}
