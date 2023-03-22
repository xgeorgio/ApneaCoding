
// Approximation of factorial N (i.e., N!)


// function for integer/exact calculation of n!
fn fact_exact( n : u16 ) -> u128
{
  let mut res:u128 = 1;
  let mut k:u16 = 2;
  
  // print intermediate output for tracing
  println!("k={}, res={}",k-1,res);
  // loop for terms 2 through n 
  while k <= n
  {
    res=res*(k as u128);
    k += 1;
    // print intermediate output for tracing
    println!("k={}, res={}",k-1,res);
  }
  println!("----------");
  
  return res;
}

// function for calculation of n! as floating point
fn fact_expon( n : u16 ) -> f64
{
  let mut res:f64 = 1.0;
  let mut k:u16 = 2;
  
  // print intermediate output for tracing
  // println!("k={}, res={}",k-1,res);
  // loop for terms 2 through n 
  while k <= n
  {
    res=res*(k as f64);
    k += 1;
    // print intermediate output for tracing
    // println!("k={}, res={}",k-1,res);
  }
  
  return res;
}

// function for approximation of n! via exponentials
// Stirling's formula:  n! = sqrt(2*pi*n)*(n^n)*e^(-n)
// this is the 'lower bound' value
fn fact_approx_lower( n : u16 ) -> f64
{
  let x:f64 = n as f64;
  
  return (2.0*std::f64::consts::PI*x).sqrt()
         * (x/std::f64::consts::E).powi(n as i32);
}

// function for approximation of n! via exponentials
// this is the 'upper bound' value, i.e. the 
// 'lower bound' increased by:  e^(1/(12n))
fn fact_approx_upper( n : u16 ) -> f64
{
  return fact_approx_lower(n) 
         * std::f64::consts::E.powf(1.0/12.0/(n as f64));
}

// function for approximation of n! via exponentials
// this is the average value between lower/upper bounds
fn fact_approx( n : u16 ) -> f64
{
  return (fact_approx_lower(n)+fact_approx_upper(n))/2.0;
}


// ..... main routine for testing purposes .....

fn main() 
{
  let  nsmall:u16 = 34;    // works fine for n <= 34
  let  nlarge:u16 = 170;   // works fine for n <= 170
  let  nhuge:u16  = 170;   // works fine for n <= 170
  
  println!("n={} : fact_exact={}", nsmall, fact_exact(nsmall));
  println!("n={} : fact_expon={}", nlarge, fact_expon(nlarge));
  println!("n={} : fact_approx={}", nhuge, fact_approx(nhuge));
  println!("n={} : fact_approx_lower={}", nhuge, fact_approx_lower(nhuge));
  println!("n={} : fact_approx_upper={}", nhuge, fact_approx_upper(nhuge));
}
