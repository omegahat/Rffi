\name{CIF-class}
\Rdversion{1.1}
\docType{class}
\alias{CIF-class}

\title{Class to represent external Call InterFace (CIF)}
\description{
  This class represents a call interface for invoking native
  routines via libffi. A CIF stands for Call InterFace
  and consists of a C-level object describing the call
  and also information about which parameters are mutable
  pointers.
}
\section{Objects from the Class}{
  Objects can be created by calls of the form \code{new("CIF", ...)}.
  Typically, one uses the \code{\link{CIF}} constructor function.
}
\section{Slots}{
  \describe{
    \item{\code{ref}:}{Object of class \code{"externalptr"} representing
    the C object that is used when invoking a routine using \code{\link{callCIF}}.}
    \item{\code{pointerParameters}:}{Object of class \code{"logical"}
      indicating which of the parameters (if any) are pointers and hence
      potentially mutable in the call. These are used to return not only
      the value from the routine, but any of the inputs that might have
      been mutated.}
  }
}
\section{Methods}{
No methods defined with class "CIF" in the signature.
}
\references{
 libffi
}
\author{
 Duncan Temple Lang
}

\seealso{
 \code{\link{CIF}} and  \code{\link{callCIF}}
}
\examples{
showClass("CIF")
}
\keyword{classes}
