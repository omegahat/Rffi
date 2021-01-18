# named xalloc.R rather than alloc.R so that makeClosure is
# defined before this code is evaluated.

setGeneric("alloc",
            function(nbytes, finalizer = getNativeSymbolInfo("R_free")$address, ...)
               standardGeneric("alloc"))

setMethod("alloc", "FFIType",
           function(nbytes, finalizer =  getNativeSymbolInfo("R_free")$address, ...)
               alloc(sizeof(nbytes), finalizer, ...))

setMethod("alloc", "StructFFIType",
           function(nbytes, finalizer =  getNativeSymbolInfo("R_free")$address, ...) {
               ans = alloc(structInfo(nbytes)$size, finalizer, ...)
               attr(ans, "FFIType") = nbytes
               new("FFIRCStructReference", ref = ans)
             })

setMethod("alloc", "numeric",
           function(nbytes, finalizer = getNativeSymbolInfo("R_free")$address, ...) {
              cif = CIF(pointerType, list(uint32Type, uint32Type))
#              ans = callCIF(cif, "calloc", 1L, nbytes)
              ans = .Call("R_ffi_calloc", nbytes)

              if(!is.logical(finalizer) || finalizer)
                addFinalizer(ans, finalizer)

              ans
           })

setClass("FFIRCStructReference", contains = "RCStructReference")

setMethod("$", "FFIRCStructReference",
          function(x, name) {
             ty = attr(x@ref, "FFIType")
             if(is.null(ty))
                stop("We need the StructFFIType")

             getStructField(x, name, ty)
          })
    

#setGeneric("allocPointer", function()
allocPointer =
function(val = NULL, finalizer = getNativeSymbolInfo("R_free")$address)
{
    alloc(.Machine$sizeof.pointer)
}

setGeneric("addrOf", function(x, ...)
                        standardGeneric("addrOf"))

setMethod("addrOf", "RCReference",
            function(x, ...)
              new("AddressOf", ref = x@ref))


setMethod("addrOf", "externalptr",
            function(x, ...)
              new("AddressOf", ref = x))

oldAddrOf =
function(x, addFinalizer = "R_free")
{
   if(is(x, "RCReference"))
     x = x@ref
   
   ans = .Call("R_address_of", x)
  
   ans
}


free = makeClosure(
            function(x) {
               if(is(x, "RCReference"))
                  x = x@ref

               if(is.null(.free.CIF))
                 .free.CIF <<- CIF(voidType, list(pointerType))
               if(is.null(.sym))
                 .sym <<- getNativeSymbolInfo("free")$address

               invisible(callCIF(.free.CIF, .sym, x, returnInputs = FALSE))
             }, .free.CIF = NULL, .sym = NULL )



if(!isGeneric("addFinalizer"))  # TRUE
setGeneric("addFinalizer",
           function(x, finalizer = "free", ...)
            standardGeneric("addFinalizer"))


setMethod("addFinalizer", c(finalizer = "logical"),
           function(obj, finalizer = "free", ...)
             if(finalizer)
               addFinalizer(obj, "free"))

setMethod("addFinalizer", c(finalizer = "character"),
           function(obj, finalizer = "free", ...)
               addFinalizer(obj, getNativeSymbolInfo(finalizer)$address))

setOldClass("NativeSymbolInfo")
setMethod("addFinalizer", c(finalizer = "NativeSymbolInfo"),
           function(obj, finalizer = "free", ...)
               addFinalizer(obj, finalizer$address))

setOldClass("NativeSymbol")
setMethod("addFinalizer", c(finalizer = "NativeSymbol"),
           function(obj, finalizer = "free", ...)
               .Call("R_setCFinalizer", as(obj, "externalptr"), finalizer))



setMethod("addFinalizer", c("externalptr", "externalptr"),
           function(obj, finalizer = "free", ...) {
               .Call("R_setCFinalizer", obj, finalizer)
           })

setMethod("addFinalizer", c("RCReference"),
           function(obj, finalizer = "free", ...) {
              addFinalizer(obj@ref, finalizer)
           })
               
