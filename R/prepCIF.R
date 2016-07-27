FFI_DEFAULT_ABI = 2  # need to compute at install time or dynamically via
                     #  .Call("R_getDefaultABI")


# If we have a PointerType we want to be able to restore that.
setClass("CIF", representation(ref = "externalptr", pointerParameters = "logical"))
setClass("CIFWithMutableInputs", contains = "CIF")

setClass("CIFWithTypedPointers", representation(types = "list", returnValue = "FFIType"), contains = "CIF")

isMutable =
function(type)
{
  isPointerType(type)
}


CIF = prepCIF =
function(retType, argTypes = list(), mutable = ans@pointerParameters,
          abi = FFI_DEFAULT_ABI, ans = new("CIF"))
{

  if(is(argTypes, "FFIType"))
     argTypes = list(argTypes)
  
  ans = .Call("R_ffi_prep_cif", as(abi, "integer"), retType, argTypes, ans)

  if(!missing(mutable)) {
     if(is.character(mutable)) {
         omutable = mutable
         mutable = match(mutable, names(argTypes))
         if(any(is.na(mutable)))
           stop("some mutable parameter names don't correspond to actual parameters: ", paste(omutable[is.na(mutable)], sep = ", "))
     }

     if(is(mutable, "numeric")) {
         tmp = logical(length(argTypes))
         tmp[mutable] = TRUE
     }
  }
  
  if(any(mutable)) {
      ans = new("CIFWithMutableInputs", ref = ans@ref, pointerParameters = mutable)
  } else
      ans@pointerParameters = mutable
  ans
}

callCIF =
function(cif, sym, ..., returnInputs = is(cif, "CIFWithMutableInputs") || any(cif@pointerParameters),
          .args = list(...))
{
  if(is.character(sym))
     sym = getNativeSymbolInfo(sym)

  if(is(sym, "NativeSymbolInfo"))
     sym = sym$address

  if(is.null(sym))
     stop("NULL value for routine to invoke")
  
  val = .Call("R_ffi_call", cif@ref, .args, sym, sexpType@ref)
  if(length(cif@pointerParameters) > 0 && (is(returnInputs, "numeric") || any(returnInputs))) {
     list(value = val,
          inputs = .args[if(is(returnInputs, "numeric") || length(returnInputs) > 1)
                            returnInputs
                         else
                            cif@pointerParameters])
  } else
     val
}
