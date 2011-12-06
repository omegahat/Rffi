\name{prepCIF}
\alias{prepCIF}
\alias{CIF}
\title{Create interface template for invoking compiled routines with a
  given signature}
\description{
  This function creates a compiled object that can be used to
  dynamically invoke a native/compiled routine from within
  R but without having to explicitly program that invocation
  in C code.
  The object can be used to invoke any compiled routine with
   the specified signature. A signature is 
}
\usage{
prepCIF(retType, argTypes = list(),
        mutable = ans@pointerParameters,
        abi = FFI_DEFAULT_ABI, ans = new("CIF"))
}
\arguments{
  \item{retType}{ an object describing the type of the return value}
  \item{argTypes}{a list of objects specifying the type of each of the
    parameters. If there is only one argument, the type can be specified
    directly without putting it in a list.}
  \item{mutable}{a logical vector, numeric vector  or character vector
    of parameter names identifying which of the parameters are
    potentially mutated/changed by the routine and so should be returned.}
  \item{abi}{the type of application binary interface. This can be
    stdcall and fastcall on some platforms. It is very rare to specify
    this and requires deep understanding of the nature of the calls on
    the particular platform}
  \item{ans}{the CIF object that will be returned with the slots filled
    in. This is a parameter to allow the caller specify a more specific
    sub-class.}
}
\value{
 An object of class (or sub-class) \code{CIF}.
}
\references{
  libffi \& its tutorial at \url{http://sourceware.org/libffi/}
}
\author{
Duncan Temple Lang
}

\seealso{
 \code{\link{callCIF}}
}
\examples{
 void = CIF(voidType)
 callCIF(void, "voidCall")

 cif = CIF(doubleType, list(sint32Type, doubleType))
 callCIF(cif, "foo", -1L, pi)

   # use this CIF in another call.
 callCIF(cif, "foo", 10L, pi)

   # and call a different routine with the same signature
 callCIF(cif, "otherFoo", 10L, pi)
}
\keyword{programming}
\keyword{interface}
