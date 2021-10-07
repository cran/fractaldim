\name{fractaldim-package}
\alias{fractaldim-package}
\alias{fractaldim}
\docType{package}
\title{
Estimating Fractal Dimensions}
\description{
Implements various methods for estimating fractal dimension of time series and 2-dimensional data.}
\details{
The package provides tools for estimating fractal dimension of one- or two-dimensional data, using methods described in Gneiting et al. (2010). The user can take an advantage of the available sliding window technique in which a window of a given size is slided along the data and an estimate is obtained for each position.

The main function is \code{\link{fd.estimate}} which can be used for one dimensional time series, as well as for two dimensional data. It computes one estimate for each method and each sliding window. 
It is a wrapper for lower level functions for computing just one estimate on the given data, see \code{\link{fd.estim.method}} for details.  
}
\author{
Hana Sevcikova <hanas@uw.edu>, Tilmann Gneiting <tilmann@stat.washington.edu>, 
Don Percival <dbp@apl.washington.edu>

Maintainer: Hana Sevcikova <hanas@uw.edu>
}
\references{
Gneiting, T., Sevcikova, H. and Percival, D. B. (2012). Estimators of fractal dimension: Assessing the smoothness of time series and spatial data. Statistical Science, 27(2), 247-277. <doi:10.1214/11-STS370> (Version as technical report available at \url{https://stat.uw.edu/sites/default/files/files/reports/2010/tr577.pdf})
}

\keyword{ package }
\seealso{
 \code{\link{fd.estimate}}, \code{\link{fd.estim.method}}
}
%\examples{
%}
