vm_join_sections <- function(section_list) {
  # Takes a list of tibbles containing section maps, passed in a desired order,
  # and combines them into one large section map.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #     'vm_check()'
  #
  # INPUT:
  #       'section_list' (list of tibbles) - list of variables that contain
  #                             the desired sections for the variable map.
  #                             Must be passed in the desired order.
  #                             Use list(), not c()!
  #
  # OUTPUT:
  #       'comb_tibble' (tibble) - organizes the passed information into a 
  #                             tibble with at least 6 columns: 
  #                             "variable" - variable names
  #                             "section" - section names
  #                             "sec_ord" - order of the section within the
  #                                         overall map (i.e., 1 is first, 
  #                                                     2 is second, etc)
  #                             "instrument" - instrument names
  #                             "inst_ord" - order of the instrument within the
  #                                         section (i.e., 1 is first, 
  #                                                     2 is second, etc)
  #                             "item_ord" - order of the variable within the
  #                                         instrument (i.e., 1 is first, 
  #                                                     2 is second, etc)
  
  
  # Check if vm_check() has been imported
  if(!exists('vm_check')){
    stop("Requires the vm_check() function. Please import and try again!")
  }
  
  
  # Check for dependency packages. If not present but installed, try to install.
  
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
  
  
  # DATA CHECK: ensures the proper format of input variable
  
  issues <- c()
  
  if(length(section_list) == 0 ){
    issues <- c(issues, "must pass at least one instrument tibble")
  }
  
  # Perform checks of individual tibbles
  
  not_tibble <- FALSE
  bad_format <- FALSE
  
  for (i in 1:length(section_list)){
    if (!is_tibble(section_list[[i]])){
      
      # Check if all passed section are actually tibbles
      not_tibble <- TRUE
    }
    if( sum(c('variable', 'section', 'instrument', 'inst_ord', 'item_ord') %in% 
            colnames(section_list[[i]])) != 5) {
      
      # Check if all passed instruments have the expected column names
      bad_format <- TRUE
    }
  }
  
  # Clean up, in case of data leak
  rm(i)
  
  # Add message for errors once, if ever occurred
  
  if (not_tibble){
    issues <- c(issues, "At least one instrument is not a tibble")
  }
  if (bad_format){
    issues <- c(issues, 
                "At least one instrument does not have the required minimum cols")
  }
  
  # Clean up, in case of data leak
  rm(not_tibble)
  rm(bad_format)
  
  # If any issues, STOP and print messages about the errors
  if (length(issues) > 0 ){
    stop(paste(issues, sep = "; "))
  }
  
  # Initiate tibble structure. Ensure numeric variables are numeric.
  
  comb_tib_vars <- c('variable', 'section', 'sec_ord', 'instrument', 'inst_ord', 
                     'item_ord')
  
  comb_tibble <- tibble::tibble(!!!comb_tib_vars, .rows = 0, 
                                .name_repair = ~comb_tib_vars) %>%
    mutate(item_ord = as.numeric(item_ord),
           inst_ord = as.numeric(inst_ord),
           sec_ord = as.numeric(sec_ord))
  
  rm(comb_tib_vars)
  
  # Add the order to each section before adding to the stack
  
  for (i in 1:length(section_list)){
    comb_tibble <- bind_rows(comb_tibble, 
                             section_list[[i]] %>%
                               add_column(sec_ord = i))
  }
  
  # Ensure combined tibble is valid
  
  if (!vm_check(comb_tibble)){
    stop("Output would not be valid - check input sections")
  }
  
  # Reorder variables combined tibble
  
  comb_tibble <- comb_tibble %>%
    relocate(variable, section, sec_ord, instrument, inst_ord, item_ord)
  
  # Return tibble
  
  comb_tibble
}