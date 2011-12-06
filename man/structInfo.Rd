\name{structInfo}
\alias{structInfo}
\title{Get information about a C-level struct type description}
\description{
  This function returns information about the size and offsets
  of the fields/elements of a foreign function interface struct  definition.
}
\usage{
structInfo(type)
}
\arguments{
  \item{type}{the \code{StructFFIType} object}
}
\value{
  A list with 2 elements
  \item{size}{an integer value giving the total size of a struct
    instance}
  \item{offsets}{the byte offsets of the individual elements}
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{sizeof}}
  \code{\link{structType}}
}
\examples{
     # data structure for use in call to utsname
   type = structType(list('sysname' = stringArrayType(256),
                          'nodename' = stringArrayType(256),
                          'release' = stringArrayType(256),
                          'version' = stringArrayType(256),
                          'machine' = stringArrayType(256)))
   structInfo(type)
   sizeof(type)

   type = structType(list(d = doubleType, i = sint32Type))
   structInfo(type)
   sizeof(type)  

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{programming}
\keyword{interface}

