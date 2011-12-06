\name{getFFITypeSize}
\alias{sizeof}
\alias{sizeof,FFIType-method}
\alias{sizeof,StructFFIType-method}
%\alias{getFFITypeSize}
\title{Compute the number of bytes the corresponding FFI type occupies}
\description{
  This function determines the size in bytes of the specified
  FFI data type on the particular platform.
}
\usage{
sizeof(type, ...)
}
\arguments{
  \item{type}{an FFIType object}
  \item{\dots}{additional parameters for methods to define}
}
\value{
 an integer giving the size of the specified object.
}
\author{
Duncan Temple Lang
}


\seealso{
  \code{\link{structType}}
  \code{\link{doubleType}}
  \code{\link{sint32Type}}, etc.
}
\examples{
  sizeof(doubleType)
  sizeof(floatType)
  sizeof(sint32Type)
  sizeof(sint16Type)

  sizeof(structType(list(d = doubleType, i = sint32Type)))
}
\keyword{programming}
\keyword{interface}
