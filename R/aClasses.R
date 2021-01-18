if(FALSE) {
   # We get these from RAutoGenRunTime
setClass("RNativeReference", representation(ref = "externalptr"))
setClass("RCReference", contains = "RNativeReference")
setClass("RCStructReference", contains = "RCReference")
}

setClass("FFIType", contains = "RCReference")
setClass("ScalarFFIType", contains = "FFIType")
setClass("StructFFIType", representation(fieldNames = "character"), contains = "FFIType")
setClass("PointerFFIType", contains = "FFIType")
setClass("SEXPFFIType", contains = "PointerFFIType")
setClass("VoidFFIType", contains = "FFIType")
setClass("StringFFIType", contains = "ScalarFFIType")
setClass("FixedLengthStringFFIType", contains = "StringFFIType")

setClass("ArrayFFIType", representation(length = "integer", elType = "FFIType"), contains = "ScalarFFIType")

setOldClass("NativeSymbol")

setClass("AddressOf", contains = "RCReference")


  # An instance of a pointer with element type information
setClass("TypedPointer",
           representation(elType = "FFIType"), contains = "RNativeReference")

    # A class to specify a pointer to a particular type of element.
setClass("PointerTypeFFI", representation(elType = "FFIType"), contains = "PointerFFIType")# ,             prototype = list(ref = pointerType@ref))

pointer =
function(type)  
{
  new("PointerTypeFFI", elType = type)
}


typedPointer = arrayPtr =
function(ptr, elType, obj = new("TypedPointer"))
{
  obj@ref = ptr
  obj@elType = elType
  obj
}


setAs("FFIType", "externalptr",
       function(from)
        from@ref)

UseSimpleCRunTime = FALSE  # WAS TRUE XXXX

if(!UseSimpleCRunTime) {
setAs("RCReference", "externalptr",
       function(from)
        from@ref)

setMethod("[", c("RCStructReference"),
          function(x, i, j, ...) {
             sapply(unlist(c(i, ...)), function(id) x[[id]])
          })

setMethod("[", c("RCStructReference", "missing"),
          function(x, i, j, ...) {
             sapply(names(x), function(id) x[[id]])
          })


setMethod("[[", c("RCStructReference", "character"),
          function(x, i, j, ...) {
             do.call(`$`, list(x, i))
          })
}          
           
