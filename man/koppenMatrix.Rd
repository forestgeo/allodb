% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{koppenMatrix}
\alias{koppenMatrix}
\title{Koppen climate classification matrix}
\format{
A data frame with 900 observations and 3 variables:\preformatted{[,1]	zone1	character
[,2]	zone2	character
[,3]	wE	decimal

}
}
\usage{
koppenMatrix
}
\description{
A table built to facilitate the comparison between the Koppen climate of a
site and the allometric equation in question. This table is used in the
weighting scheme in the weight_allom() function.
}
\details{
\itemize{
\item \code{koppenMatrix}: A data frame with two columns depicting the 3-letter system
of the Koppen climate scheme and the given weight when comparing
site/equation climate.
}

The value of column \code{wE} is the weight given to the combination of
Koppen climates in columns \code{zone1}and \code{zone2}; the table is symmetric:
\code{zone1}and \code{zone2} can be interchanged. This weight is calculated in 3 steps:
(1) if the main climate group (first letter) is the same, the climate weight
starts at 0.4; if one of the groups is "C" (temperate climate) and the other
is "D" (continental climate), the climate weight starts at 0.2 because the 2
groups are considered similar enough; otherwise, the weight is 0; (2) if the
equation and site belong to the same group, the weight is incremented by an
additional value between 0 and 0.3 based on precipitation pattern similarity
(second letter of the Koppen zone), and (3) by an additional value between 0
and 0.3 based on temperature pattern similarity (third letter of the Koppen
zone). The resulting weight has a value between 0 (different climate groups)
and 1 (exactly the same climate classification).
}
\keyword{datasets}
