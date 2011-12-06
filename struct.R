library(Rffi)
myStruct.type = structType(list(s = sint16Type, i = sint32Type, d = doubleType, str = stringType))

cif = CIF(myStruct.type)
callCIF(cif, "getStruct")

cif = CIF(voidType, list(myStruct.type))
invisible(replicate(10000, callCIF(cif, "doStruct", list(-10L, 99L, 3.1415, "an R string"))))
