

getTypes =
function()
{  
   types = .Call("R_getDefinedTypes")
   names(types) = c("void", "uint8", "sint8", "uint16", "sint16", "uint32", "sint32", "uint64", "sint64",
                     "float", "double", "longdouble", "pointer", "string", "sexp")

   classes = c("VoidFFIType", rep("ScalarFFIType", 11), "PointerFFIType", "StringFFIType", "SEXPFFIType")
   structure(mapply( function(ref, k) new(k, ref = ref),
                      types, classes), names = names(types))
}


isPointerType =
function(type)
{
  isFFIType(type, pointerType)
}

isFFIType =
function(type, target)
{
   .Call("R_isFFIType", type, target)
}


getFFITypeSize =
function(type)
{
  .Call("R_getFFITypeSize", type)
}
