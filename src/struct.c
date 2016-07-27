#include "converters.h"

#include <stdlib.h>

SEXP
R_create_ffi_struct_type(SEXP elTypes)
{
   ffi_type *t = (ffi_type *) calloc(1, sizeof(ffi_type));

   int ntypes = Rf_length(elTypes), i;

   t->size = t->alignment = 0;
   t->type = FFI_TYPE_STRUCT;
   t->elements = (ffi_type **) malloc((ntypes + 1) * sizeof(ffi_type *));

   for(i = 0; i < ntypes; i++) {
       SEXP el = VECTOR_ELT(elTypes, i);
       t->elements[i] = GET_FFI_TYPE_REF(el); 
   }
   t->elements[ntypes] = NULL;

   return(R_MakeExternalPtr(t, Rf_install("ffi_type"), R_NilValue));
}







void
R_free(SEXP rptr)
{
    void *ptr =  R_ExternalPtrAddr(rptr);

    if(ptr) {
	free(ptr);
	R_ClearExternalPtr(rptr);
    }
}

void
R_verbose_free(SEXP rptr)
{
    void *ptr =  R_ExternalPtrAddr(rptr);

    Rprintf("freeing %p\n", ptr);

    if(ptr) {
	free(ptr);
	R_ClearExternalPtr(rptr);
    }
}




SEXP
R_setCFinalizer(SEXP extptr, SEXP sym)
{
    R_RegisterCFinalizer(extptr, R_ExternalPtrAddr(sym));
    return(R_NilValue);
}



