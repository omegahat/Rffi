\name{alloc}
\alias{alloc}
\alias{allocPointer}
\alias{alloc,numeric-method}
\alias{alloc,StructFFIType-method}
\alias{alloc,FFIType-method}
\title{Allocate memory}
\description{
  This function and its methods dynamically allocate
  memory (using the C routine calloc).
  This allocates the appropriate number of bytes to accomodate
  the specified type.
  By default, the function arranges to garbage collect the
  allocated memory when it is no longer referenced by an
  R object. This may be undesirable as the memory may
  still be in use by C code. In this case, one
  can avoid garbage collection by specifying
  \code{FALSE} or \code{NULL} for the \code{finalizer}
  argument.
}
\usage{
alloc(nbytes, finalizer = getNativeSymbolInfo("R_free")$address, ...)
}
\arguments{
  \item{nbytes}{the number of bytes to allocate or the
    \code{FFIType} object that identifies the type of object
    being allocated.
 }
  \item{finalizer}{
    a logical, NativeSymbolInfo, NativeSymbol or character string
    that indicates which the C routine as a symbol
    to use  to free the memory once it is no longer referenced
    in R.  A logical value of \code{TRUE} indicates that we should use the
    routine \code{R_free}. A  value of \code{FALSE} or \code{NULL}
    indicates no finalizer should be registered.
}
  \item{\dots}{additional parameters for methods, e.g. the class or
    instance of an R type to coerce the newly created pointer to.}
}

\value{
   An external pointer object.
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{addFinalizer}}
  \code{\link{free}}
}
\examples{
  ptr = alloc(10)
  gc()
  rm(ptr)
  gc()

  i = alloc(sint32Type)
  callCIF(CIF(voidType, pointerType), "fillInt", i, returnInputs = FALSE)
  getNativeValue(i, sint32Type)

    # these are somewhat dangerous.
    # They rely on the externalptr being a pointer to a 32-bit int.
  setAs("externalptr", "integer",
         function(from)
           getNativeValue(from, sint32Type))
  setAs("RCReference", "integer",
         function(from)
           getNativeValue(from, sint32Type))
  as(i, "integer")
}
\keyword{programming}
\keyword{interface}

