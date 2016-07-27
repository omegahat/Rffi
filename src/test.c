#include <math.h>

#include <R_ext/Print.h>

double
intCall(int x)
{
    return(x + log(x));
}

double
rdouble()
{
    return(3.1415);
}

double
foo(int x, double y)
{
    Rprintf("In foo %d %lf\n", x, y);
    return(x + y);
}

double
otherFoo(int x, double y)
{
    Rprintf("In otherFoo %d %lf\n", x, y);
    return(x - y);
}


void
voidCall()
{
    Rprintf("in voidCall\n");
}

double
arrayCall(int *vals, int len)
{
    int i;
    Rprintf("in arrayCall %p\n", vals);
    for(i = 0; i < len; i++)
	vals[i] *= 2;

    return(3.1415);
}

double
darrayCall(double * const vals, int len)
{
    int i;
    double sum = 0;
    Rprintf("in darrayCall %p\n", vals);
    for(i = 0; i < len; i++)
	sum += vals[i];

    return(sum);
}

#include <stdlib.h>

double *
retPointer(double *x, unsigned int len)
{
    int i;
    double *ans;
    ans = malloc(sizeof(double) * len);
    if(!ans)
	return(NULL);

    for(i = 0; i < len; i++)
	ans[i] = 2*x[i];

    return(ans);
}


/*R:  k = CIF(it, list(it, uint32Type)) */
int *
retIPointer(int *x, unsigned int len)
{
    int i;
    int *ans;
    ans = malloc(sizeof(int) * len);
    if(!ans)
	return(NULL);

    for(i = 0; i < len; i++)
	ans[i] = 2*x[i];

    return(ans);
}


float 
floatCall(float a, float b)
{
    return(a + b);
}


#include <Rdefines.h>

SEXP
R_copyDoubleArray(SEXP ref, SEXP rlen)
{
  int len = INTEGER(rlen)[0], i;
  SEXP ans;
  double *vals = (double *) R_ExternalPtrAddr(ref);
  if(!vals) 
      return(NEW_NUMERIC(0));

  PROTECT(ans = NEW_NUMERIC(len));
  for(i = 0; i < len; i++) 
      REAL(ans)[i] = vals[i];
  UNPROTECT(1);	
  return(ans);
}



SEXP
R_copyIntArray(SEXP ref, SEXP rlen)
{
  int len = INTEGER(rlen)[0], i;
  SEXP ans;
  int *vals = (int *) R_ExternalPtrAddr(ref);
  if(!vals) 
      return(NEW_INTEGER(0));

  PROTECT(ans = NEW_INTEGER(len));
  for(i = 0; i < len; i++) 
      INTEGER(ans)[i] = vals[i];

  UNPROTECT(1);	
  return(ans);
}

char *
retString()
{
    return("this is a string");
} 

int
strInput(char *str)
{
    return(strlen(str));
} 

typedef struct {
    short s;
    int i;
    double d;
    char *string;
} MyStruct;

void
doStruct(MyStruct s)
{
    Rprintf("doStruct: s = %d, i = %d, d = %lf, string = %s\n", (int) s.s, s.i, s.d, s.string);
}


void
doStructP(const MyStruct *s)
{
    doStruct(*s);
}

int *
constants(int *x, const double *y, const MyStruct *s)  /*, const * const *str*/
{
    x[0] = 100 + y[0] + s->d;  /* + strlen((char *) str[0]) */
    return(x);
}


char *MyString = "a string";
MyStruct
getStruct()
{
    MyStruct c = {-1, 11, 99.2};
    c.string = MyString;
    return(c);
}

MyStruct globalStruct = {-3, 104, 3.1415, "Foo"};

MyStruct *
getStructP()
{
    MyStruct *c;
    c = (MyStruct *) malloc(sizeof(MyStruct));
    c->s = -1;
    c->i =  11;
    c->d = 99.2;
    c->string = MyString;
    return(c);
}

void
setStructP(MyStruct **input)
{
    MyStruct *c;
    c = *input;
    c->s = -1;
    c->i =  11;
    c->d = 99.2;
    c->string = MyString;
}




#include <stddef.h>
void
showStruct()
{
    MyStruct m;
    int d;
    Rprintf("sizeof(MyStruct) %d\n", (int) sizeof(MyStruct));
    d = offsetof(MyStruct, s);
    Rprintf("s %d, %d\n", (int) d, (int) sizeof(m.s));
    d = offsetof(MyStruct, i);
    Rprintf("i %d, %d\n", (int) d, (int) sizeof(m.i));
    d = offsetof(MyStruct, d);
    Rprintf("d %d, %d\n", (int) d, (int) sizeof(m.d));
    d = offsetof(MyStruct, string);
    Rprintf( "string %d, %d\n", (int) d, (int) sizeof(m.string));
}


typedef struct {
    short s;
    int i;
    int ia[10];
    double d;
} MyArrStruct;

void
showArrStruct()
{
    MyArrStruct m;
    int d;
    Rprintf( "sizeof(MyStruct) %d\n", (int) sizeof(MyStruct));
    d = offsetof(MyArrStruct, s);
    Rprintf( "s %d, %d\n", (int) d, (int) sizeof(m.s));
    d = offsetof(MyArrStruct, i);
    Rprintf( "i %d, %d\n", (int) d, (int) sizeof(m.i));
    d = offsetof(MyArrStruct, ia);
    Rprintf( "ia %d, %d\n", (int) d, (int) sizeof(m.ia));
    d = offsetof(MyArrStruct, d);
    Rprintf( "d %d, %d\n", (int) d, (int) sizeof(m.d));
}

#ifdef USE_RANDOM_IN_TESTS
const long MaxRand = 2147483647;

#ifdef WIN32
int random()
{
  return rand();
}
#endif

double
myFun(double val, void *ptr)
{
    return(val + ((double)random()/(double) MaxRand));
}
#endif



double
runFunPtr(int n, double val, double (*fun)(double value, void *userData), void *data)
{
    int i;
    for(i = 0; i < n; i++) {
	Rprintf( "%d) %lf\n", i, val);
        val = fun(val, data);
    }
    return(val);
}

double
R_myFun(double val, void *data)
{
    SEXP call, ans;
    PROTECT( call = allocVector(LANGSXP, 2));
    SETCAR(call, (SEXP) data);
    SETCAR(CDR(call), ScalarReal(val));

    ans = Rf_eval(call, R_GlobalEnv);

    UNPROTECT(1);
    return(asReal(ans));
}


typedef struct {
    int i;
    double d;
    union {
	int i;
        short s;
        short a[4];
    } u;
    float f;
    void *ptr;
    int ii;
} TypeU;

void
R_union()
{

//    TypeU t;
    Rprintf( "i = %d, d = %d, u = %d, f = %d, ptr = %d, ii = %d\n",
	    (int) offsetof(TypeU, i),
	    (int) offsetof(TypeU, d),
	    (int) offsetof(TypeU, u),
	    (int) offsetof(TypeU, f),
	    (int) offsetof(TypeU, ptr),
	    (int) offsetof(TypeU, ii));
}


double
call_varargs(const char *str, int nargs, ...)
{
    double sum = 0;
    int i;
    va_list va;
    va_start(va, nargs);

    Rprintf( "%s\n", str);
    for(i = 0; i < nargs; i++) 
	sum += va_arg(va, int);

    va_end(va);

    return(sum);
}

void
call_varargs_null(const char *filename, ...)
{
//    int i;
    va_list va;
    char *ptr;
    va_start(va, filename);

    Rprintf( "%s ", filename);
    while(1) {
       ptr = va_arg(va, char *);
       if(ptr)
	   Rprintf(" %s", ptr);
       else
	   break;
    }
    Rprintf( "\n");
	       
    va_end(va);
}


int *
intArray()
{
    static int x[3];
    x[0] = 4;
    x[1] = 2;
    x[2] = 0;
    return(x);
}


void
fillInt(int *x)
{
    *x = 101;
}


/* Test we can return a SEXP as a SEXP */
SEXP
R_identity(SEXP x)
{
    return(x);
}
