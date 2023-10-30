flag_unmatching_variables <- function(source_list, desired_vars,
                                      incl_keys, excl_keys){
  # Check the variables selected from a source (or list of sources), after
  # standardization with standardize_col_names(), against the desired
  # standardized names. Uses tidyselect to isolate target columns. Returns
  # a list of any variables that standardize differently (and what they 
  # standardize to), as well as any items not listed in desired_vars that
  # were captured in the column selection.
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
  #       'desired_vars' (list) - a c() list containing the strings of all
  #                             desired variable standardization results, for
  #                             all columns intended to be captured in the
  #                             tidyselect parameters
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
  #       'flagged_vars' (tibble) - organizes the passed information into a tibble
  #                             with three columns:
  #                             "source" (string) - the name of the source 
  #                                                 in source_list
  #                             "flagged_var" (string) - the name of the
  #                                                 variable as it appears in
  #                                                 the source df
  #                             "std_vars" (string) - the result of passing
  #                                                 the 'flagged_var' into
  #                                                 standardize_col_names()
  #
  #       Prints a message to the console listing each source and the problem
  #       variables, if flagged_vars has any rows.
  
  
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
  
    message <- c()
    flagged_vars <- tibble::tibble(
        !!!c('source', 'flagged_var'), .rows=0, 
        .name_repair = ~c('source', 'flagged_var')
    )
    
  for(i in 1:length(source_list)){
    # For each source data frame, extract the matching variables
    
    source_df <- source_list[[i]]
    
    vars <- source_df %>%
      select(all_of(starts_with(incl_keys$starts_with)),
             all_of(contains(incl_keys$contains))
      ) %>%
      select(-c(
        all_of(starts_with(excl_keys$starts_with)),
        all_of(contains(excl_keys$contains))
      )
      ) %>%
      names()
    
    # Create list of variables and their standardized variants in a
    # temporary tibble
    
    temp_tib <- tibble::tibble(
      'source' = names(source_list)[i],
      'flagged_var' = vars,
      'std_vars' = standardize_col_names(vars)
    )
    
    # Remove any rows if the standardized variable name already exists in
    # our desired list
    temp_tib <- temp_tib[!(temp_tib$std_vars %in% desired_vars),]
    
    if(length(nrow(temp_tib) > 0)){
      # If there is a meaningful difference, generate a human-legible message
      # and add to output tibble
      
      source_message <- paste(
        "In source ", names(source_list)[i], ":", 
        paste(temp_tib$flagged_var, collapse = ", ")
        )
      
      message <- c(message, source_message)
      
      flagged_vars <- bind_rows(flagged_vars, temp_tib)
    }
  }
  
  if (nrow(flagged_vars) > 0){
    # Print message to console if it would reasonably exist
    print(message)
  }  
    
  # Return output tibble
  flagged_vars

}