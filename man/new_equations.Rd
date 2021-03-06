% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/new_equations.R
\name{new_equations}
\alias{new_equations}
\title{Modify the original equation table}
\usage{
new_equations(
  subset_taxa = "all",
  subset_climate = "all",
  subset_region = "all",
  subset_ids = "all",
  subset_output = c("Total aboveground biomass", "Whole tree (above stump)"),
  new_taxa = NULL,
  new_allometry = NULL,
  new_coords = NULL,
  new_minDBH = NULL,
  new_maxDBH = NULL,
  new_sampleSize = NULL,
  new_unitDBH = "cm",
  new_unitOutput = "kg",
  new_inputVar = "DBH",
  new_outputVar = "Total aboveground biomass",
  use_height_allom = TRUE
)
}
\arguments{
\item{subset_taxa}{character vector with taxa to be kept. Default is \code{all},
in which case all taxa are kept.}

\item{subset_climate}{character vector with Koppen climate classification to
be kept. Default is \code{all}, in which case all climates are kept.}

\item{subset_region}{character vector with name of location(s) or
country(ies) or broader region(s) (eg. \code{Europe}, \verb{North America}) to be
kept. Default is \code{all}, in which case all regions/countries are kept.}

\item{subset_ids}{character vector with equation IDs to be kept. Default is
\code{all}, in which case all equations are kept.}

\item{subset_output}{What dependent variable(s) should be provided in the
output? Default is \verb{Total aboveground biomass} and \verb{Whole tree (above stump)}, other possible values are: \verb{Bark biomass}, \code{Branches (dead)},
\code{Branches (live)}, \verb{Branches total (live, dead)}, \verb{Foliage total},
\code{Height}, \code{Leaves}, \verb{Stem (wood only)}, \verb{Stem biomass}, \verb{Stem biomass (with bark)}, \verb{Stem biomass (without bark)}, \verb{Whole tree (above and belowground)}. Be aware that currently only a few equations represent those
other variables, so estimated values might not be very accurate.}

\item{new_taxa}{character string or vector specifying the taxon (or taxa) for
which the allometry has been calibrated}

\item{new_allometry}{a character string with the allometric equation}

\item{new_coords}{a vector or matrix of coordinates (longitude, latitude) of
the calibration data}

\item{new_minDBH}{numerical value, minimum DBH for which the equation is
valid (in cm). Default is NULL (nothing is added).}

\item{new_maxDBH}{numerical value, maximum DBH for which the equation is
valid (in cm). Default is NULL (nothing is added).}

\item{new_sampleSize}{number of measurements with which the allometry was
calibrated. Default is NULL (nothing is added).}

\item{new_unitDBH}{character string with unit of DBH in the equation (either
\code{cm}, \code{mm} or \code{inch}). Default is \code{cm}.}

\item{new_unitOutput}{character string with unit of equation output (either
\code{g}, \code{kg}, \code{Mg} or \code{lbs} if the output is a mass, or \code{m} if the output is a
height).}

\item{new_inputVar}{independent variable(s) needed in the allometry. Default
is \code{DBH}, other option is \verb{DBH, H}.}

\item{new_outputVar}{dependent variable estimated by the allometry. Default
is \verb{Total aboveground biomass}.}

\item{use_height_allom}{a logical value. In allodb we use Bohn et al. (2014)
for European sites. User need to provide height allometry when needed to
calculate AGB. Default is TRUE.}
}
\value{
A new equation dataframe.
}
\description{
This function modifies the original equation table to be used in other
functions of the package including: subset the original equation table, add
new equations, and choose whether to include equations with a height
allometry.
}
\examples{
dfequation <- new_equations(
  new_taxa = "Faga",
  new_allometry = "exp(-2+log(dbh)*2.5)",
  new_coords = c(-0.07, 46.11),
  new_minDBH = 5,
  new_maxDBH = 50,
  new_sampleSize = 50
)
}
