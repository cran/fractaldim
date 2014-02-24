\name{fd.get}
\alias{fd.get}
\title{Access Method for Objects of Class FractalDim}
\description{For given method it returns the corresponding estimates.}
\usage{
fd.get(fractaldim, method)
}
\arguments{
  \item{fractaldim}{object of class \code{FractalDim} as defined in
    \code{\link{fd.estimate}}.}
  \item{method}{character string specifying the method.
    For 1-d estimators, possible values are  \dQuote{\code{variogram}}, \dQuote{\code{madogram}}, \dQuote{\code{rodogram}}, \dQuote{\code{variation}}, \dQuote{\code{incr1}}, \dQuote{\code{boxcount}},
    \dQuote{\code{hallwood}},  
    \dQuote{\code{periodogram}},
    \dQuote{\code{wavelet}}, \dQuote{\code{dctII}}, and \dQuote{\code{genton}}. 
    For 2-d estimators, possible values are  \dQuote{\code{transect.var}}, \dQuote{\code{transect.incr1}},
    \dQuote{\code{isotropic}}, \dQuote{\code{squareincr}}, and \dQuote{\code{filter1}} 
    (see \code{\link{fd.get.available.methods}}).}
}

\value{A \code{\link{FractalDim}} object.  The original \code{fractaldim} arrays \code{fd} and \code{scale} are reduced in the last dimension into only one method, namely the given \code{method}. }

\examples{
\dontrun{
library(RandomFields)
x <- seq(0, 10000)
# generate a random field
truealpha <- 1.5
rf <- GaussRF(x = x, model = "stable", grid = TRUE,
    param = c(mean=0, variance=1, nugget=0, scale=100, 
        alpha=truealpha))

#compute fractal dimension using various methods
methods <- c("madogram", "variogram", "hallwood", "boxcount",
                       "periodogram","dctII", "wavelet")
fdts <- fd.estimate (rf, methods = methods, window.size = 500, 
    step.size = 100, nlags = 10, trim = FALSE, debuglevel = 3)

# plot the variation
cols <- rainbow(length(methods))
plot(ts(fd.get (fdts, methods[1])$fd),ylim=c(min(fdts$fd), max(fdts$fd)),
             ylab="fd", col=cols[1])
for (imeth in 2:length(methods)) 
    lines(ts(fd.get (fdts, methods[imeth])$fd), col=cols[imeth])
legend('topleft', legend=methods, col=cols, lwd=1)
abline(h=2-truealpha/2)
}
\dontshow{
#	for (imeth in 1:length(methods)) fd.get (fdts, methods[imeth])$fd
}
}
\seealso{\code{\link{fd.estimate}}, \code{\link{fd.get.available.methods}}}
\keyword{programming}
