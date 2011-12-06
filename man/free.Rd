\name{free}
\alias{free}
\title{Explicitly release natively allocated memory}
\description{
  This function can be called to explicitly
  release/garbage collect memory associated with
  a native object.  This can also be done via a finalizer on the
  external pointer.
  This function does not have any mechanism to validate
  its input was dynamically allocated
  and has not already been released. It is
  up to the caller to call this appropriately.
}
\usage{
free(x)
}
\arguments{
  \item{x}{an external pointer or \code{\linkS4class{RCReference}}
    identifying the address of the memory to be released.}
}
\value{
  \code{NULL}. This function is used for its side-effect
  of releasing the memory associated with the object.
}
\references{
 The \code{free} C routine built-in for all platforms.
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{alloc}}
  \code{\link{addFinalizer}}
}
\examples{

 ptr = alloc(100, FALSE)
 free(ptr)

 ###############


 type = structType(list(s = sint16Type,
                        i = sint32Type,
                        d = doubleType,
                        string = stringType))

  cif = CIF(pointerType)
    # getStructP allocates the MyStruct and returns a pointer to it.
  ans = callCIF(cif, "getStructP")
  getStructValue(ans, type)

#  free(ans)
}
\keyword{programming}
\keyword{interface}
