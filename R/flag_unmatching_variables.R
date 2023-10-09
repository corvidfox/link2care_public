flag_unmatching_variables <- function(source_list, desired_vars,
                                      incl_keys, excl_keys){
  
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