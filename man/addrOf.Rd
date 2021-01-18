\name{addrOf}
\alias{addrOf}
\alias{addrOf,RCReference-method}
\alias{addrOf,externalptr-method}
\title{Get the address of a native data instance}
\description{
  This function returns a pointer containing the
  address of the specified C-level/native data instance.
  This allocates a pointer and fills it with the
  address of the object.
  This is used when we want to pass the address
  of a C object to a C routine so that its
  contents can be modified by that routine.
  In other words, this is similar to when we
  pass an argument to a C routine by taking
  its address as \code{foo(&obj)}.

  The native routine \code{R_address_of} returns the address of
  the externalptr value, so is the address of the pointer.
}
\usage{
addrOf(x, ...) 
}
\arguments{
  \item{x}{the reference to the native object}
%  \item{addFinalizer}{the name of a routine, or the resolved reference
%   to the symbol which is used to free the memory associated with the
%    newly created pointer used to store the address of the pointer in \code{x}.
%   }
  \item{\dots}{additional parameters for methods.}
}
\value{
  an \code{externalptr}.
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{callCIF}}
  \code{\link{alloc}}
}
\examples{
   # We describe a struct that is defined in test.c of this package
  myStruct.type = structType(list(s = sint16Type, i = sint32Type, d = doubleType, str = stringType))

   # The routine setStructP takes the address of a pointer to a
   # MyStruct instance and then populates it. So the CIF is just a
   # pointer type and a void return type.
  cif = CIF(voidType, list(pointerType))

   # Allocate the MyStruct instance.
  ptr = alloc(myStruct.type)
   # Call the setStructP routine, but pass the address of ptr
  ans = callCIF(cif, "setStructP", ptr@ref) # addrOf(ptr))

   # Now get the contents of ptr.
   getStructValue(ptr, myStruct.type)

   ptr = alloc(myStruct.type)
   getStructValue(ptr, myStruct.type)
   # XX Fix this "naked" call to R_address_of.
   ans = callCIF(cif, "setStructPAddr", .Call("R_address_of", ptr@ref)) 
   getStructValue(ptr, myStruct.type)
}
\keyword{programming}
\keyword{interface}

