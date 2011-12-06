.onLoad =
function(...)
{
   types = getTypes()
   e = getNamespace("Rffi")
   mapply(assignInNamespace,
          paste(names(types), "Type", sep = ""),
          types, 
          MoreArgs = list(ns = e))
   assignInNamespace("FFI_DEFAULT_ABI", .Call("R_getDefaultABI"), ns = e)
}

voidType = 1
uint8Type = 1
sint8Type = 1
uint16Type = 1
sint16Type = 1
uint32Type = 1
sint32Type = 1
uint64Type = 1
sint64Type = 1
floatType = 1
doubleType = 1
longdoubleType = 1
pointerType = 1
stringType = 1

sexpType = 1
