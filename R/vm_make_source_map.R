vm_make_source_map <- function(source_list, dropping_list, num, col_name,
                            incl_keys, excl_keys){
  # Takes input sources and processes to create the source-based map of the
  # variable = standardized_variable pairs, based on standardize_col_names()
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #     standardize_col_names()
  #
  # INPUT:
  #       'source_list' (list) - a list of the source data frames in 
  #                             'name' = df format
  #                             order must be the same as in 'dropping_list'
  #       'dropping_list' (list) - a list of variables to drop/exclude from
  #                             each source data frame in 
  #                             'name' = c(dropping_vars) format
  #                             order must be the same as in 'source_list'
  #       'num' (integer) - the index of the target source in both 
  #                             'source_list' and 'dropping_list'
  #       'col_name' (string) - desired column name for the source for
  #                             insertion/merging with Variable_Map
  #       'incl_keys' (list) - list of key terms used in tidyselect of
  #                             column names, for inclusion in the source map
  #                           in list('starts_with' = c(keys), 
  #                                   'contains' = c('keys')) format
  #       'excl_keys' (list) - list of key terms used in tidyselect of
  #                             column names, for exclusion
  #                           in list('starts_with' = c(keys), 
  #                                   'contains' = c('keys')) format
  #       
  # OUTPUT:
  #       'source_map' (tibble) - organizes the passed information into a tibble
  #                             with two columns:
  #                             "col_name" - original variable name
  #                                         as isolated from the source tibble
  #                             "variable" - standardized version of the
  #                                         variable name in 'col_name', as
  #                                         processed by 
  #                                         standardize_col_names()

  
  # Check if standardize_col_names() has been imported
  
  if(!exists('standardize_col_names')){
    stop(paste(
      "Requires the standardize_col_names() function.", 
      "Please import and try again!"
      ))
  }
  
  # Check for dependencies. If not present but installed, try to install.
  
  packages <- unique(c('dplyr', 'tibble'))
  
  package_check <- unlist(
    lapply(
      packages,
      FUN = function(x) {
        require(x, character.only = TRUE)
      }
    )
  )
  
  if (sum(package_check) != length(packages)){
    stop("Missing required package")
  }
  rm(packages)
  rm(package_check)
  
  # Get source name for indexing
  source_name <- names(source_list)[[num]]
  
  # Extract variables. Exclude variables with known drop.
  vars <- source_list[[source_name]] %>%
    select(all_of(starts_with(incl_keys$starts_with)),
           all_of(contains(incl_keys$contains))
    ) %>%
    select(-c(
      all_of(starts_with(excl_keys$starts_with)),
      all_of(contains(excl_keys$contains))
      )
    ) %>%
    select(-any_of(dropping_list[[source_name]])
    ) %>%
    names()
  
  # Make output tibble
  source_map <- tibble::tibble(
    'new_col' = vars,
    'variable' = standardize_col_names(vars)
  ) %>%
    rename_at('new_col', ~col_name)
  
  # Return output tibble
  source_map
}