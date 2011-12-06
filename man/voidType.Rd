\name{voidType}
\alias{voidType}
 \alias{uint8Type}
 \alias{sint8Type}
 \alias{uint16Type}
 \alias{sint16Type}
 \alias{uint32Type}
 \alias{sint32Type}
 \alias{uint64Type}
 \alias{sint64Type}
 \alias{floatType}
 \alias{doubleType}
 \alias{longdoubleType}
 \alias{pointerType}
 \alias{stringType}
 \alias{sexpType}
 \alias{getTypes}
 \alias{FFIType-class}
 \alias{PointerFFIType-class}
 \alias{StructFFIType-class}
 \alias{ScalarFFIType-class} 
 \alias{VoidFFIType-class}
 \alias{StringFFIType-class}
 \alias{FixedLengthStringFFIType-class}
\docType{data}
\title{Objects representing different native data types}
\description{
  This collection of objects provide internal constant objects
  that represent the different native types available through the
  libffi library.

  \code{stringType} is a type that is not in libffi but 
  a specific one for representing strings, i.e the char *
  type in C.

  One can create descriptions of struct types using the \code{structType}
  function.

  One can obtain a list containing references to all of the C-level
  objects via \code{getTypes()}. The elements are indexed by name,
  e.g. "void", "sint32", "double".
  We use explicit variable names to catch typos that would lead to
  \code{NULL} values, e.g. \code{getTypes()[["flat"]]}.
}
\usage{voidType}
\format{
  Each of these object is an external pointer to the C-level
  object that represents the particular type.
}
\source{
 libffi
}
\references{
 libffi.
}
%\examples{}
\keyword{datasets}
