library(Rffi)
types = getTypes()

cif = prepCIF(types[["double"]], list(types[["sint32"]], types[["double"]]))

foo =  getNativeSymbolInfo("foo")$address
#.Call("R_ffi_call", cif, list(1L, 2.3), foo)


cif = prepCIF(doubleType, c(sint32Type, doubleType))
callCIF(cif, "foo", 1L, 2.3)
callCIF(cif, "foo", 1.4, 2.3)
callCIF(cif, "foo", "a", 2.3)



void = prepCIF(voidType)
callCIF(void, "voidCall")

dbl = prepCIF(doubleType, list(pointerType, sint32Type))
x = 1:4
y = callCIF(dbl, "arrayCall", arr = x, length(x))

y$inputs[[1]] # the copy of x is now changed. 
x             # has not changed
y$inputs$arr


library(Rffi)
cif = CIF(pointerType, list(pointerType, uint32Type))
x = c(1, 2, 3, 4)
y = callCIF(cif, "retPointer", x, length(x))
  # We could call this via a CIF, but it is accessible via .Call()
val = .Call("R_copyDoubleArray", y$value, length(x))
all(val == 2*x)

 ###
library(Rffi)
cif = CIF(floatType, c(floatType, floatType))
callCIF(cif, "floatCall", 3.5, 4.5)
  # call it repeatedly to see if there are any issues with corrupt memory
replicate(100, callCIF(cif, "floatCall", 3.5, 4.5))


cif = CIF(stringType)
ans = callCIF(cif, "retString")
print(ans)

cif = CIF(sint32Type, list(stringType))
ans = callCIF(cif, "strInput", "abcdef")
print(ans)

