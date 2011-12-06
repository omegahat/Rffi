\name{setSlots}
\alias{setSlots}
\title{Run-time helper function to set slots of an object by name}
\description{
  This function is used by some of the programmatically generated
  to fill in slots in an R object. The main use is when copying
  fields in a reference to a structure into an R object with
  slots paralleling the fields in the struct.
  This occurs in the coercion method from an external pointer to an
  R class paralleling the C-level struct.
}
\usage{
setSlots(els, obj)
}
\arguments{
  \item{els}{a named list of the elements to be copied into the
    corresponding slots}
  \item{obj}{the R object to be populated and assumed to have the
    appropriate slots}
}
\value{
 \code{obj}, with the relevant slots assigned values from \code{els}
}
\author{
Duncan Temple Lang
}

\seealso{
 \code{\link[RGCCTUFFI]{defStructClass}}
}
\examples{
  setClass("foo", representation(a = "integer",
                                 b = "character",
                                 d = "data.frame"))

  i = new("foo")
  i = setSlots(list(b = "a string", d = mtcars), i)

  i = setSlots(list(a = 10L), i)
}
\keyword{programming}
\keyword{interface}
