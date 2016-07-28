library(Rffi)
# passing a pointer to a routine.
# Here we pass the address of the routine itself as a convenient pointer
# The routine prints the value of the pointer and then returns tha same value
# So we can compare the input and the result and they should have the same value.

fun = getNativeSymbolInfo("R_ptr")$address
ans = callCIF(sig, fun, fun, returnInputs = FALSE)

# Are the values of fun and ans the same, up to the attributes.
attr(fun, "class") = NULL

stopifnot(identical(fun, ans))

