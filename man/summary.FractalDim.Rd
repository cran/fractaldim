\name{summary.FractalDim}
\alias{summary.FractalDim}
\title{Summary for an Object of Class FractalDim}
\description{The function prints summary of estimates in a
  \code{FractalDim} object.}
\usage{
\method{summary}{FractalDim} (object, \dots)
}
\arguments{
  \item{object}{An object of class \code{FractalDim}.}
  \item{\dots}{Not used.}
}
\details{
  The function prints information about the grid on which the estimates
  were obtained.  For each method it
  shows the mean and standard deviation of data in each of the two
components (fd and scale).
}
\seealso{\code{\link{fd.estimate}}}
\keyword{ts}
