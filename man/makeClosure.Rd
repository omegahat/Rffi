\name{makeClosure}
\alias{makeClosure}
\title{Turn a function into a closure with some non-local variables}
\description{
  This function takes a function and assigns it an environment
  and then puts the specified variables into that environment
  so that they are available when the function is called
  and not in the global search path.

  This function is used when we dynamically generate code
  to interface to C routines.
}
\usage{
makeClosure(fun, ..., .els = list(...), env = new.env())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fun}{the function whose environment is to be changed}
  \item{\dots}{\code{name = value} pairs giving the variable names and
     their values that are to be stored in the function's environment.
  }  
  \item{.els}{a named list of values, providing an alternative way to
    specify the variables to be stored in the environment.}
  \item{env}{the environment to use as the function's environment}
}
\value{
 The modified function whose environment is \code{env}.
}
\author{Duncan Temple Lang}

\seealso{
  \code{\link[RGCCTUFFI]{createRFunc}}
}
\examples{
  f = function(x, y)
          x + y + z

  f = makeClosure(f, z = 2, w = "not used")
  f(1, 3)
}
\keyword{programming}
\keyword{interface}

