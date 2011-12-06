# call execl(path, filename1, filename2, filename3)

library(Rffi)


if(FALSE) {
   # this will exit R and
 cif5 = CIF(sint32Type, replicate(5, stringType, simplify = FALSE))  
 callCIF(cif5, "execl", "/bin/ls", "-hal", "INSTALL", "Makefile", NULL)
}

cif = CIF(sint32Type, list(stringType, sint32Type, doubleType))
callCIF(cif, "printf", "%d...%lf\n", 10L, pi)
