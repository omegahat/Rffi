library(Rffi)
library(RAutoGenRunTime)

cif = CIF(voidType, list(pointerType))


ptr = alloc(.Machine$sizeof.pointer)
callCIF(cif, "testAddrOf", addrOf(ptr))
as(ptr, "character")


ptr = alloc(sizeof(sint32Type))
callCIF(cif, "itestAddrOf", addrOf(ptr))
.Call("showIntPtr", ptr)


len = 10
ptr = alloc(sizeof(sint32Type) * len)
cif = CIF(voidType, list(pointerType, sint32Type))
callCIF(cif, "fillIArray", ptr, len) # addrOf(ptr))


# Get the values of the TestIArray global variable.
ptr = getNativeSymbolInfo("TestIArray")
.Call("R_getIntArray", ptr$addres, 5L)

 # Now pass in an int** and get the address of the TestIArray variable
 # So we need the addrOf() here.
ptr = allocPointer()
cif = CIF(voidType, list(pointerType))
callCIF(cif, "getTestIArray", addrOf(ptr))
.Call("R_getIntArray", ptr, 5L)



ptr = getNativeSymbolInfo("TestDArray")
.Call("R_getDoublePtr_els", ptr$address, 0:4)  # in RAutoGenRunTime

ptr = allocPointer()
cif = CIF(voidType, list(pointerType))
callCIF(cif, "getTestDArray", addrOf(ptr))
.Call("R_getDoublePtr_els", ptr, 0:4)


# Now alloc a struct object and fill it in.
MyStruct = structType(list(i = sint32Type, d = doubleType, str = stringType))
ptr = alloc(sizeof(MyStruct))
cif = CIF(voidType, list(pointerType))
ans = callCIF(cif, "fillStruct", ptr)
ans


