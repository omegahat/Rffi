library(Rffi)

cif = CIF(doubleType, list(pointerType, sint32Type))
x = 1:10
ans = callCIF(cif, "arrayCall", x, length(x))
