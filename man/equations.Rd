% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{equations}
\alias{equations}
\alias{equations_metadata}
\title{Tables of allometric equations and associated metadata.}
\format{
\code{equations}: A data frame with 571 rows and 47 variables:\preformatted{	[,1]	ref_id	character
	[,2]	equation_id	character
	[,3]	equation_allometry	character
	[,4]	equation_form	character
	[,5]	dependent_variable	character
	[,6]	independent_variable	character
	[,7]	equation_taxa	character
	[,8]	allometry_specificity	character
	[,9]	equation_categ	character
	[,10]	geographic_area	character
	[,11]	original_coord	character
	[,12]	lat	numeric
	[,13]	long	numeric
	[,14]	elev_m	numeric
	[,15]	geography. Notes	character
	[,16]	mat_C	numeric
	[,17]	min.temp_C	numeric
	[,18]	max.temp_C	numeric
	[,19]	map_mm	numeric
	[,20]	frost_free_period_days	numeric
	[,21]	climate. Notes	character
	[,22]	stand_age_range_yr	character
	[,23]	stand_age_history	character
	[,24]	stand_basal_area_m2_ha	numeric
	[,25]	stand_trees_ha	numeric
	[,26]	forest_description	character
	[,27]	ecosystem_type	character
	[,28]	koppen	character
	[,29]	dbh_min_cm	numeric
	[,30]	dbh_max_cm	numeric
	[,31]	sample_size	integer
	[,32]	collection_year	integer
	[,33]	dbh_units_original	numeric
	[,34]	dbh_unit_CF	numeric
	[,35]	output_units_original	character
	[,36]	output_units_CF	numeric
	[,37]	allometry_development_method	character
	[,38]	regression_model	character
	[,39]	r_squared	numeric
	[,40]	other_equations_tested	character
	[,41]	log_biomass	numeric
	[,42]	bias_corrected	character
	[,43]	bias_correction_factor	numeric
	[,44]	notes_fitting_model	character
	[,45]	original_equation_id	character
	[,46]	original_data_availability	character
	[,47]	equation_notes	character

}

An object of class \code{spec_tbl_df} (inherits from \code{tbl_df}, \code{tbl}, \code{data.frame}) with 47 rows and 8 columns.
}
\source{
\itemize{
\item Go to \code{references} table for equations original sources.
}
}
\usage{
equations

equations_metadata
}
\description{
A compilation of best available allometry equations to calculate tree
above-ground biomass (AGB) per species based on extratropical ForestGEO sites:
\itemize{
\item \code{equations}: Table of allometric equations.
\item \code{equations_metadata}:
Explanation of columns for \code{equations} table.
}
}
\seealso{
Other database datasets: 
\code{\link{missing_values}},
\code{\link{references}},
\code{\link{sites_info}},
\code{\link{sitespecies}}
}
\concept{database datasets}
\keyword{datasets}
