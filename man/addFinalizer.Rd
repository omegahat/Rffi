\name{addFinalizer}
\alias{addFinalizer}
\alias{addFinalizer,ANY,character-method}
\alias{addFinalizer,ANY,logical-method}
\alias{addFinalizer,ANY,NativeSymbol-method}
\alias{addFinalizer,ANY,NativeSymbolInfo-method}
\alias{addFinalizer,externalptr,externalptr-method}
\alias{addFinalizer,RCReference,ANY-method}

\title{Register a finalizer to garbage collect allocated memory}
\description{
  This function and its methods allow us to arrange
  a C routine to be called to garbage collect native
  memory associated with an R object.
  We use it in this package to free memory allocated for native objects.
}
\usage{
addFinalizer(obj, finalizer, default = character(),...)
}
\arguments{
  \item{obj}{the external pointer for which to register the finalizer}
  \item{finalizer}{the finalizer routine. This can be
    a string giving the name of the routine to be dynamically resolved
    by searching all DSOs/DLLs, or a \code{NativeSymbolInfo}
    or \code{NativeSymbol} object which are already resolved references
    to a native routine.
  }
  \item{default}{from RAutoGenRunTime package}
  \item{\dots}{additional arguments for methods}
}

\value{
  \code{NULL}. This is used for its side-effect of registering a finalizer.
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{alloc}}

  There are two routines in the Rffi package
  that can be used as finalizers for R external pointer objects:
  R_free and R_verbose_free. The latter can be used
  to see when the finalizer is being invoked and for what
  address in the external pointer object.
  
}
\examples{
  # call a routine that explicitly allocates its return value
  # so we arrange to free it when we no longer need it.

  myStruct.type = structType(list(s = sint16Type, i = sint32Type, d = doubleType, str = stringType))  
  cif = CIF(pointerType)

  ans = callCIF(cif, "getStructP")
  getStructValue(ans, myStruct.type)
  free(ans)

  ans = callCIF(cif, "getStructP")
  addFinalizer(ans, "R_verbose_free")
  getStructValue(ans, myStruct.type)
  rm(ans)
  gc()
}
\keyword{programming}
\keyword{interface}

