vm_add_variable <- function(full_map, instrument_name, new_var, 
                                prev_var = 0){
  # Adds a variable to the variable map by inserting the variable.
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
  #   'instrument_name' (string) - instrument in which the variable is to be
  #                             inserted
  #   'new_var' (string) - a unique variable name for the new variable
  #   'prev_var' (string) - the name of the variable directly preceeding the
  #                             new variable (i.e., if "prev_var" is item 1,
  #                             "new_var" should be item 2).
  #                             Default is 0 - indicating the new variable is
  #                             the new first item of the instrument.
  #
  # OUTPUT:
  #       revised version of 'full_map' with the new variable inserted.
  
  
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
  
  
  # DATA CHECK 1 - checks full_map
  if(!vm_check(full_map)){
    stop("Input variable map has existing issues. Please resolve first.")
  }
  
  # Pull section of map for the instrument
  
  subset <- full_map %>%
    filter(instrument == instrument_name)
  
  
  # DATA CHECK 2 - ensure that new_var is not already represented in the
  # variable map (both the subset for the item, and overall)
  
  if (new_var %in% subset$variable){
    
    stop(paste(new_var, "also appears in the map for instrument: ", 
               instrument_name))
  }
  
  if (new_var %in% full_map$variable){
    
    stop(paste(new_var, "already exists in the variable map, just not in",
               instrument_name))
  }
  
  
  # Data check 3 - ensure that prev_var, if given, is part of this instrument
  
  if (prev_var == 0){
    var_position <- 1
  }
  if(prev_var != 0) {
    if(!(prev_var %in% subset$variable)){
      
      stop(paste(prev_var, "not in", instrument_name))
      
    }
    # If it is, get its position. If not, stop and raise error.
    if(prev_var %in% subset$variable){
      var_position <- subset[subset$variable == prev_var,]$item_ord + 1
    }
    
  }
  
  # Shift item order to add the desired variable in the desired position
  
  subset <- subset %>%
    mutate(item_ord = ifelse(item_ord >= var_position, 
                             item_ord + 1, 
                             item_ord))
  
  # Add new row. Take values for Section and Instrument from the existing data
  # for consistency, fewer chances for typos.
  
  subset <- dplyr::bind_rows(subset, 
                             tibble::tibble(
                               'variable' = new_var,
                               'section' = unique(subset$section),
                               'sec_ord' = unique(subset$sec_ord),
                               'instrument' = instrument_name,
                               'inst_ord' = unique(subset$inst_ord),
                               'item_ord' = var_position
                             )
  )
  rm(var_position)
  # Replace full map's section with the revised section, enforce order 
  
  full_map <- dplyr::bind_rows(
    full_map %>%
      filter(instrument != instrument_name),
    subset) %>%
    arrange(sec_ord, inst_ord, item_ord)
  
  rm(subset)
  # return revised full map
  
  full_map
}