library(Rffi)

cif = CIF(sint64Type, list(stringType, stringType, sint32Type))
callCIF(cif, "strtol", "10", NULL, 10)
callCIF(cif, "strtol", "0x3", NULL, 16)

