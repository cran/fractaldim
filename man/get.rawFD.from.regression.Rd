\name{get.rawFD.from.regression}
\alias{get.rawFD.from.regression}
\alias{FDloglog}
\alias{summary.FDloglog}

\title{
Obtaining Regression Object
}
\description{
Obtaining and summarizing result of a linear regression of the log-log plot, object of class \code{FDloglog}.
}
\usage{
get.rawFD.from.regression(x, y, leaveout = 0)

\method{summary}{FDloglog}(object, \dots)
}
\arguments{
  \item{x}{Values of the x-axis.}
  \item{y}{Values of the y-axis.}
  \item{leaveout}{Number of points (from the beginning of the arrays) to leave out of the regression.}
  \item{object}{Object of class \code{FDloglog}.}
  \item{\dots}{Not used.}
}

\value{
Function \code{get.rawFD.from.regression} returns an object of class \code{FDloglog} with the following components:
  \item{alpha, intercept}{Slope and intercept of the regression.}
  \item{x, y}{x and y values, including the \code{leaveout}.}
  \item{n}{Length of \code{x}.}
  \item{lsq}{The least squared of the regression.}
}

\author{
Hana Sevcikova
}

\seealso{
\code{\link{fd.estimate}}, \code{\link{fd.estim.method}}
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ regression }
