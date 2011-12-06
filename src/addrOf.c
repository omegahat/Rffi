#include <stdlib.h>

#define USE_RINTERNALS 1
#include <Rinternals.h>


void *
getAddressOfExtPtr(SEXP val)
{
    return( & EXTPTR_PTR(val) );
}

SEXP
R_address_of(SEXP r_ref)
{
    void **ptr = (void **) malloc(sizeof(void *));
    *ptr = & EXTPTR_PTR(r_ref); // R_ExternalPtrAddr(r_ref);
    return(R_MakeExternalPtr(& EXTPTR_PTR(r_ref), Rf_install("pointer_address"), R_NilValue));
}



#define ENABLE_TEST_CODE 1
#ifdef ENABLE_TEST_CODE

static const char *String = "This is to test R_address_of";
void
testAddrOf(const char **x)
{
    *x =  String;
}

void
itestAddrOf(int *i)
{
    *i = 101;
}

void
dtestAddrOf(int *d)
{
    *d = 3.14159;
}

void
fillIArray(int *d, int len)
{
    for(int i = 0; i < len; i++) {
	d[i] = len + i;
    }
}

SEXP
showIntPtr(SEXP r_ref)
{
    int val =  (int) R_ExternalPtrAddr(r_ref);
    fprintf(stderr, "%d\n", val);
    return(ScalarInteger(val));
}


#include <Rdefines.h>

SEXP
R_getIntArray(SEXP r_ptr, SEXP r_len)
{
    int len = INTEGER(r_len)[0];
    int *d = R_ExternalPtrAddr(r_ptr);
    SEXP ans;

    ans = NEW_INTEGER(len);
    for(int i = 0; i < len ; i++)
	INTEGER(ans)[i] = d[i];

    return(ans);
}

int TestIArray[] = {1, 3, 5, 7, 11};

void
getTestIArray(int **ptr)
{
    *ptr = TestIArray;
}

double TestDArray[] = {1.2, 3.3, 5.5, 7.7, 11.11};

void
getTestDArray(double **ptr)
{
    *ptr = TestDArray;
}


typedef struct {
    int i;
    double d;
    char *str;
} MyStruct;

void
fillStruct(MyStruct *ptr)
{
    ptr->i = 101;
    ptr->d = 3.141593;
    ptr->str = strdup("This is a duplicated string");
}


#endif
