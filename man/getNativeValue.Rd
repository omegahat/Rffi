\name{getNativeValue}
\alias{getNativeValue}
\title{Retrieve the value of a compiled object}
\description{
 This function allows the caller to retrieve
 the value of a compiled, native object by
 providing the address of the object and 
 a description of its type/structure.
 This can be used to retrieve global variables
 or values that are returned by reference
 from other calls to compiled routines.
}
\usage{
getNativeValue(ptr, type)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ptr}{an external pointer giving the address of the object}
  \item{type}{a CIF that describes the type/structure of the object being retrieved}
}
\value{
  The R object converted from the native address.
}
\references{
libffi
}
\author{
Duncan Temple Lang
}


\seealso{
  \code{\link{getStructValue}}
  \code{\link{getStructField}}
}
\examples{
  ptr = getNativeSymbolInfo("globalStruct")$address
  myStruct.type = structType(list(s = sint16Type, i = sint32Type, d = doubleType, str = stringType))
  getNativeValue(ptr, myStruct.type)
}
\keyword{programming}
\keyword{interface}

