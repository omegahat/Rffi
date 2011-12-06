#include <Rdefines.h>
double
R_myFun(double x1, void * x2)
{
     SEXP call, ans, ptr;
     PROTECT(ptr = call = allocVector(LANGSXP, 2));
     SETCAR(ptr, (SEXP) x2); ptr = CDR(ptr);
     SETCAR(ptr, ScalarReal( x1 )); ptr = CDR(ptr);
     ans = Rf_eval(call, R_GlobalEnv);
     UNPROTECT(1);
     return(( double ) asReal( ans ));
}
