makeClosure =
function(fun, ..., .els = list(...), env = new.env())  
{
   environment(fun) = env
   mapply(assign, names(.els), .els, MoreArgs = list(env = env))
   fun
}


if(!UseSimpleCRunTime) 
isNilPointer =
function(ref)
  .Call("R_isNilPointer", ref)




