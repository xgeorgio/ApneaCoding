macro incrK_baseN(strval,incrK=1,baseN=10)
   return :(string(parse(Int,$strval,base=$baseN)+$incrK,base=$baseN))
end

function incrK_baseN(strval::String,incrK::Int=1,baseN::Int=10)
   return(string(parse(Int,strval,base=baseN)+incrK,base=baseN))
end

str="1010011111"; inc=17; bs=2;

using BenchmarkTools

@benchmark @incrK_baseN(str,inc,bs)

@benchmark incrK_baseN(str,inc,bs)
