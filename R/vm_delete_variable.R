vm_delete_variable <- function(full_map, target_variable){
  # Removes a variable from the variable map, and closes any gaps.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #     vm_check()
  #
  # INPUT:
  #   'full_map' (tibble) - tibble of the following minimum content:
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
  #   'target_var' (string) - the name of the variable to delete. Must be a
  #                             value present in full_map$variable to be removed
  #
  # OUTPUT:
  #       revised version of 'full_map' with the target variable removed.
  
  
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

  
  # DATA CHECK 1 - checks full_map for existing issues, and presence of
  # target_variable in full_map$variable
  
  if(!vm_check(full_map)){
    stop("Input variable map has existing issues. Please resolve first.")
  }
  
  if(!(target_variable) %in% full_map$variable){
    warning("Target variable is not present in the input map. Nothing to remove.")
    return(full_map)
  }
  
  
  # Pull section of map for the instrument
  
  t_var_instrument <- unique(full_map[full_map$variable == 
                                        target_variable,]$instrument)
  
  subset <- full_map %>%
    filter(instrument == t_var_instrument)
  
  # Remove the item from the subset after extracting it's position in the
  # instrument
  
  t_var_item_ord <- unique(full_map[full_map$variable == 
                                      target_variable,]$item_ord)
  
  subset <- subset %>%
    filter(variable != target_variable)
  
  # Shift item order to close the gap created by removing the item
  
  subset <- subset %>%
    mutate(item_ord = ifelse(item_ord >= t_var_item_ord, 
                             item_ord - 1, 
                             item_ord))
  

  # Replace full map's section with the revised section, enforce order 
  
  full_map <- dplyr::bind_rows(
    full_map %>%
      filter(instrument != t_var_instrument),
    subset) %>%
    arrange(sec_ord, inst_ord, item_ord)
  
  # Clean up in case of memory leak
  
  rm(t_var_instrument)
  rm(t_var_item_ord)
  rm(subset)
  
  # return revised full map
  
  full_map
}