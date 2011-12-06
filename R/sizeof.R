
setGeneric("sizeof",
            function(type, ...)
              standardGeneric("sizeof"))


setMethod("sizeof", "FFIType",
            function(type, ...) {
               .Call("R_getFFITypeSize", type)
            })


setMethod("sizeof", "StructFFIType",
            function(type, ...) {
              structInfo(type)$size
            })

