\name{fd.estim.method}
\alias{fd.estim.method}
\alias{fd.estim.variation}
\alias{fd.estim.variogram}
\alias{fd.estim.madogram}
\alias{fd.estim.rodogram}
\alias{fd.estim.genton}
\alias{fd.estim.incr1}
\alias{fd.estim.hallwood}
\alias{fd.estim.boxcount}
\alias{fd.estim.periodogram}
\alias{fd.estim.dctII}
\alias{fd.estim.wavelet}
\alias{fd.estim.transect.var}
\alias{fd.estim.transect.incr1}
\alias{fd.estim.isotropic}
\alias{fd.estim.squareincr}
\alias{fd.estim.filter1}

\title{Estimation of Fractal Dimension via Specific Methods}
\description{The functions estimate a fractal dimension of the given data. Each function uses a different method. Functions for boxcount, hallwood, variogram, madogram, rodogram, variation, incr1, genton, periodogram, wavelet and dctII methods are to be used on one-dimensional time series. The remaining functions (transect, isotropic, squareincr, and filter1) are to be used on two-dimensional data. 
}
\usage{
fd.estim.boxcount (data, plot.loglog = FALSE, nlags = "auto", 
    shift.up=TRUE, plot.allpoints = FALSE, legend.type = 's', 
    \dots, debuglevel = 0)
fd.estim.hallwood (data, plot.loglog = FALSE, nlags = "auto", 
    plot.allpoints = FALSE, legend.type = 's', \dots, debuglevel = 0)
fd.estim.variogram (data, \dots)
fd.estim.madogram (data, \dots)
fd.estim.rodogram (data, \dots)
fd.estim.variation (data, p.index = 1, \dots)
fd.estim.incr1(data, p.index=2, \dots)
fd.estim.genton (data, \dots)
fd.estim.periodogram (data, plot.loglog = FALSE, nlags = "auto", \dots)
fd.estim.wavelet (data, plot.loglog=FALSE, plot.allpoints = FALSE, 
    filter = "haar", J1 = max(1,floor(log2(length(data))/3-1)), 
    J0 = floor(log2(length(data))), legend.type = 's', 
    \dots, debuglevel = 0)
fd.estim.dctII (data, plot.loglog = FALSE, nlags = "auto", \dots)
    
fd.estim.transect.var (data, p.index = 2, \dots)
fd.estim.transect.incr1 (data, p.index = 2, \dots)
fd.estim.isotropic (data, p.index = 2, direction = 'hvd+d-',
    plot.loglog = FALSE, nlags = "auto", plot.allpoints = FALSE, 
    legend.type = 's', \dots, debuglevel=0)
fd.estim.squareincr (data, p.index = 2, 
    plot.loglog = FALSE, nlags = "auto", plot.allpoints = FALSE, 
    legend.type = 's', \dots, debuglevel=0)
fd.estim.filter1 (data, p.index = 2, direction = 'hvd+d-',
    plot.loglog = FALSE, nlags = "auto", plot.allpoints = FALSE, 
    legend.type = 's', \dots, debuglevel=0)
}
\arguments{
  \item{data}{For the first eleven functions \code{data} is a one-dimensional vector. For the last five functions \code{data} is a matrix.}
  \item{p.index}{Parameter \eqn{p} of the variation method (see below).}
  \item{direction}{For the 2d estimators, this argument specifies the direction of the estimation (see details below). It can be any combination of the characters \sQuote{h} (horizontal), \sQuote{v} (vertical), \sQuote{d+} (diagonal with positive gradient), and \sQuote{d-} (diagonal with negative gradient). These characters should be combined into one string.}
  \item{plot.loglog}{Logical value determining if the underlying log-log
    plots should be plotted.}
  \item{nlags}{Number of lags to be used in the
    estimation. Possible values are \code{"auto"}, \code{"all"} or a
    single number.  If \code{nlags = "auto"}, each method sets the number of lags
    to the theoretically "best" value for that method.  \code{"all"} means
    that all lags are included in the estimation.}
  \item{shift.up}{For each interval on the horizontal axis, it moves the boxes vertically up to the smallest data point of that interval. If it is \code{FALSE}, all boxes are on a regular grid.}
  \item{plot.allpoints}{Logical. If \code{FALSE}, only points that were considered in 
	the regression are shown. Otherwise, all points of the log-log 
	plot are shown in the graph and those considered in the regression are marked by filled circles.
	This argument is only used if 
	\code{plot.loglog = TRUE}.  Note that setting this argument to \code{TRUE} might (depending on the method)
	considerably increase the computation run-time.}
  \item{filter}{Argument passed to the \code{modwt} function of the \pkg{wavelets} package.}
  \item{J0, J1}{Parameters of the wavelet method controlling the number of frequencies used in the estimation.}
  \item{legend.type}{One of the characters 'f', 's', or 'n'. It controlls the amount of information in the legend of the log-log plot. If it is 'f' (full), values of fd and scale, including the raw values of the corresponding slope and intercept are shown. If it is 's' (short), only fd is shown. Value of 'n' (None) causes no legend being plotted. The argument is only used if \code{plot.loglog = TRUE}.}
  \item{\dots}{Arguments passed to the plotting function if \code{plot.loglog = TRUE}. For some functions, \dots contain additional arguments, see Details.}
  \item{debuglevel}{Controls the amount of debugging
    messages. The functions produce messages on level 5.}
}
\details{The methodology of these functions is based on the theory
  described in Gneiting et al (2010). Please refer to this paper for notation. Here we give only a few comments about the implementation.
  
%For the one-dimensional estimators, suppose \eqn{X} is a time series
%of length \eqn{n}, observed at equally
%  spaced points \eqn{t=\frac{i-1}{n}, i=1,\dots,n}.
\describe{
\item{\emph{Box-count
    estimator:}}{
%Let \eqn{n=2^m} for some \eqn{m>0} and let \eqn{u=\max_i X_i - \min_i X_i}.  Then for a
%fixed \eqn{k}, \eqn{2 \leq k \leq m}, the minimal number of boxes of size \eqn{\epsilon_l= (2^l/n
%\times u/2^{m-l})}, \eqn{l=0,1,2,\dots,k}, that cover the data are counted, say
%\eqn{N(l)}.  Fractal dimension \eqn{D} is estimated as
%\deqn{
%\hat{D}_k = - \left\{ \sum_{l=1}^k (s_l - \bar{s}) \log N(l) \right\}
%          \left\{ \sum_{l=1}^k (s_l - \bar{s})^2 \right\}^{-1}
%}
%where \eqn{s_l = \log l} and \eqn{\bar{s} = \frac{1}{k} \sum_{l=1}^k s_l}.
The function \code{fd.estim.boxcount} determines the smallest possible value of \eqn{m} 
for which \eqn{n\leq 2^m} is a power of 2.  Only data points \eqn{x_1,\dots,x_{n_{eff}}} are considered for the estimation, 
where \eqn{n_{eff} = 2^{m-1}+1}.  The value of \eqn{K} can be given by the user through the argument \code{nlags}.  If \code{nlags = "auto"}, box sizes \eqn{\epsilon_k} for \eqn{k=j,j+1,\dots,m-2} are considered, 
where for all \eqn{i<j} is \eqn{N(\epsilon_i) > \frac{n_{eff}}{5}}{N(\epsilon_i) > n_{eff}/5}, i.e. 
the two largest box sizes and very small boxes are eliminated (corresponds to the
Liebovitch and Toth modification).

If \code{shift.up=TRUE}, the algorithm shifts each vertical column of boxes up to the smallest data value in that column. 

\eqn{N(\epsilon_k)} for a particular box is increased if either a data point is contained in the box, 
or if a line connecting two neighboring data points crosses the box.
}
\item{\emph{Hall-Wood estimator}}{
This estimator is a version of box-count that 
instead of number of boxes considers the area of boxes that cover 
the underlying curve.  
%Specifically,  for a positive integer \eqn{l < n} let
%\deqn{
%\hat{A}(l) = \frac{l}{n} \: \sum_{i=1}^{q_l}
%           \left({\textstyle  \max_{j\in \{(i-1)l,il\} }} \: X_{j/n}
%           - {\textstyle \min_{j\in \{(i-1)l,il\}}} \: X_{j/n} \right) 
%}
%where \eqn{q_l = \lfloor \frac{n-1}{l} \rfloor}, and let \eqn{s_l = \log l}.  
%The Hall-Wood box-counting estimator
%\deqn{
%\hat{D}_k = 2 - \left\{ \sum_{l=1}^k (s_l - \bar{s}) \log \hat{A}(l) \right\}
%          \left\{ \sum_{l=1}^k (s_l - \bar{s})^2 \right\}^{-1}
%}
%where \eqn{k \geq 2} and \eqn{\bar{s} = \frac{1}{k} \sum_{l=1}^k s_l}, is
%based on linear regression of \eqn{\log \hat{A}(l)} on \eqn{\log l} or 
%\eqn{\log \frac{l}{n}}, for \eqn{l = 1, \ldots, k}.  
Hall and Wood (1993) recommend
the use of \eqn{L = 2} which the function \code{fd.estim.hallwood} uses
if the arguments \code{nlags = "auto"}.
}
\item{\emph{Variation, Variogram, Madogram, Rodogram, and Incr1 estimators:}}{
	The \code{p.index} argument of \code{fd.estim.variation} and \code{fd.estim.incr1} is the power index \eqn{p}. The madogram, variogram, and rodogram, respectively, correspond to the Variation estimator with \eqn{p} equals 1, 2, and 1/2, respectively. The Incr1 estimator is like Variation but based on second order differences.
%For an index \eqn{\beta},
%\eqn{\beta>0}, and a
%  lag \eqn{d}, \eqn{0<d<n}, define
%  the \eqn{\beta}-variation as

%  \deqn{\hat{V}(\beta,d) = \frac{1}{n-d}\sum_{i=d}^{n-1} \left|
%    X(i/n) - X((i-d)/n) \right|^{\beta}.}
  
%  The hybrid estimator of index \eqn{\beta} is derived from the log-log
%  plot of \eqn{\log(d)} against \eqn{\log(\hat{V}(\beta,d))} as 
%\deqn{
%\hat{D}_k = 2 - \frac{1}{\beta} \left\{ \sum_{l=1}^k (s_l - \bar{s}) \log \hat{V}(\beta, l) \right\}
%          \left\{ \sum_{l=1}^k (s_l - \bar{s})^2 \right\}^{-1} \,.
%}
Any argument that can be passed to \code{fd.estim.hallwood} can be passed here as well. In addition,
as in the Hall-Wood case, \eqn{L} is set to 2 for these estimators, if \code{nlags = "auto"}.
}
\item{\emph{Genton robust estimator:}}{
This is a highly robust variogram estimator as proposed by Genton (1998). Given \eqn{U_i(d) = X_{i/n} - X_{(i-d)/n}}, define
\deqn{
\hat{V}(d) = \left[2.2191\{|U_i(d) - U_j(d)|; i<j \}_{(k)}\right]^2 ,
\quad \mbox{where} \;\; k={\lfloor (n-d)/2\rfloor +1 \choose 2}\,.}{Vhat(d) = [2.2191{|U_i(d) - U_j(d)|; i<j }_(k)]^2 ,
where k={choose{floor{(n-d)/2} + 1, 2}}.}

Thus, the estimator is derived from the \eqn{k}-th quantile of the \eqn{U_i(d)} values. The \eqn{\hat{D}_k}{Dhat_k} estimator is derived from the log-log plot of \eqn{\log(d)}{log(d)} against \eqn{\log(\hat{V}(d))}{log(Vhat(d))}. The implementation uses the \code{qn} function of the \pkg{pcaPP} package to compute \eqn{\hat{V}(d)}{Vhat(d)}.

Here again, the number of lags is set to 2 if  \code{nlags = "auto"} and any arguments of the \code{fd.estim.hallwood} are accepted here as well.

}
\item{\emph{Periodogram estimator:}}{
The method is implemented as proposed by Chan et al. (1995) with notation from Gneiting et al (2010).  
%Let \eqn{X} denote a stationary Gaussian process observed on the interval \eqn{(-1,1)} and
%define 
%\deqn{
%A(\omega) = \int_{-1}^1 X_t\cos(\omega t)dt \,
%}
%where \eqn{\omega} is an integer multiple of \eqn{2\pi}. \eqn{A(\omega)^2} is called
%semiperiodogram. 

%Using \eqn{2n+1} observations of the process \eqn{X} at the points \eqn{t=\frac{j}{n}},
%\eqn{j=-n,\dots,n}, \eqn{A(\omega)} is estimated by
%\deqn{
% \hat{A}(\omega) = n^{-1}\left[\frac{X_{-1} + X_1}{2} + \sum_{i=-n+1}^{n-1}X_{i/n}\cos(
%i\omega/n)\right]\,.
%}
%Let \eqn{\omega_1 < \dots < \omega_k}, \eqn{2 \leq k \leq n/2}.  The fractal dimension
%is estimated by
%\deqn{
%\hat{D}_k = \frac{5}{2} + \frac{1}{2} \,
%         \left\{ \sum_{l=1}^k (s_l - \bar{s}) \log \hat{A}(\omega_l)^2 \right\}
%         \left\{ \sum_{l=1}^k (s_l - \bar{s})^2 \right\}^{-1}
%}
%where \eqn{s_l = \log \omega_l} and \eqn{\bar{s} = \frac{1}{k} \sum_{l=1}^k s_l}. 
% Note that the upper bound on \eqn{k} is provided by the Nyquist frequency.  
As Chan et al. (1995) recommend, we use \eqn{L=\lfloor \min(m/2, n^{2/3})\rfloor}{L=floor{min(m/2, n^(2/3))}} if \code{nlags = "auto"}. Any arguments of the \code{fd.estim.hallwood} are also accepted here.
}
\item{\emph{Wavelet estimator:}}{This method uses \eqn{J_0} vectors of wavelet coefficients  which are obtained using the function \code{modwt} of the \pkg{wavelets} package. The choice of \code{J0} and \code{J1} determine the number of frequencies used in the estimation.
%The coefficients in the \eqn{j}th vector are associated
%with the scale \eqn{\tau_j = 2^{j-1}}.  Furthermore,   
%let \eqn{c_j = n/2^j},
%\eqn{Y_j = \log(c_j \| \widetilde {\bf W}_j \|^2/2n) - \psi(c_j)}
%and \eqn{w_j=1/\psi'(c_j)},
%where \eqn{\psi} and \eqn{\psi'} are the di- and tri-gamma functions.
% The wavelet-based estimator of fractal dimension is given by
%\deqn{
%\hat{D} = 2-\frac{1}{2}\frac
%{\sum w_j \sum w_j \log\,(\tau_j) Y_j
%- \sum w_j \log\,(\tau_j) \sum w_j Y_j}
%{
%\sum w_j \sum w_j \log^2(\tau_j) - \left( \sum w_j \log\,(\tau_j)
%\right)^2
%}
%}
%where all summations are over \eqn{j=2,\ldots, J_0}.

}
\item{\emph{DCT-II estimator:}}{If \code{nlags = "auto"}, we use \eqn{L=\lfloor \min(2m, 4n^{2/3})\rfloor}{L=floor{min(2m, 4n^(2/3))}}. Any arguments of the \code{fd.estim.hallwood} are also accepted here.
}
}
The two-dimensional estimators are all based on the Variation method with the power index \eqn{p} (argument \code{p.index}) with the following alternatives:
\describe{
\item{\emph{Transect}}{For every given direction, a variation estimate (or a variant that uses second differences) is found in each row (for horizontal direction) and/or column (for vertical direction). The resulting estimate is the median over the set of estimates. In the function \code{fd.estim.transect.var} the line transect estimates are based on first differences; In the function \code{fd.estim.transect.incr1} they are based on second differences.
	
This method does not support the feature of creating a log-log plot, since there are many log-log regressions from which the results are derived. The methods also accept arguments \code{direction}, \code{nlags} and \code{debuglevel}. }
\item{\emph{Isotropic}}{Davies and Hall (1999) on page 12 define the isotropic empirical variogram. This is here implemented more generally using the variation estimator. If \code{nlags = "auto"}, the number of lags is set to either 3 if diagonal direction is used together with either horizontal or vertical direction or both. If only horizontal or/and vertical direction is used, the number of lags is set to 2.}
\item{\emph{Square-increment}}{We use the square-increment estimator proposed in eqs. (4.2) through (4.7) of Chan and Wood (2000). Note that this method is equivalent to the Filter 3 approach of Zhu and Stein (2002) which is the way it is implemented in the package. The automatic setting of number of lags is done as for the Isotropic method.}
\item{\emph{Filter 1}}{Here,  the Filter 1 approach of Zhu and Stein (2002) is implemented. Again, the automatic setting of number of lags is done as for the Isotropic method.}
}
For all methods (but Transect), if the argument \code{plot.loglog} is \code{TRUE}, a graph with the log-log plot is shown,
  including the fitted regression line.  Only points included in the regression are plotted, unless the argument \code{plot.allpoints} is set to \code{TRUE}. In such a case, points used for fitting the regression line are marked by filled circles.
  
For using multiple estimation methods via one function see \code{\link{fd.estimate}}.
}

\note{Function \code{\link{fd.estimate}} can be used as a wrapper for these functions.}

\value{Each function returns an object of class \code{\link{FractalDim}} with elements:
	\item{dim}{Here it is always 1.}
	\item{fd, scale}{Single value, namely the estimated fractal dimension and scale, respectively.} 
	\item{methods, methods.coding}{Method name and code used for the estimation.}
	\item{window.size, step.size}{Size of the data.}
	\item{data.dim}{Dimension of the data used for the estimation. It is either one or two.}
	\item{loglog}{Object of class \code{\link{FDloglog}} used for the estimation.}
}

\seealso{\code{\link{fd.estimate}}}

\author{Hana Sevcikova, Don Percival, Tilmann Gneiting}


\examples{
library(RandomFields)
# 1d time series
n <- 256
rf <- GaussRF(x = c(0,1, 1/n), model = "stable", 
    grid = TRUE, gridtriple = TRUE,
    param = c(mean=0, variance=1, nugget=0, scale=1, kappa=1))
par(mfrow=c(4,2))
fd.estim.variogram (rf, nlags = 20, plot.loglog = TRUE)
fd.estim.variation (rf, nlags = 20, plot.loglog = TRUE)
fd.estim.variogram (rf,  nlags = 3, plot.loglog = TRUE, 
    plot.allpoints = TRUE)
fd.estim.variation (rf, plot.loglog = TRUE, plot.allpoints = TRUE)
fd.estim.hallwood (rf, nlags = 10, plot.loglog = TRUE)
fd.estim.boxcount (rf, nlags = "all", plot.loglog = TRUE, 
    plot.allpoints = TRUE)
fd.estim.periodogram (rf, plot.loglog = TRUE)
fd.estim.dctII (rf, plot.loglog = TRUE)

# 2d random fields
n <- 128
rf2d <- GaussRF(x = c(0,1, 1/n), y = c(0,1, 1/n), model = "stable", 
    grid = TRUE, gridtriple = TRUE,
    param = c(mean=0, variance=1, nugget=0, scale=1, kappa=1))
par(mfrow=c(1,3))
fd.estim.isotropic (rf2d, p.index = 1, direction='hv',
                       plot.loglog = TRUE, plot.allpoints = TRUE)
fd.estim.squareincr (rf2d, p.index = 1, plot.loglog = TRUE, plot.allpoints = TRUE)
fd.estim.filter1 (rf2d, p.index = 1, plot.loglog = TRUE, plot.allpoints = TRUE)
}
\references{
Chan, G., Hall, P., Poskitt, D. (1995) Periodogram-Based Estimators of Fractal
  Properties. Annals of Statistics \bold{23} (5), 1684--1711.

Chan, G., Wood, A. (2000) Increment-based estimators of fractal dimension for two-dimensional surface data.
  Statistica Sinica \bold{10}, 343--376.

Davies, S., Hall, P. (1999) Fractal analysis of surface roughness by using spatial data.
  Journal of the Royal Statistical Society Series B \bold{61}, 3--37.
	
Genton, M. G. (1998) Highly robust variogram estimation. Mathematical Geology \bold{30}, 213--221.

Gneiting, T., Sevcikova, H. and Percival, D. B. (2012). Estimators of fractal dimension: Assessing the smoothness of time series and spatial data. Statistical Science, 27(2), 247-277. (Version as technical report available at \url{http://www.stat.washington.edu/research/reports/2010/tr577.pdf})


Hall, P., Wood, A. (1993) On the Performance of Box-Counting Estimators of
  Fractal Dimension. Biometrika \bold{80} (1), 246--252.

Zhu, Z., Stein, M. (2002) Parameter estimation for fractional Brownian surfaces.
  Statistica Sinica \bold{12}, 863--883.
}
\keyword{ts}
\keyword{spatial}
