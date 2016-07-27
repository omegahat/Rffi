# named xalloc.R rather than alloc.R so that makeClosure is
# defined before this code is evaluated.

setGeneric("alloc",
            function(nbytes, finalizer = getNativeSymbolInfo("R_free")$address, ...)
               standardGeneric("alloc"))

setMethod("alloc", "FFIType",
           function(nbytes, finalizer =  getNativeSymbolInfo("R_free")$address, ...)
               alloc(sizeof(nbytes), finalizer, ...))

setMethod("alloc", "StructFFIType",
           function(nbytes, finalizer =  getNativeSymbolInfo("R_free")$address, ...)
               alloc(structInfo(nbytes)$size, finalizer, ...))

setMethod("alloc", "numeric",
           function(nbytes, finalizer = getNativeSymbolInfo("R_free")$address, ...) {
              cif = CIF(pointerType, list(uint32Type, uint32Type))
#              ans = callCIF(cif, "calloc", 1L, nbytes)
              ans = .Call("R_ffi_calloc", nbytes)

              if(!is.logical(finalizer) || finalizer)
                addFinalizer(ans, finalizer)

              ans
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



if(TRUE)
setGeneric("addFinalizer",
           function(x, finalizer = "free")
            standardGeneric("addFinalizer"))


setMethod("addFinalizer", c(finalizer = "logical"),
           function(x, finalizer = "free")
             if(finalizer)
               addFinalizer(x, "free"))

setMethod("addFinalizer", c(finalizer = "character"),
           function(x, finalizer = "free")
               addFinalizer(x, getNativeSymbolInfo(finalizer)$address))

setOldClass("NativeSymbolInfo")
setMethod("addFinalizer", c(finalizer = "NativeSymbolInfo"),
           function(x, finalizer = "free")
               addFinalizer(x, finalizer$address))

setOldClass("NativeSymbol")
setMethod("addFinalizer", c(finalizer = "NativeSymbol"),
           function(x, finalizer = "free")
               .Call("R_setCFinalizer", as(x, "externalptr"), finalizer))



setMethod("addFinalizer", c("externalptr", "externalptr"),
           function(x, finalizer = "free") {
               .Call("R_setCFinalizer", x, finalizer)
           })

setMethod("addFinalizer", c("RCReference"),
           function(x, finalizer = "free") {
              addFinalizer(x@ref, finalizer)
           })
               
