vm_join_inst_section <- function(section_name, instrument_list) {
  # Takes the section name and a list of tibbles containing
  # the instrument variable maps intended to be included in the section 
  # (in the desired order). Joins into a section map.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #
  # INPUT:
  #       'section_name' (string) - a section, which contains instruments
  #       'instrument_list' (list of tibbles) - list of variables that contain
  #                             the desired instruments within the section.
  #                             Must be passed in the desired order.
  #                             Use list(), not c()!
  #
  # OUTPUT:
  #       'sec_tibble' (tibble) - organizes the passed information into a tibble
  #                             with at least five columns: 
  #                             "variable" - variable names
  #                             "section" - section name
  #                             "instrument" - instrument name
  #                             "inst_ord" - order of the instrument within the
  #                                         section (i.e., 1 is first, 
  #                                                     2 is second, etc)
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
  
  if(!is.character(section_name)){
    issues <- c(issues, "section_name must be a string")
  }
  if(length(instrument_list) == 0 ){
    issues <- c(issues, "must pass at least one instrument tibble")
  }
  
  # Perform checks of individual tibbles
  not_tibble <- FALSE
  bad_format <- FALSE
  
  for (i in 1:length(instrument_list)){
    if (!is_tibble(instrument_list[[i]])){
      
      # Check if all passed instruments are actually tibbles
      not_tibble <- TRUE
    }
    if( sum(c('variable', 'instrument', 'item_ord') %in% 
            colnames(instrument_list[[i]])) != 3) {
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
  
  sec_tib_vars <- c('variable', 'instrument', 'inst_ord', 
                       'item_ord')
  
  sec_tibble <- tibble::tibble(!!!sec_tib_vars, .rows = 0, 
                               .name_repair = ~sec_tib_vars) %>%
    mutate(item_ord = as.numeric(item_ord),
           inst_ord = as.numeric(inst_ord))
  
  rm(sec_tib_vars)
  
  # Add the order to each instrument before adding to the stack
  
  for (i in 1:length(instrument_list)){
    sec_tibble <- bind_rows(sec_tibble, 
                            instrument_list[[i]] %>%
                              add_column(inst_ord = i))
  }
  
  # Add Section name to all rows
  
  sec_tibble <- sec_tibble %>%
    add_column(section = section_name)
  
  # Ensure all variables in combined tibble are unique
  
  if (sum(duplicated(sec_tibble$variable)) > 0){
    stop("At least one variable is duplicated between instruments! Invalid join.")
  }
  
  # Reorder variables combined tibble
  
  sec_tibble <- sec_tibble %>%
    relocate(variable, section, instrument, inst_ord, item_ord)
    
  # Return tibble
  
  sec_tibble
}
