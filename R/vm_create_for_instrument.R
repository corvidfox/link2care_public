vm_create_for_instrument <- function(instrument_name, desired_vars) {
  # Takes the instrument name, and desired variables (in the desired order) 
  # and creates the base instrument tibble for the variable map.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #
  # INPUT:
  #       'instrument_name' (string) - an instrument, which contains items; is
  #                             contained by a section
  #       'desired_vars' (list) - a list of string variables that provide unique
  #                             variable names. Must be passed in the desired
  #                             order. Must be the standardized, desired
  #                             variable names
  #
  # OUTPUT:
  #       'inst_tibble' (tibble) - organizes the passed information into a tibble
  #                             with three columns: 
  #                             "variable" - variable names
  #                             "instrument" - instrument name
  #                             "item_ord" - order of the variable within the
  #                                         instrument (i.e., 1 is first, 
  #                                                     2 is second, etc)
  
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
  
  
  # DATA CHECK: ensures the proper format of input variables
  
  issues <- c()
  
  if(!is.character(instrument_name)){
    issues <- c(issues, "instrument_name must be a string")
  }
  if(length(desired_vars) == 0 ){
    issues <- c(issues, "must pass at least one desired variable")
  }
  if( !(sum(is.character(desired_vars)) >= 1) & 
      !(sum(duplicated(desired_vars))==0) ){
    issues <- c(issues,
                "desired variables must be unique strings")
  }
  if (length(issues) > 0 ){
    stop(paste(issues, sep = "; "))
  }
  
  # Create tibble in format
  
  inst_tibble <- tibble::tibble(
    'variable' = desired_vars,
    'instrument' = instrument_name,
    'item_ord' = seq(1:length(desired_vars))
  )
  
  # Return tibble
  
  inst_tibble
}
