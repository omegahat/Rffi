\name{structType}
\alias{structType}
\alias{arrayType}
\alias{stringArrayType}
\alias{[,RCStructReference,ANY,ANY-method}
\alias{[,RCStructReference,missing,ANY-method}
\alias{[[,RCStructReference,character,ANY-method}
%XXX
\alias{$,FFIRCStructReference-method}
\title{Create a type description for a C-level structure or array}
\description{
 The \code{structType} function allows us to create new type definitions
 for C-level structures. We describe the types of each
 of the \code{struct}'s elements and can then use
 this new type in subsequent interfaces to native routines
 as return types or parameter types.

 \code{arrayType} is used to create a description of a C-level array
 by describing the type of the elements and the length of the array.

 \code{stringArrayType} is a function for creating an FFI type
 describing the specific data type which is an array of char
 elements in C.
}
\usage{
structType(types)
stringArrayType(len)
}
\arguments{
  \item{types}{a list of FFI types, either the built-in ones or other compositions for \code{struct}s}
  \item{len}{the number of char elements in the array}
}

\value{
An external pointer object referencing the newly created \code{ffi_type} object.
}
\references{
 libffi
}
\author{
Duncan Temple Lang
}
\note{
At present, names of the elements are ignored
as it is only the layout of the structure's elements
that is relevant.  In the future, we might utilize
the names to provide facilities to access individual
elements. But this will probably be done at a higher level.
}

\seealso{
 \code{\link{voidType}} and the other built-in types.
}
\examples{

 myStruct.type = structType(list(s = sint16Type, i = sint32Type, d = doubleType, str = stringType))

 cif = CIF(myStruct.type)
 callCIF(cif, "getStruct")

 cif = CIF(voidType, list(myStruct.type))
 invisible(replicate(10, callCIF(cif, "doStruct", list(-10L, 99L, 3.1415, "an R string"))))



  setClass("MyStructRef", contains = "RCStructReference")
  MyStruct.FFIType = structType(list(s = sint16Type,
                                    i = sint32Type,
                                    d = doubleType,
                                    string = stringType))

  setMethod("$", "MyStructRef",
            function(x, name) {
                 getStructField(x, name, MyStruct.FFIType)
            }) 


}
\keyword{programming}
\keyword{interface}


