\name{pointer}
\alias{pointer}
\alias{PointerType-class}
\title{Class and function describing a pointer with information about
  the type to which it points.}
\description{
  The class \code{PointerType} is a sub-class of
  \code{PointerFFIType} and provides a description
  of a native type that is a pointer to a particular data type.
  The key difference is that this FFI type allows us to query
  the type(s) to which it points, as opposed to being a generic
  pointer to an arbitrary type.
}

\usage{
pointer(type)  
}
\arguments{
  \item{type}{an object of class \code{\link{FFIType-class}}.
      This is the data type to which this pointer points.}
}
\author{Duncan Temple Lang}
\seealso{\code{\link{FFIType-class}} for other classes and types.}
\value{
  An object of class \code{PointerType}.
  This class has a \code{elType} slot that contains the type of the
  element for this pointer type.
}