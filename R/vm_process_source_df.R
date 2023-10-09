vm_process_source_df <- function(var_map, source_df, source_df_col,
                                 excluding_vars){
  # Processes a set of source data by renaming variables, according to the
  # pattern captured in 'var_map'. 
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #     vm_check()
  #
  # INPUT:
  #   'var_map' (tibble) - tibble of the following minimum content:
  #       'variable' (string, primary key) - a unique standardized variable name
  #       'section' (string) - a section, which contains instruments
  #       'sec_ord' (integer) - the numeric order of the section, where
  #                             1L indicates the first, 2L the second, etc.
  #       'instrument' (string) - an instrument, which contains items; is
  #                             contained by a section
  #       'inst_ord' (integer) - the numeric order of an instrument within
  #                             a section, where 1L indicates the first, 
  #                             2L the second, etc.   
  #       'item_ord' (integer) - the numeric order of a variable (item) within
  #                             an instrument, where 1L indicates the first, 
  #                             2L the second, etc.
  #       'section_ord' (integer) - the numeric order of the section, where
  #                             1L indicates the first, 2L the second, etc.
  #       (source_df_col) (string) - the names of the variables present in
  #                             the source_df that correspond to the variables
  #                             listed in 'variable'
  #   'source_df' (tibble) - source data, tibble form preferred
  #   'source_df_col' (string) - the name of the column in 'var_map' that
  #                             corresponds to the variables in 'source_df'
  #   'excluding_vars' (list of strings) - list of variables present in the
  #                             'source_df' that are to be excluded from
  #                             processing. Variables not present in 'var_map'
  #                             but in 'source_df' must be listed here.
  #                             use c()!
  #
  # OUTPUT:
  #       revised version of 'source_df' with variables renamed according to
  #       'var_map', with 'excluded_vars' omitted.
  
  
  # Check if vm_check() has been imported
  
  if(!exists('vm_check')){
    stop("Requires the vm_check() function. Please import and try again!")
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
  
  
  
  # DATA CHECK 1: Check the variable map for validity
  if (!vm_check(var_map)){
    stop("The variable map is invalid. Address before using!")
  }
  
  # DATA CHECK 2: Ensure that the 'source_df_col' is present in the
  # variable map
  
  if(!(source_df_col %in% colnames(var_map))){
    stop(paste(source_df_col, ' is not present in var_map!'))
  }
  
  # Extract the standardized/desired variable names and the original variable 
  # names, but only for variables that appear in the source data set
  
  section <- na.omit(var_map %>%
                       select(variable, all_of(source_df_col)))
  
  # DATA CHECK 3: Ensure all the source variables from the variable map are
  # included in the source data (in case any variables names changed 
  # in the source data)
  
  missing_from_source <- c()
  
  source_vars <- colnames(source_df)
  map_source_vars <- pull(section[, source_df_col])
  
  for (var_name in map_source_vars){
    if (!(var_name %in% source_vars)){
      missing_from_source <- c(missing_from_source, var_name)
    }
  }
  
  # DATA CHECK 4: Ensure all the variables present in the source data frame are
  # either included in the variable map, or listed for exclusion.
  
  missing_from_map <- c()
  
  for (var_name in source_vars){
    if (!(var_name %in% c(map_source_vars, excluding_vars))){
      missing_from_map <- c(missing_from_map, var_name)
    }
  }
  
  # If either DATA CHECK 3 or 4 failed, stop and print a detailed message.
  
  if(length(missing_from_source) > 0 | length(missing_from_map) >0){
    
    missing_from_source <- paste0("Variables missing from ", source_df_col, ": ", 
                                  paste(missing_from_source, sep = ", "))
    
    missing_from_map <- paste0("Variables missing from var_map & excluding_vars: ", 
                               paste(missing_from_map, sep = ", "))
    
    stop(paste(missing_from_source, missing_from_map, sep = "\n"))
  }
  
  # Cleanup in case of memory leak
  rm(missing_from_source)
  rm(missing_from_map)
  
  # Remove the exclusion variables, use select to ensure the order of 
  # the kept variables is the same as in the replacement map, and 
  # rename variables using the variable map.
  
  source_df <- source_df %>%
    select(-all_of(excluding_vars)) %>%
    select(all_of(setdiff(source_vars, excluding_vars))) %>%
    rename_with(~section$variable, all_of(map_source_vars))
  
  # Return the revised data frame
  
  source_df
  
}