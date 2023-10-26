vm_factor_apply_val_labels <- function(
    t_df, var_map, variable_name_var = 'variable'
    ){
  #
  # Converts any variable with a list of value labels into a factor variable
  # and applies those labels.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #     vm_check()
  #
  # INPUT:
  #   't_df' (tibble) - input tibble to modify
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
  #       'attr_var_labels' (list) - list containing the level = label pairs
  #                             for the variable
  #   'instrument_name' (string) - instrument in which the variable is to be
  #                             inserted
  #   'variable_name_var' (string) - name of the column in var_map that
  #                             contains the column names present in t_df
  #                             to modify. Default is 'variable'.
  #
  # OUTPUT:
  #       revised version of 't_df' with factor variables converted into
  #       factors, and labeled using the values of `attr_var_labels`
  
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
  
  
  # DATA CHECK: Checks if var_map meets variable map requirements.
  if(!vm_check(var_map)){
    stop("Input variable map has existing issues. Please resolve first.")
  }
  if(!('attr_var_labels' %in% colnames(var_map))){
    stop("Input variable map lacks 'attr_var_labels - nothing to process!") 
  }
  
  # Subset the variable map to only include the necessary columns and rows,
  # and standardize the variable_name_var to facilitate dplyr selection
  
  var_map <- var_map %>%
    rowwise() %>%
    filter(!is.null(attr_var_labels)) %>%
    ungroup() %>%
    select(all_of(variable_name_var), attr_var_labels) %>%
    rename_at(variable_name_var, ~'variable') %>%
    filter(!is.na(variable))
  
  # Strip labels from the input variable map columns, if present,
  # to avoid processing errors using `pull()`
  
  for (var_name in colnames(var_map)){
    attributes(var_map[[var_name]])$label <- NULL
  }
  
  # DATA CHECK: ensure all variables in var_map are present in the input
  # data frame
  
  for (var_name in var_map$variable){
    message <- c()
    
    if (!(var_name) %in% colnames(t_df)){
      message <- c(message, var_name)
    }
    
    if (length(message > 1)){
      message <- paste0(
        "The following variables in the variable map are not present ",
        "in the input data frame: ",
        paste(message, collase = ", ")
        )
        
        stop(message)
    }
  }
  
  
  # For each variable with value labels...
  for (var_name in var_map$variable){
    
    # Create tibble from the variable map `attr_val_labels`, filtered to only
    # include values actually present to avoid errors in conversion to a labeled
    # factor variable
    
    var_val_labels <- tibble::tibble(
      'val_text' = names(pull(
        var_map %>%
          filter(variable == var_name) %>%
          select(attr_var_labels)
      )[[1]]
      )
    ) %>%
      mutate(
        'val' = pull(
          var_map %>%
            filter(variable == var_name) %>%
            select(attr_var_labels)
        )[[1]][val_text]
      ) %>%
      filter(val %in% unique(t_df[[var_name]]))
    
    # Use the tibble to define levels and labels in converting the variable
    # into a factor
    
    t_df[[var_name]] <- factor(
      t_df[[var_name]],
      levels = var_val_labels$val,
      labels = var_val_labels$val_text)
    
  }
  
  # Return the output tibble
  t_df
}