#define USE_RINTERNALS
#include "converters.h"

SEXP convertStructToR(void *val, ffi_type *type);
void *convertRToStruct(SEXP r_val, ffi_type *type);



SEXP
R_isFFIType(SEXP r_type, SEXP r_target)
{
    ffi_type *type = GET_FFI_TYPE_REF(r_type);
    ffi_type *target = GET_FFI_TYPE_REF(r_target);
    return(ScalarLogical(type == target || type->type == target->type));
}

int
R_is(SEXP val, const char * const klass)
{
    SEXP expr, ans;
    PROTECT(expr = allocVector(LANGSXP, 3));
    SETCAR(expr, Rf_install("is"));
    SETCAR(CDR(expr), val);
    SETCAR(CDR(CDR(expr)), ScalarString(mkChar(klass)));
    ans = Rf_eval(expr, R_GlobalEnv);
    UNPROTECT(1);
    return(LOGICAL(ans)[0]);
}

void *
convertToNative(void **val, SEXP r_val, ffi_type *type) /* need something about copying, to control memory recollection*/
{
    void *ans = NULL;



    if(type == &ffi_type_sexp) {
	SEXP *p = (SEXP *) R_alloc(sizeof(SEXP), 1);
	*p = r_val;
	ans = p;
    } else  if(type == &ffi_type_pointer) {
	SEXPREC_ALIGN *p;
        if(r_val == R_NilValue) 
	    ans = NULL;
        else if(IS_S4_OBJECT(r_val) && R_is(r_val, "AddressOf")) {
	    ans =  getAddressOfExtPtr(GET_SLOT(r_val, Rf_install("ref")));
	}
        else if(IS_S4_OBJECT(r_val) && R_is(r_val, "RNativeReference")) {
	    ans = R_ExternalPtrAddr(GET_SLOT(r_val, Rf_install("ref")));
	} else {

	/* Should be looking at the element type, not at r_val. */
   	 switch(TYPEOF(r_val)) {
	    case INTSXP:
	    case LGLSXP:
	    {
		p = ((SEXPREC_ALIGN *) r_val) + 1;
		ans = p;
		/* ans = &r_val + sizeof(SEXPREC_ALIGN*); */ /* INTEGER(r_val); */
	    }
		break;
	    case REALSXP:
		p = ((SEXPREC_ALIGN *) r_val) + 1;
		ans = p; /* REAL(r_val); */
		break;
   	    case STRSXP:  /*XXX What should happen is not clear here. The char ** or the single */
		ans = Rf_length(r_val) ? CHAR(STRING_ELT(r_val, 0)) : NULL;
		break;
   	    case EXTPTRSXP:
		ans = R_ExternalPtrAddr(r_val);
		break;
   	    case CLOSXP:
		ans = r_val;
		break;
     	     case RAWSXP:
		 ans = RAW(r_val);
		 break;
  	     default:
		 PROBLEM "unhandled conversion from R type (%d) to native FFI type", TYPEOF(r_val)
		     ERROR;
		 break;
	}
      }
    } else {
	if(type->type == FFI_TYPE_STRUCT) {
	    ans = convertRToStruct(r_val, type);
	} else if(type == &ffi_type_string) {
	    const char * * tmp;
	    tmp = (const char *  * ) R_alloc(sizeof(char *), 1);
	    if(r_val == R_NilValue)
		*tmp = NULL;
	    else 
		*tmp = CHAR(STRING_ELT(r_val, 0));
	    ans = tmp;
	} else if(type == &ffi_type_double) {
	    ans = REAL(r_val);
	}  else if(type == &ffi_type_float) {
	    /* We allocate a float, populate it with the value and return
               a pointer to that new float. It is released when we return from the .Call(). */
	    float *tmp = (float *) R_alloc(sizeof(float), 1);
	    *tmp = REAL(r_val)[0];
	    ans = tmp;
	} else if(type == &ffi_type_sint32) {
#if 1
/*experiment*/
	    if(IS_S4_OBJECT(r_val) && R_is(r_val, "RNativeReference")) {
		void **tmp = (void **) malloc(sizeof(void *));
		*tmp  = R_ExternalPtrAddr(GET_SLOT(r_val, Rf_install("ref"))) ;
		return(tmp);
	    }
#endif

	    if(TYPEOF(r_val) == INTSXP) {
		ans = INTEGER(r_val);
     	    } else if(IS_S4_OBJECT(r_val) && R_is(r_val, "RNativeReference")) {
		ans = (int *) R_ExternalPtrAddr(GET_SLOT(r_val, Rf_install("ref")));
 	    } else {
		int *i = (int *) R_alloc(sizeof(int), 1);
		i[0] = INTEGER(coerceVector(r_val, INTSXP))[0];
		ans = i;
	    }
	} else if(type == &ffi_type_sint16) {
	    short *s = (short *) R_alloc(1, 16);
	    *s = INTEGER(coerceVector(r_val, INTSXP))[0];
	    ans = s;
	} else if(type == &ffi_type_uint32) {
	    unsigned int *tmp = (unsigned int *) R_alloc(sizeof(unsigned int), 1);
	    *tmp = TYPEOF(r_val) == REALSXP ? REAL(r_val)[0] : INTEGER(r_val)[0];
	    ans = tmp;
	} else if(type == &ffi_type_uint16) {
	    unsigned short *tmp = (unsigned short *) R_alloc(sizeof(unsigned short), 1);
	    *tmp = TYPEOF(r_val) == REALSXP ? REAL(r_val)[0] : INTEGER(r_val)[0];
	    ans = tmp;
	}
    }

    /* Rprintf("convert->native: %p\n", ans); */
    return(ans);
}

SEXP
convertFromNative(void *val, ffi_type *type)
{
    SEXP ans = R_NilValue;
    if(type == &ffi_type_sexp)
	ans = (SEXP) val;
    else if(type->type == FFI_TYPE_STRUCT) {
	ans = convertStructToR(val, type);
    } else  if(type == &ffi_type_sint32 || type->type == ffi_type_sint32.type)
	ans = ScalarInteger( * (int *) val);
    else if(type == &ffi_type_uint32 || type->type == ffi_type_uint32.type)
	ans = ScalarReal( * (unsigned int *) val);
    else if(type == &ffi_type_sint16 || type->type == ffi_type_sint16.type)
	ans = ScalarInteger( * (short *) val);
    else if(type == &ffi_type_uint16 || type->type == ffi_type_uint16.type)
	ans = ScalarInteger( * (unsigned short *) val);
    else if(type == &ffi_type_uint64 || type->type == ffi_type_uint64.type)
	ans = ScalarReal( * (__uint64_t *) val);
    else if(type == &ffi_type_double || type->type == ffi_type_double.type)
	ans = ScalarReal( * (double *) val);
    else if(type == &ffi_type_float || type->type == ffi_type_float.type)
	ans = ScalarReal( * (float *) val);
    else if(type->elements && type->elements == &ffi_string_array_element_types)
	ans = val && *((char *) val) ? ScalarString(mkChar( (char *) val)) : NEW_CHARACTER(0);
    else if(type == &ffi_type_string)
	ans = val && *((char **) val) ? ScalarString(mkChar( * (char **) val)) : NEW_CHARACTER(0);
    else if(type == &ffi_type_pointer || (type->type == ffi_type_pointer.type && type->elements == NULL)) 
	ans = R_MakeExternalPtr(*(void **)val, Rf_install("generic pointer"), R_NilValue);
    else if(type->type == ffi_type_pointer.type)  /* So we have a type in the elements
					     * describing the contents
					     * to which this
					     * points. Don't have length */ {
	ans = R_MakeExternalPtr(*(void **)val, Rf_install("generic pointer"), R_NilValue);
    } else
	PROBLEM "didn't convert type to R"
	    WARN;

    return(ans);
}


/* Callable from R, e.g. for a global variable. */
SEXP
R_convertFromNative(SEXP r_val, SEXP r_type)
{

    void *val = R_ExternalPtrAddr(r_val);
    ffi_type *type = GET_FFI_TYPE_REF(r_type);
    return(convertFromNative(val, type));
}


/* ******************* For structures ************************* */
int
computeNextOffset(int cur, ffi_type *curType, ffi_type *nextType)
{
    int fac, rem;
    cur += curType->size;  // this moves us to the end of the current
			   // object.
    // now we have to get the alignment.
    fac = cur/nextType->alignment;
    rem = cur % nextType->alignment;
    if(rem > 0)
	cur = (fac + 1) * nextType->alignment;

    return(cur);
}

SEXP
showStructType(SEXP r_type)
{
    ffi_type *t = GET_FFI_TYPE_REF(r_type);
    ffi_type **p = t->elements;
    int i;
    for(i = 0; p && *p; p++, i++) {
	Rprintf("%d) %d %d %d\n", i, (int) (*p)->alignment, (int) (*p)->size, (int) (*p)->type);
    }
    return(R_NilValue);
}

SEXP
convertStructToR(void *val, ffi_type *type)
{
    int off = 0, numEls = 0, i;
    ffi_type **els;
    SEXP ans;
    char *p;

    if(!type->elements) {
	PROBLEM "no type information for elements of structure"
	    ERROR;
    }
    els = type->elements;
    while(*(els++))
	numEls++;

    PROTECT(ans = NEW_LIST(numEls));
    
    els = type->elements;
    p = (char *) val;
/*XXX need to do something with alignment and size to make portable. */
    for(i = 0; i < numEls; i++) {
	SET_VECTOR_ELT(ans, i, convertFromNative((void *) (p + off), els[i]));
	if(i < numEls-1)
	    off = computeNextOffset(off, els[i], els[i+1]);  // off += els[i+1]->alignment;
    }
    UNPROTECT(1);
    return(ans);

}

SEXP
R_convertStructToR(SEXP r_ptr, SEXP r_type) 
{
     ffi_type *type =  GET_FFI_TYPE_REF(r_type);
     void *ptr = R_ExternalPtrAddr(r_ptr);

    return(convertStructToR(ptr, type));
}


SEXP
convertStructElementToR(void *val, int which, ffi_type *type)
{
    int off = 0, numEls = 0, i;
    ffi_type **els;
    SEXP ans;
    char *p;

    if(!type->elements) {
	PROBLEM "no type information for elements of structure"
	    ERROR;
    }
    els = type->elements;
    while(*(els++))
	numEls++;

   
    els = type->elements;
    p = (char *) val;
/*XXX need to do something with alignment and size to make portable. */
    for(i = 0; i < which; i++) {
	if(i < numEls-1)
	    off = computeNextOffset(off, els[i], els[i+1]);  // off += els[i+1]->alignment;
    }

    ans =  convertFromNative((void *) (p + off), els[which]);
    return(ans);

}

SEXP
R_getStructElement(SEXP r_ptr, SEXP r_type, SEXP r_which)
{
    void *ptr;
    ffi_type *type;

    type = GET_FFI_TYPE_REF(r_type);
    ptr = R_ExternalPtrAddr(r_ptr);
    if(!ptr || !type) {
	PROBLEM "NULL pointer passed to R_getStructElement"
	    ERROR;
    }
    return(convertStructElementToR(ptr, INTEGER(r_which)[0], type));
}

#include <stdlib.h>



SEXP
showOffsets(SEXP r_type)
{
  ffi_type *type = GET_FFI_TYPE_REF(r_type), **els;
  int offset = 0, i;
  for(i = 0, els = type->elements;  *els; i++, els++) {
      Rprintf( "%d) %d\n", i, offset);
      if(els[1])
	  offset = computeNextOffset(offset, els[0], els[1]);
  }
  return(R_NilValue);
}

void *
convertRToStruct(SEXP r_val, ffi_type *type)
{
    ffi_type **els;
    int i, offset = 0, size = 0, numEls = 0;
    char *p;
    void *ans;

    if(!type->elements) {
	PROBLEM "no type information for elements of structure"
	    ERROR;
    }

    for(i = 0, els = type->elements; *els; i++, els++) {
	numEls++;
	size += (*els)->size;
    }
    ans = R_alloc(size, 1);
    p = ans;

    els = type->elements;
    for(i = 0; i < numEls; i++) {
	memcpy(p + offset, convertToNative(NULL, VECTOR_ELT(r_val, i), els[i]), els[i]->size);
	if(i < numEls-1) 
	   offset = computeNextOffset(offset, els[i], els[i+1]);
    }
    return(ans);
}




SEXP
R_getStructInfo(SEXP r_type)
{
    int off = 0, numEls = 0, i;
    ffi_type **els;
    SEXP ans;

    ffi_type *type;

    type = GET_FFI_TYPE_REF(r_type);

    if(!type->elements) {
	PROBLEM "no type information for elements of structure"
	    ERROR;
    }
    els = type->elements;
    while(*(els++))
	numEls++;

   
    els = type->elements;


    PROTECT(ans = NEW_INTEGER(numEls + 1));

    for(i = 0; i < numEls; i++) {
	INTEGER(ans)[i] = off;
	if(i < numEls-1)
	    off = computeNextOffset(off, els[i], els[i+1]);  // off += els[i+1]->alignment;
    }
    INTEGER(ans)[numEls] = off + els[numEls-1]->size;
    UNPROTECT(1);

    return(ans);

}



#include <stdlib.h>

SEXP
R_ffi_calloc(SEXP num)
{
    void *ans;
    ans = calloc(1, INTEGER(num)[0]);
    return(R_MakeExternalPtr(ans, Rf_install("pointer"), R_NilValue));
}



SEXP
R_getPointerOffset(SEXP r_ptr, SEXP r_offset)
{
   int off = INTEGER(r_offset)[0];
   void *ptr = R_ExternalPtrAddr(GET_SLOT(r_ptr, Rf_install("ref")));

   return(R_MakeExternalPtr(ptr + off, Rf_install("generic pointer"), R_NilValue));
}
