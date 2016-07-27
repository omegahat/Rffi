\name{TypedPointer}
\alias{TypedPointer-class}
\alias{typedPointer}
\alias{+,TypedPointer,numeric-method}
\alias{[[,TypedPointer,numeric,ANY-method}
\title{An instance of a native pointer and its data type}
\description{
  This represents an instance of a pointer (not a generic, reusable type).
  We have the address in memory for the pointer value and also the type
  of data structure to which it points.
}
\usage{
typedPointer(ptr, elType, obj = new("TypedPointer"))
}
\arguments{
  \item{ptr}{the value of this pointer, i.e. the location in memory to
    which it points. This must be an \code{externalptr}.}
  \item{elType}{the type of the data to which the pointer \code{ptr}
    points.  This must be an instance of \code{\link{FFIType-class}}
   }
  \item{obj}{an instance of the class to return.
    Generally this will not be specified by the caller.
    It is provided as a parameter so that one can create subclasses
    and then use this contructor for these.
   }
}
 \value{
   The function \code{typedPointer} returns the updated \code{obj},
   typically the default class \code{TypedPointer}.
 }
 \author{Duncan Temple Lang}
 \seealso{\code{\link{FFIType-class}} for other classes and types.}
 
 