library(Rffi)
cif = CIF(sexpType, sexpType)

callCIF(cif, "R_identity",  1:3)
callCIF(cif, "R_identity",  as.numeric(1:13))
callCIF(cif, "R_identity",  LETTERS)

callCIF(cif, "R_identity",  list(a = 1:3, b = as.numeric(1:10), c = LETTERS))

