\name{getStructField}
\alias{getStructField}
\alias{getStructField,externalptr,character,StructFFIType-method}
\alias{getStructField,externalptr,numeric,StructFFIType-method}
\alias{getStructField,NativeSymbol,ANY,StructFFIType-method}
\alias{getStructField,RCReference,ANY,StructFFIType-method}
\alias{getStructValue}
\title{Access a native structure from R}
\description{
  These functions allow one to access
  a compiled/native struct object from within R
  based on the description of its fields.
  We can copy the entire structure or
  access individual fields using the two functions.
}
\usage{
getStructField(ptr, id, type)
getStructValue(ptr,type)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ptr}{the reference to the native object. This should be
   an external pointer or coercable to one.}
  \item{id}{the name or index of the field of the structure to be accessed}
  \item{type}{the \code{\linkS4class{FFIType}} describing the struct's fields}
}
\value{
  \code{getStructValue} returns a list with the copies
  of the values of the fields. If names are available from
  the \code{type} description, these are used as the names of the list.

  \code{getStructField} returns the individual R equivalent of the
  current value of the corresponding field.
}

\author{
Duncan Temple Lang
}

\seealso{
\code{\link{structType}}
}
\examples{
  ptr = getNativeSymbolInfo("globalStruct")$address
  myStruct.type = structType(list(s = sint16Type, i = sint32Type, d = doubleType, str = stringType))
  getStructValue(ptr, myStruct.type)
  getStructField(ptr, 2, myStruct.type)
  getStructField(ptr, "i", myStruct.type)
}
\keyword{programming}
\keyword{interface}

