#' Modify the original equation table
#'
#' This function modifies the original equation table to be used in other
#' functions of the package including: subset the original equation table, add
#' new equations, and choose whether to include equations with a height
#' allometry.
#'
#' @param subset_taxa character vector with taxa to be kept. Default is `all`,
#'   in which case all taxa are kept.
#' @param subset_climate character vector with Koppen climate classification to
#'   be kept. Default is `all`, in which case all climates are kept.
#' @param subset_region character vector with name of location(s) or
#'   country(ies) or broader region(s) (eg. `Europe`, `North America`) to be
#'   kept. Default is `all`, in which case all regions/countries are kept.
#' @param subset_ids character vector with equation IDs to be kept. Default is
#'   `all`, in which case all equations are kept.
#' @param subset_output What dependent variable(s) should be provided in the
#'   output? Default is `Total aboveground biomass` and `Whole tree (above
#'   stump)`, other possible values are: `Bark biomass`, `Branches (dead)`,
#'   `Branches (live)`, `Branches total (live, dead)`, `Foliage total`,
#'   `Height`, `Leaves`, `Stem (wood only)`, `Stem biomass`, `Stem biomass (with
#'   bark)`, `Stem biomass (without bark)`, `Whole tree (above and
#'   belowground)`. Be aware that currently only a few equations represent those
#'   other variables, so estimated values might not be very accurate.
#' @param new_taxa character string or vector specifying the taxon (or taxa) for
#'   which the allometry has been calibrated
#' @param new_allometry a character string with the allometric equation
#' @param new_coords a vector or matrix of coordinates (longitude, latitude) of
#'   the calibration data
#' @param new_minDBH numerical value, minimum DBH for which the equation is
#'   valid (in cm). Default is NULL (nothing is added).
#' @param new_maxDBH numerical value, maximum DBH for which the equation is
#'   valid (in cm). Default is NULL (nothing is added).
#' @param new_sampleSize number of measurements with which the allometry was
#'   calibrated. Default is NULL (nothing is added).
#' @param new_unitDBH character string with unit of DBH in the equation (either
#'   `cm`, `mm` or `inch`). Default is `cm`.
#' @param new_unitOutput character string with unit of equation output (either
#'   `g`, `kg`, `Mg` or `lbs` if the output is a mass, or `m` if the output is a
#'   height).
#' @param new_inputVar independent variable(s) needed in the allometry. Default
#'   is `DBH`, other option is `DBH, H`.
#' @param new_outputVar dependent variable estimated by the allometry. Default
#'   is `Total aboveground biomass`.
#' @param use_height_allom a logical value. In allodb we use Bohn et al. (2014)
#'   for European sites. User need to provide height allometry when needed to
#'   calculate AGB. Default is TRUE.
#'
#' @return A new equation dataframe.
#'
#' @export
#'
#' @examples
#' dfequation <- new_equations(
#'   new_taxa = "Faga",
#'   new_allometry = "exp(-2+log(dbh)*2.5)",
#'   new_coords = c(-0.07, 46.11),
#'   new_minDBH = 5,
#'   new_maxDBH = 50,
#'   new_sampleSize = 50
#' )
new_equations <- function(subset_taxa = "all",
                          subset_climate = "all",
                          subset_region = "all",
                          subset_ids = "all",
                          subset_output = c("Total aboveground biomass",
                                            "Whole tree (above stump)"),
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
                          use_height_allom = TRUE) {
  ## open the equation table and get it in the right format ####
  new_equations <- allodb::equations

  suppressWarnings(new_equations$dbh_min_cm <-
                     as.numeric(new_equations$dbh_min_cm))
  suppressWarnings(new_equations$dbh_max_cm <-
                     as.numeric(new_equations$dbh_max_cm))
  suppressWarnings(new_equations$sample_size <-
                     as.numeric(new_equations$sample_size))
  suppressWarnings(new_equations$dbh_unit_CF <-
                     as.numeric(new_equations$dbh_unit_CF))
  suppressWarnings(new_equations$output_units_CF <-
                     as.numeric(new_equations$output_units_CF))

  ## replace height with height allometry  ####
  ## from Bohn et al. 2014 in Jansen et al. 1996
  if (use_height_allom &
      "jansen_1996_otvb" %in% new_equations$ref_id) {
    eq_jansen <- subset(new_equations, ref_id == "jansen_1996_otvb")
    ## height allometries defined per genus -> get info in Jansen allometries
    eq_jansen$genus <-
      data.table::tstrsplit(eq_jansen$equation_notes, " ")[[5]]
    ## create height allometry dataframe
    hallom <-
      subset(new_equations,
             ref_id == "bohn_2014_ocai" &
               dependent_variable == "Height")
    hallom <- hallom[, c("equation_taxa", "equation_allometry")]
    colnames(hallom) <- c("genus", "hsub")
    ## merge with jansen allometries (equations that do not have a corresponding
    ## height allometry will not be substituted)
    eq_jansen <- merge(eq_jansen, hallom, by = "genus")
    # substitute H by its DBH-based estimation
    toMerge <- eq_jansen[, c("hsub", "equation_allometry")]
    eq_jansen$equation_allometry <- apply(toMerge, 1, function(X) {
      gsub("\\(h", paste0("((", X[1], ")"), X[2])
    })
    # replace independent_variable column
    eq_jansen$independent_variable <- "DBH"
    # replace in equation table
    new_equations <-
      rbind(subset(new_equations, !equation_id %in% eq_jansen$equation_id),
            eq_jansen[, colnames(new_equations)])
  } else
    new_equations <-
    subset(new_equations, independent_variable == "DBH")

  ## subset equation table ####
  if (any(subset_taxa != "all")) {
    keep <- vapply(new_equations$equation_taxa, function(tax0) {
      any(vapply(subset_taxa, function(i)
        grepl(i, tax0), FUN.VALUE = TRUE))
    }, FUN.VALUE = TRUE)
    new_equations <- new_equations[keep, ]
  }

  if (any(subset_climate != "all")) {
    keep <- vapply(new_equations$koppen, function(clim0) {
      any(vapply(subset_climate, function(i)
        grepl(i, clim0), FUN.VALUE = TRUE))
    }, FUN.VALUE = TRUE)
    new_equations <- new_equations[keep, ]
  }

  if (any(subset_region != "all")) {
    keep <- vapply(new_equations$geographic_area, function(reg0) {
      any(vapply(subset_region, function(i)
        grepl(i, reg0), FUN.VALUE = TRUE))
    }, FUN.VALUE = TRUE)
    new_equations <- new_equations[keep, ]
  }

  if (any(subset_ids != "all")) {
    new_equations <- subset(new_equations, equation_id %in% subset_ids)
  }

  new_equations <-
    subset(new_equations, dependent_variable %in% subset_output)

  ## add new equations ####
  # check that new allometry was added
  if (is.null(new_allometry) &
      (!is.null(new_taxa) | !is.null(new_coords)))
    stop("You might have forgotten to add the new allometry.")

  if (!is.null(new_allometry)) {
    ## check consistency of inputs
    if (is.null(new_taxa) |
        is.null(new_coords) |
        is.null(new_minDBH) |
        is.null(new_maxDBH) |
        is.null(new_sampleSize))
      stop(
        "You must provide the taxa, coordinates, DBH range
         and sample size of you new allometries."
      )

    if (!is.numeric(new_minDBH) |
        !is.numeric(new_maxDBH) | !is.numeric(new_sampleSize))  {
      stop("new_minDBH, new_maxDBH, new_sampleSize should be numeric values.")
    }

    if (is.matrix(new_coords)){
      ncoords <- ncol(new_coords)
    } else {
      ncoords <- length(new_coords)
    }
    if (!is.numeric(new_coords) | ncoords != 2)  {
      stop("coords should be a numeric vector or matrix,
            with 2 values or 2 columns.")
    }

    if (length(new_taxa) != length(new_allometry) |
        length(new_allometry) != length(new_minDBH) |
        length(new_minDBH) != length(new_maxDBH) |
        length(new_maxDBH) != length(new_sampleSize)) {
      stop(
        "new_taxa, new_allometry, new_minDBH, new_maxDBH and
        new_sampleSize must all be the same length."
      )
    }

    if (!is.character(new_allometry))  {
      stop("The equation allometry should be a character
           vector.")
    }
    if (any(grepl("=|<-", new_allometry)))  {
      stop("new_allometry should should be written as a
           function of DBH  (e.g. '0.5 * dbh ^ 2').")
    }
    dbh <- 10
    eval(parse(text = tolower(new_allometry)))

    if (!new_unitDBH %in% c("cm", "mm", "inch")) {
      stop("new_unitDBH must be either cm, mm or inch.")
    }

    if (!new_unitOutput %in% c("g", "kg", "Mg", "lbs", "m")) {
      stop("new_unitOutput must be either `g`, `kg`, `Mg` or `lbs`, or `m`.")
    }

    if (new_outputVar == "Height" & new_unitOutput != "m") {
      stop("Height allometries outputs must be in m.")
    }

    if (any(new_maxDBH <= new_minDBH) |
        any(new_minDBH < 0) |
        any(!is.numeric(new_minDBH)) |
        any(!is.numeric(new_maxDBH))) {
      stop(
        "new_minDBH and new_maxDBH must be positive real
        numbers, with new_maxDBH > new_minDBH."
      )
    }

    if (!is.matrix(new_coords)) {
      new_coords <-
        matrix(rep(new_coords, length(new_taxa)),
               ncol = 2,
               byrow = TRUE)
    }

    if (!is.numeric(new_coords) |
        !(ncol(new_coords) == 2 &
          nrow(new_coords) == length(new_taxa))) {
      stop(
        "new_coords must be a numeric vector of length 2 or
        a matrix with 2 columns (long, lat) and as many rows
        as the number of equations."
      )
    }

    if (any(new_coords[, 1] < -180 |
            new_coords[, 1] > 180 |
            new_coords[, 2] < -90 | new_coords[, 2] > 90)) {
      stop("Longitude must be between -180 and 180, and
           latitude between 90 and 0.")
    }

    new_allometry <- tolower(new_allometry)

    if (any(!grepl("dbh", new_allometry))) {
      stop("At least one of the new allometries does not
           contain DBH as a dependent variable.")
    }

    equationID <- paste0("new", seq_len(length(new_taxa)))
    coordsEq <- cbind(long = new_coords[, 1],
                      lat = new_coords[, 2])
    rcoordsEq <- round(coordsEq * 2 - 0.5) / 2 + 0.25
    ## extract koppen climate of every location
    koppenZones <- apply(rcoordsEq, 1, function(X) {
      subset(kgc::climatezones, Lon == X[1] &  Lat == X[2])$Cls
    })
    koppenZones <- as.character(unlist(koppenZones))
    if (length(koppenZones) != nrow(rcoordsEq)) {
      stop(
        "Impossible to find all koppen climate zones based
        on coordinates. Please check that they are Long, Lat."
      )
    }

    added_equations <- data.frame(
      equation_id = equationID,
      equation_taxa = new_taxa,
      equation_allometry = new_allometry,
      independent_variable = new_inputVar,
      dependent_variable = new_outputVar,
      long = new_coords[, 1],
      lat = new_coords[, 2],
      koppen = koppenZones,
      dbh_min_cm = new_minDBH,
      dbh_max_cm = new_maxDBH,
      sample_size = new_sampleSize,
      dbh_units_original = new_unitDBH,
      output_units_original = new_unitOutput
    )

    new_equations <- rbind(added_equations,
                           new_equations[, colnames(added_equations)])

    ## add conversion factors
    dbhCF <-
      unique(equations[, c("dbh_units_original", "dbh_unit_CF")])
    outputCF <-
      unique(equations[, c("output_units_original", "output_units_CF")])
    suppressWarnings(dbhCF$dbh_unit_CF <-
                       as.numeric(dbhCF$dbh_unit_CF))
    suppressWarnings(outputCF$output_units_CF <-
                       as.numeric(outputCF$output_units_CF))
    new_equations <- merge(new_equations, dbhCF)
    new_equations <- merge(new_equations, outputCF)

    new_equations <- new_equations[, c(
      "equation_id",
      "equation_taxa",
      "equation_allometry",
      "independent_variable",
      "dependent_variable",
      "long",
      "lat",
      "koppen",
      "dbh_min_cm",
      "dbh_max_cm",
      "sample_size",
      "dbh_units_original",
      "dbh_unit_CF",
      "output_units_original",
      "output_units_CF"
    )]

  }

  return(new_equations)
}
