\name{callCIF}
\alias{callCIF}
\title{Dynamically invoke a compiled routine}
\description{
  This function takes a CIF to invoke a compiled routine with a given signature
  and applies it to invoke a specific routine with that signature.
  The R inputs are converted to the appropriate types and the result
  returned as an R object.
}
\usage{
callCIF(cif, sym, ...,
        returnInputs = is(cif, "CIFWithMutableInputs") || any(cif@pointerParameters),
        .args = list(...))
}
\arguments{
  \item{cif}{the previously prepared template CIF for the given signature}
  \item{sym}{an identifier for the compiled routine to be called. This
    can be a string giving the name or, preferably, an object returned
    from a call to \code{\link[base]{getNativeSymbolInfo}} which allows
    us to specify the routine by name and containing loaded
    library/shared object (dll/so).
    One can also specify the address of the routine as an external
    pointer, again typically obtained via \code{\link[base]{getNativeSymbolInfo}}.
  }
  \item{\dots}{zero or more R objects that are passed as the inputs to
    the compiled routine, having been converted to the appropriate
    native types.}
  \item{returnInputs}{a logical value that indicates whether the
    function should return just the value returned by the compiled
    routine   or also any inputs that may have been modified by the
    routine,   i.e.  parameters that are pointers.}
   \item{.args}{the list of the individual arguments in the call to the
     routine. This can be a convenient way to pass them when they are
     already grouped into a single object rather than being specificied
     individually in the call via the \dots.
    }
}
\details{
  The invocation checks that the number of arguments matches the number
  expected by the CIF. It also performs the conversion as necessary.
}
\value{
  The function returns the value from the compiled routine, having
  converted to an appropriate R type.
}
\references{
\url{http://sourceware.org/libffi/}
}
\author{
Duncan Temple Lang
}


\seealso{
 \code{\link{CIF}}
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

   # getting a string
 cif = CIF(stringType)
 ans = callCIF(cif, "retString")
 print(ans)
}

\keyword{programming}
\keyword{interface}
