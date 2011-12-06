#include <stdlib.h>
#include "converters.h"

SEXP
R_getDefaultABI()
{
    return(ScalarInteger(FFI_DEFAULT_ABI));
}

ffi_type *string_type_elements[] = {&ffi_type_uint8};
ffi_type ffi_type_string = { sizeof(char*), 8, FFI_TYPE_POINTER, string_type_elements};


ffi_type *sexp_type_elements[] = {&ffi_type_uint8};
ffi_type ffi_type_sexp = { sizeof(char*), 8, FFI_TYPE_POINTER, sexp_type_elements};

#define MAKE_R_FFI_TYPE(type) R_make_R_ffi_type(type)

SEXP
R_make_R_ffi_type(ffi_type *type)
{
    SEXP ans, klass;
    PROTECT(klass = MAKE_CLASS(type->type == FFI_TYPE_STRUCT ? "StructFFIType" : "ScalarFFIType"));
    PROTECT(ans = NEW(klass));
    SET_SLOT(ans, Rf_install("ref"),  R_MakeExternalPtr(type, Rf_install("ffi_type"), R_NilValue));
    UNPROTECT(2);
    return(ans);
}

SEXP
R_getDefinedTypes()
{
    ffi_type *types[] = {
	&ffi_type_void,
	&ffi_type_uint8,
	&ffi_type_sint8,
	&ffi_type_uint16,
	&ffi_type_sint16,
	&ffi_type_uint32,
	&ffi_type_sint32,
	&ffi_type_uint64,
	&ffi_type_sint64,
	&ffi_type_float,
	&ffi_type_double,
	&ffi_type_longdouble,
	&ffi_type_pointer,
        &ffi_type_string,
        &ffi_type_sexp 
    };

    SEXP ans;
    int n = sizeof(types)/sizeof(types[0]), i;

    ffi_type_sexp = ffi_type_pointer;

    PROTECT(ans = NEW_LIST(n));
    for(i = 0; i < n; i++)
         // don't use this here MAKE_R_FFI_TYPE(types[i]));
         // classes haven't been exported yet in the .onLoad
	SET_VECTOR_ELT(ans, i, R_MakeExternalPtr(types[i], Rf_install("ffi_type"), R_NilValue)); 
    UNPROTECT(1);
    return(ans);
}


void
releaseCIF(SEXP obj)
{
    ffi_cif *cif = (ffi_cif *) R_ExternalPtrAddr(obj);
    if(!cif) 
	return;

    if(cif->arg_types)
	free(cif->arg_types);
    /* Free any of the elements that are not built-in constants in
     * libffi.
       Do same for ret_type */

    free(cif);
}

SEXP
makeCIFSEXP(ffi_cif *ptr, ffi_type **argTypes, ffi_type *retType, SEXP r_obj, SEXP pointerInputs)
{
    SEXP  tmp;
    SET_SLOT(r_obj, Rf_install("ref"), tmp = R_MakeExternalPtr(ptr, Rf_install("ffi_cif"), R_NilValue));
    R_RegisterCFinalizer(tmp, releaseCIF);
    SET_SLOT(r_obj, Rf_install("pointerParameters"), pointerInputs);
    return(r_obj);
}



SEXP
R_ffi_prep_cif(SEXP r_abi, SEXP r_retType, SEXP r_argTypes, SEXP r_obj)
{
    ffi_cif *cif;
    ffi_type *retType;
    ffi_type **argTypes = NULL;
    int nargs = Rf_length(r_argTypes), i;
    ffi_status status;
    SEXP pointerInputs, ans;

    cif = calloc(1, sizeof(ffi_cif));
    if(!cif) {
	PROBLEM "can't allocate ffi_cif structure"
	    ERROR;
    }

    PROTECT(pointerInputs = NEW_LOGICAL(nargs));
    if(nargs > 0) {
	argTypes = (ffi_type **) malloc(sizeof(ffi_type *) * nargs);

	for(i = 0; i < nargs; i++) {
	    argTypes[i] =  GET_FFI_TYPE_REF(VECTOR_ELT(r_argTypes, i));
	    LOGICAL(pointerInputs)[i] = (argTypes[i] == &ffi_type_pointer);
	}
    }

    retType = GET_FFI_TYPE_REF(r_retType);
    
    status = ffi_prep_cif(cif, INTEGER(r_abi)[0], nargs, retType, argTypes);
    if(status != FFI_OK) {
	free(cif);
	if(argTypes)
	    free(argTypes);
	PROBLEM "failed to prepare ffi call"
	    ERROR;
    }

    PROTECT(ans = makeCIFSEXP(cif, argTypes, retType, r_obj, pointerInputs));
    UNPROTECT(2);
    return(ans);
}


SEXP
R_ffi_call(SEXP r_cif, SEXP r_args, SEXP r_sym)
{
    void *sym = R_ExternalPtrAddr(r_sym);
    void **retVal;

    void **args = NULL;
    unsigned int nargs, i;
    SEXP r_ans = R_NilValue;
    int isVoid;

    ffi_cif *cif;
    cif = (ffi_cif *) R_ExternalPtrAddr(r_cif);

    if(!cif) {
       PROBLEM "NULL value passed for call interface pointer"
	 ERROR;
    }

    nargs = Rf_length(r_args);
    if(nargs != cif->nargs) {
	PROBLEM "incorrect number of arguments in ffi call: %d, should be %d",
     	              (int) nargs, (int) cif->nargs
	    ERROR;
    }

    if(nargs > 0) {
	void **indirect;
	args = (void **) R_alloc(sizeof(void *), nargs);
	indirect = (void **) R_alloc(sizeof(void *), nargs);
	if(!args || !indirect) {
	    PROBLEM "cannot allocate space for vector of arguments in ffi call"
		ERROR;
	}

	for(i = 0; i < nargs ; i++) {
	    void *tmp;
	    tmp = convertToNative(args + i, VECTOR_ELT(r_args, i), cif->arg_types[i]);
	    if(cif->arg_types[i] == &ffi_type_pointer) {
		args[i] = indirect + i;
	        indirect[i] = tmp;
	    } else
		args[i] = tmp;
	}
    }

    isVoid = (cif->rtype == &ffi_type_void || cif->rtype->type == ffi_type_void.type);

    if(!isVoid)
	retVal = (void **) R_alloc(sizeof(void *), cif->rtype->size);

    ffi_call(cif, sym, retVal, args);
/*
    if(status != FFI_OK) {
	PROBLEM "ffi call failed: %s", status == FFI_BAD_TYPEDEF ? "bad typedef" : "bad ABI"
	    ERROR;
    }
*/

    if(!isVoid)
	r_ans = convertFromNative(retVal, cif->rtype);

    return(r_ans);
}


SEXP
R_getFFITypeSize(SEXP r_type)
{
    ffi_type *type = GET_FFI_TYPE_REF(r_type);
    return(ScalarInteger(type->size));
}

static ffi_type string_array_type = { 0, 0, 0, NULL};
ffi_type ffi_string_array_element_types[1] = { {0, 0, 0, NULL} };

SEXP
R_stringArrayFFIType(SEXP len)
{
   int n = INTEGER(len)[0];
   ffi_type *ptr = calloc(1, sizeof(ffi_type));

   *ptr = ffi_type_pointer;
#if 0
#warning "Check the alignment"
#endif

   ptr->alignment = 1; /* XXX */
   ptr->size = n;
   ptr->elements = &ffi_string_array_element_types;

   SEXP ans, klass;
   PROTECT(klass = MAKE_CLASS("FixedLengthStringFFIType"));
   PROTECT(ans = NEW(klass));
   SET_SLOT(ans, Rf_install("ref"),  R_MakeExternalPtr(ptr, Rf_install("ffi_type"), R_NilValue));
   UNPROTECT(2);
   return(ans);
}


SEXP
R_isNilPointer(SEXP r_ref)
{
    void *val = GET_EXT_PTR_REF(r_ref);
    return(ScalarLogical( val ? FALSE : TRUE  ));
}

