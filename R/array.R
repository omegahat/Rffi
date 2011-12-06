
arrayType =
function(elType, length)
{
    # what about the class of the 
   new("ArrayFFIType", ref = elType@ref, length = as.integer(length), elType = elType)
}


setMethod("[[", c("TypedPointer", "numeric"),
           function(x, i, j, ...) {
             
             off = if(i < 0)
                      as.integer(i) * sizeof(x@elType)               
                   else
                      as.integer(i - 1L) * sizeof(x@elType)
             ref = .Call("R_getPointerOffset", x, as.integer(off))
             getNativeValue(ref, x@elType)
           })

setMethod("+", c("TypedPointer", "numeric"),
           function(e1, e2) {
             off = as.integer(e2 - 1L) * sizeof(e1@elType)
             e1@ref = .Call("R_getPointerOffset", e1, as.integer(off))
             e1
           })

