library(Rffi)
 # Call with 3 extra arguments
cif = CIF(doubleType, list(stringType, sint32Type, sint32Type, sint32Type, sint32Type))

callCIF(cif, "call_varargs", "A message", 3L, 10L, 11L, 19L)


#######

cif = CIF(sint32Type, list(stringType, doubleType, sint32Type))
callCIF(cif, "printf", "A message %lf and an integer %d", 3.1415, 10L)

cif = CIF(sint32Type, list(stringType, stringType, doubleType, sint32Type))
callCIF(cif, "printf", "A string '%s', and a double with %.5lf, and an integer %d\n",
               "my string", 3.14159265, 10L)

###############

cif = CIF(voidType, replicate(5, stringType))

callCIF(cif, "call_varargs_null", "R", "--no-restore", "--slave", "foo.R", NULL)


#


library(RGCCTranslationUnit)
tu = parseTU("test.c.001t.tu")
r = getRoutines(tu)
va = r$call_varargs
