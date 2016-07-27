library(Rffi)
cif = CIF(sexpType, sexpType)

f =
function(x)
{
    y = callCIF(cif, "R_identity",  x)
    stopifnot(identical(x, y))
    y
}


f(1:3)
f(as.numeric(1:13))
f(LETTERS)
f(list(a = 1:3, b = as.numeric(1:10), c = LETTERS))


