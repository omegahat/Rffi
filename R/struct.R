
structType =
function(types)
{
  ans = .Call("R_create_ffi_struct_type", types)
  ans = new("StructFFIType", ref = ans)
  ans@fieldNames = if(length(names(types))) names(types) else character(0)
  ans
}


getStructValue = 
function(ptr, type)
{
   ids = type@fieldNames
   if(typeof(ptr) != "externalptr")
      ptr = as(ptr, "externalptr")

#   if(typeof(type) != "externalptr")
#      type = as(type, "externalptr")

   ans = .Call("R_convertStructToR", ptr, type)
   if(length(ids))
      names(ans) = ids
   ans
}

setGeneric("getStructField",
             function(ptr, id, type)
                 standardGeneric("getStructField"))


setMethod("getStructField", c("NativeSymbol", "ANY", "StructFFIType"),
           function(ptr, id, type) {
              oclass = class(ptr)
              class(ptr) = "externalptr"
              on.exit({class(ptr) = oclass})
              getStructField(ptr, id, type)
           })

setMethod("getStructField", c("RCReference", "ANY", "StructFFIType"),
           function(ptr, id, type) {
              getStructField(ptr@ref, id, type)
           })

setMethod("getStructField", c("externalptr", "character", "StructFFIType"),
           function(ptr, id, type) {
               names = type@fieldNames
               if(length(names) == 0)  
                  stop("no names for this struct type definition")

               i = pmatch(id, names)       
               if(any(is.na(i)))
                   stop("No such field ", id)

               getStructField(ptr, i, type)
           })

setMethod("getStructField", c("externalptr", "numeric", "StructFFIType"),
           function(ptr, id, type) {
             if(length(id) > 1)
                lapply(id, function(i) getStructField(ptr, i, type))
             else 
                .Call("R_getStructElement", ptr, type, as.integer(id - 1L))
           })





getNativeValue = 
function(ptr, type)
{
  if(is.character(ptr))
     ptr = getNativeSymbolInfo(ptr)$address

  if(is(ptr, "NativeSymbolInfo"))
     ptr = ptr$address
  
  .Call("R_convertFromNative", ptr, type)
}


structInfo =
function(type)
{
   i = .Call("R_getStructInfo", type)
   list(size = i[length(i)],
        offsets = i[-length(i)])
}


stringArrayType =
function(len)
{
  .Call("R_stringArrayFFIType", as.integer(len))
}  
  
