vm_check <- function(full_map){
  # Runs a variable map through a series of checks to ensure it meets standard.
  # Checks that:
  #     1. Each 'variable' is unique
  #     2. Each 'section' is consistently represented by a single value of
  #         'sec_ord', and no two sections share the same order
  #     3. Each 'instrument' is consistently represented by a single value of
  #         'inst_ord'
  #     4. There is only one 'instrument' for each 'inst_ord' within the same
  #         'section'
  #     5. That each 'instrument' only appears within one 'section'.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #
  # INPUT:
  #       'full_map' (tibble) - a variable map data frame
  # Expects the following columns to be present in 'full_map':
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
  #
  # RETURNS:
  #     The Boolean/logical "TRUE" if all conditions are met, map is valid.
  #     Otherwise prints the list of issues, returns "FALSE".
  
  
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
  
  issues <- c()
  
  # DATA CHECK 1: Each 'variable' is unique
  # Checks two ways
  
  if(!(sum(duplicated(full_map$variable)) == 0)|(nrow(full_map) != 
                                          length(unique(full_map$variable)))){
    issues <- c(issues, 
                "There are duplicate variable values. Check: 'variable'")
  }
  
  # DATA CHECK 2: Each 'section' is consistently represented by a single value
  # of 'sec_ord'
  
  # Subset variables of interest into unique combinations
  checking <- full_map %>%
    select(section, sec_ord) %>%
    distinct()
  
  if (nrow(checking) > length(unique(checking$sec_ord))){
    # If more combinations than unique section orders, two sections
    # must share the same order value
    issues <- c(issues, 
      "Two or more sections share the same order. Check: 'section', 'sec_ord'")
  }
  if (nrow(checking) > length(unique(checking$section))){
    # If more combinations than unique sections, one section must
    # two or more values for section order
    issues <- c(issues, 
      "One section has two or more section orders. Check: 'section', 'sec_ord'")
  }
  
  # DATA CHECK 3: Each 'instrument' is consistently represented by a single value
  # of 'inst_ord'
  
  # Subset variables of interest into unique combinations
  checking <- full_map %>%
    select(instrument, inst_ord) %>%
    distinct()
  
  if (nrow(checking) > length(unique(checking$instrument))){
    # If there are more combinations of instrument & instrument order than
    # there are unique instruments, then one instrument must have more than one
    # order assigned.
    issues <- c(issues, 
"An instrument has two or more orders assigned. Check: 'instrument', 'inst_ord'")
  }
  
  # DATA CHECK 4: There is only one 'instrument' for each 'inst_ord' within the
  # same 'section'
  
  for (section_name in unique(full_map$section)){
    checking <- full_map %>%
      filter(section == section_name) %>%
      select(instrument, inst_ord) %>%
      distinct()
    
    if(sum(duplicated(checking$instrument)) > 0){
      # if there an instrument appears more than once, it has more than one
      # instrument order within the section.
      issues <- c(issues,
           "An instrument has two or more orders assigned within one section.")
    }
    if(sum(duplicated(checking$inst_ord)) > 0){
      # if an instrument order appears more than once, it has been assigned to
      # more than one instrument.
      issues <- c(issues,
  "Two or more instruments have been assigned the same order within a section")
    }
  }
  
  # DATA CHECK 5: Each 'instrument' should only appear within one 'section'
  
  checking <- full_map %>%
    select(section, instrument) %>%
    distinct()
  
  if(sum(duplicated(checking$instrument))>0){
    # if an instrument appears more than once, it is assigned to more than one
    # section
    issues <- c(issues,
                "An instrument is assigned to two or more sections")
  }
  
  # Ensure a measure of cleanup in case of data leak
  rm(checking)
  
  if(length(issues) == 0){
    # If no issues, return TRUE
    return(TRUE)
  }
  if (length(issues) > 0 ){
    # If issues exist, print issues to console and return FALSE
    print(issues)
    return(FALSE)
  }
  
}
