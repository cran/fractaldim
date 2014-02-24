\name{fd.estimate}
\alias{fd.estimate}
\alias{FractalDim}
\alias{fd.estimate.matrix}
\alias{fd.estimate.numeric}
\alias{fd.estimate.data.frame}

\title{Estimating Fractal Dimensions of Time Series and Two-dimensional Data}

\description{The functions compute a set of fractal dimensions \eqn{D}
for time series and two-dimensional data 
via various methods using a sliding window
technique.  There is one \eqn{D} computed for each method and for
each sliding window of a given size that is moved along the data.}

\usage{
\method{fd.estimate}{numeric} (data, methods = "madogram", window.size = length(data), 
    step.size = window.size, trim = TRUE, keep.data = FALSE, 
    keep.loglog = FALSE, parallel = FALSE, nr.nodes = NULL, 
    debuglevel = 0, \dots)
	
\method{fd.estimate}{matrix} (data, methods = "transect.var", window.size = ncol(data),
    step.size = window.size, trim = TRUE, keep.data = FALSE, 
    keep.loglog = FALSE, parallel = FALSE, nr.nodes = NULL, 
    debuglevel = 0, ...)
          }
\arguments{
  \item{data}{Vector, matrix or data frame.}
  \item{methods}{Vector of character strings specifying methods for which
    \eqn{D} is estimated. Possible values for one-dimensional data are \dQuote{\code{variogram}}, \dQuote{\code{madogram}}, \dQuote{\code{rodogram}}, \dQuote{\code{variation}},  \dQuote{\code{incr1}}, \dQuote{\code{boxcount}}, \dQuote{\code{hallwood}},  
    \dQuote{\code{periodogram}},
    \dQuote{\code{wavelet}}, \dQuote{\code{dctII}}, and \dQuote{\code{genton}}. For matrix or data frame the function accepts methods \dQuote{\code{transect.var}}, \dQuote{\code{transect.incr1}},
    \dQuote{\code{isotropic}}, \dQuote{\code{squareincr}}, and \dQuote{\code{filter1}} (see \code{\link{fd.get.available.methods}}). Alternatively, it can be a list of lists where each list item contains an entry \dQuote{name} being the method name and entries corresponding to arguments passed to the specific methods (see Example and
    \code{\link{fd.estim.method}} for details.)}
  \item{window.size}{Size (in number of data points) of the
    sliding window.  It should be between 2 and length of 
    \code{data}.}
  \item{step.size}{Number of data points by which the sliding
    window is moved.}
  \item{trim}{Logical.  If \code{TRUE}, the estimates are trimmed into the theoretically permissible interval, i.e. between 1 and 2 in one-dimensional case and between 2 and 3 in two-dimensional case.}
  \item{keep.data}{Logical.  If \code{TRUE}, the data are kept in the
    resulting object.}
  \item{keep.loglog}{Logical.  If \code{TRUE}, the resulting object contains a list with objects of class \code{\link{FDloglog}} used for the estimation in each iteration and for each method.}
  \item{parallel}{Logical determining if the process should run in parallel. If \code{TRUE}, the
    package \pkg{snowFT} is required. In such a 
    case, all local library paths must be included
    in the environment variable \code{R_LIBS}. In the one-dimensional case, the granularity of the process is given by the number of sliding windows. In the two-dimensional case, the number of spawn processes is equal to the number of sliding windows in the vertical direction.} 
  \item{nr.nodes}{Number of nodes on which the computation should be
    processed if \code{parallel} is \code{TRUE}.}
  \item{debuglevel}{Controls the amount of debugging
    messages. The functions produce messages on levels 1 - 4.}
  \item{\dots}{Arguments passed to lower level functions (defined in
    \code{\link{fd.estim.method}}).}
  }

\details{In case of one-dimensional time series, the function  initiates a sliding window
  of the given size at the beginning of the time series.  The
  window is moved along the data by the
  given step size. If \code{parallel} is \code{TRUE}, computation on each window happens in parallel.
  In the two-dimensional case, the window is initiated in the top left corner of the data matrix and moved horizontally by the given step size, as well as vertically by the same step size. If the process is running in parallel, processing each row is done in parallel. 
  In both cases, in each iteration estimates of fractal dimension for
  data within the sliding window are
  computed using the given estimation methods. 
  
  Note that the estimation results are \code{NA} for any sliding window that
  contains \code{NA} values.
  
  Arguments that are to be passed to specific methods can be given either directly, if they applies to all given methods. Or, they can be given as a list via the \code{methods} argument: There is one list per method that must  contain the entry \dQuote{name} being the method name. Remaining entries in the list corespond to one argument each (see Example below). 
}

\value{An object of class
  \code{FractalDim} which consists of the following components:
	\item{dim}{Dimension of the resulting arrays \code{fd} and
		\code{scale} (see below). 
	 In the one-dimensional case, possible values are 1 and 2.  \code{dim = 1} means that there has been only one iteration and there is one element in the above arrays per each method used. If \code{dim = 2}, rows correspond to iterations and columns correspond to methods. Estimation on two-dimensional data can in addition result in \code{dim = 3}, in which case the first and second dimensions correspond to vertical and horizontal iterations, respectively, and the third dimension corresponds to methods.}
    \item{fd}{A \code{dim}-dimensional array of fractal dimensions. }
    \item{scale}{A \code{dim}-dimensional array of scales, 
	derived from the intercept of the log-log plots on which \code{fd} 
	were computed.  Values are transformed to the scale of the
      	original data.}
    \item{methods}{Vector of methods given in the \code{methods} argument.
	The order of the elements corresponds to the order of
	estimates in the \dQuote{method}-dimension of the above \code{dim}-dimensional arrays.}
    \item{methods.coding}{Vector of internal coding of \code{methods}. 
	The order of the elements corresponds to the order in \code{methods}.}
    \item{data}{Value of the argument \code{data}, if \code{keep.data = TRUE},
    otherwise \code{NULL}.}
    \item{data.dim}{Dimension of \code{data}.}
    \item{window.size}{Size of the actual sliding window used in the computation. }
    \item{step.size}{Step size by which the sliding window was moved in the computation.}
    \item{loglog}{If \code{keep.loglog=TRUE}, this is a list containing for each iteration a lists of \code{\link{FDloglog}} objects used in the estimation, one per method. The numbering of the methods corresponds to the method order in \code{methods}.}
}

\examples{
\dontrun{
library(RandomFields)
n <- 10000
# generate a time series
rf <- GaussRF(x = c(0, 1, 1/n), model = "stable", 
       grid = TRUE, gridtriple = TRUE,
       param = c(mean=0, variance=1, nugget=0, scale=100, kappa=1))

# Plots for two sliding windows of each of the four methods below.
# Argument nlags is common to all methods;
# the 'variation' method has in addition argument p.index
par(mfrow=c(2,4)) # one row per window
fd <- fd.estimate(rf, 
       methods = list(list(name="variation", p.index=0.5), 
       					"variogram", "hallwood", "boxcount"),
       window.size = 5000, step.size = 5000, plot.loglog = TRUE, nlags = 10)
    
# 2d random fields
n <- 200
rf2d <- GaussRF(x = c(0,1, 1/n), y = c(0,1, 1/n), model = "stable", 
         grid = TRUE, gridtriple = TRUE,
         param = c(mean=0, variance=1, nugget=0, scale=1, kappa=1))
par(mfrow=c(2,2))
# plots for 4 sliding windows (2 horizontal, 2 vertical)
fd2d <- fd.estimate(rf2d, methods="filter1",
         window.size = 100, step.size=100, plot.loglog = TRUE)
}
}

\seealso{\code{\link{fd.estim.method}}, \code{\link{fd.get.available.methods}}, \code{\link{FDloglog}}, \code{\link{fd.get}}}

\keyword{ts}
\keyword{spatial}