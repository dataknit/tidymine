#' Calculate MINE statistics.
#'
#' @param dataset The dataset containing the outcome and predictors.
#' @param outcome The variable of interest.
#' @param predictors The variables to measure the predictive power of. Defaults to every variable apart from the outcome.
#' @param alpha
#' @param c
#' @param cores Number of cores to use when executing the chains in parallel.
#'     This defaults to 1 (i.e. not performing parallel computing).
#'     Running `options(mc.cores = parallel::detectCores())` will set this be the maximum number of processors as the hardware and RAM allow (up to the number of chains).
#' @param low_variance_threshold A parameter to remove predictors with low variance. MINE statistics cannot be calculated for variables With low variance. This is fine because a low variance predictor cannot have high predictive power.
#' @param eps
#' @param est Default value is "mic_approx".
#'     With est="mic_approx" the original MINE statis-tics will be computed,
#'     with est="mic_e" the equicharacteristic matrix is is evaluated and the mic() and tic() methods
#'     will return MIC_e and TIC_e values respectively.
#' @param na.rm Logical to remove NA values.
#' @param use Method to deal with NA values.
#' @param normalisation
#' @param ...
#'
#' @return MINE statistics of \code{predictors} for predicting \code{outcome}.
#' @examples
#' spellman %>%
#'   tidymine(x40)
#' who %>%
#'   tidymine(lung_cancer_deaths_per_100_000_women)
#' who %>%
#'   tidymine(lung_cancer_deaths_per_100_000_women, c(adult_literacy_rate, total_fertility_rate_per_woman))
#' @export
tidymine <- function(dataset, outcome, predictors, alpha = 0.6, c = 15,
                     cores = getOption("mc.cores", 1L), low_variance_threshold = 1e-5, eps = NULL, est = "mic_approx",
                     na.rm = FALSE, use = "pairwise.complete.obs", normalisation = FALSE, ...) {

  # if predictors is missing, reduce the dataset
  if (!missing(predictors)) {
    dataset <- dataset %>%
      dplyr::select( {{ outcome }}, {{ predictors }} )
  }

  outcome_for_mine <- untidy_outcome(dataset, {{ outcome }})
  predictors_for_mine <- untidy_predictors(dataset, {{ outcome }}, low_variance_threshold)
  predictor_names <- get_predictor_names(predictors_for_mine)

  mined_matrix <- minerva::mine(y = outcome_for_mine,
                                x = predictors_for_mine,
                                alpha = alpha,
                                C = c,
                                n.cores = cores,
                                var.thr = low_variance_threshold,
                                eps = eps,
                                est = est,
                                na.rm = na.rm,
                                use = use,
                                normalization = normalisation, ...)

  tidy_mine_output(mined_matrix, predictor_names)
  # mined_matrix
}

untidy_outcome <- function(dataset, outcome) {
  dataset %>%
    dplyr::select({{ outcome }}) %>%
    tibble::deframe()
}

untidy_predictors <- function(dataset, outcome, low_variance_threshold = 1e-5) {
  # force numeric and exclude variables with low variance
  dataset %>%
    dplyr::select(-{{ outcome }}) %>%
    dplyr::mutate_all(as.numeric) %>%
    dplyr::select_if(list(~ (stats::var(., na.rm = TRUE) >= low_variance_threshold))) %>%
    as.data.frame()
}

get_predictor_names <- function(predictors_dataframe) {
  predictors_dataframe %>%
    names()
}

#' Tidy the output of minerva::mine
#'
#' @param mine_output The output from running minerva::mine
#' @param predictor_variable_names A vector of the variable names used as $x$ in minerva::mine.
#' @return A tidy tibble of MINE statistics.
#' @examples
#' x <- mlb_2008[,-c(1:3)]
#' excl <- which(diag(var(x)) < 1e-5) # exclude variables with low variance
#' x <- x[,-excl]
#' y <- dat$SALARY
#' minerva_result <- minerva::mine(x = x, y = y)
#' tidy_mine_output(minerva_result, x)
tidy_mine_output <- function(mine_output, predictor_variable_names) {
  mined_matrix <- mine_output
  mined_matrix$variable_name <- predictor_variable_names
  mined_matrix %>%
    tibble::as_tibble() %>%
    dplyr::select(variable_name, everything()) %>%
    dplyr::rename_all(tolower)
  # dplyr::replace(mic_r2 = `mic-r2`)
}
