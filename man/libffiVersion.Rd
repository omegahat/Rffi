\name{libffiVersion}
\alias{libffiVersion}
\title{Get information about the version of libffi used in this package}
\description{
  This provides information about the installation-time version of the
  libffi code.
}
\usage{
libffiVersion(asIs = FALSE)      
}
\arguments{
\item{asIs}{a logical value. If \code{TRUE}, returns the string giving
  the simple version identifier. If \code{FALSE} (the default),
  the function attempts to separate the components into major, minor and
  patch version values}
}
\value{
  If \code{asIs} is \code{TRUE}, a string.
  If \code{asIs} is \code{FALSE}, an integer vector.
  This separates the values in the version string
  based on the separator \code{.} and 
  converts them to integers.
  This may lead to \code{NA} values if there are non-integer values.  
}
\references{
  See libffi at \url{https://sourceware.org/libffi/}.  
}
\author{
  Duncan Temple Lang
}
\examples{
 libffiVersion()
 libffiVersion(asIs = TRUE)
}
\keyword{programming}
\keyword{interface}
