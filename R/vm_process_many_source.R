vm_process_many_source <- function(var_map, packaged_sources){
  # Process multiple data sources using vm_process_source_df() and stack
  # the rows of the results into a single tibble.
  #
  # Built with R version 4.2.2
  #
  # Requires: 
  #     'dplyr' - built with version 1.1.1
  #     'tibble' - built with version 3.2.1
  #     vm_check()
  #     vm_process_source_df()
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
  #   'packaged_sources' (list) - a packaged set of variables that will be
  #                             passed through vm_process_source_df(). Requires
  #                             the following for EACH source being processed.
  #                             The order of each of the lists must be the same
  #                             (i.e., the first source must be first in all
  #                               three lists, the second second in all, etc.)
  #             'source_df' (list of tibbles) - list of the source data, 
  #                                 tibble form preferred. Use list().
  #             'source_df_col' (list of strings) - list of the names of the 
  #                                   columns in 'var_map' that correspond to 
  #                                   the variables in each 'source_df'
  #             'excluding_vars' (list of lists of strings) - list of the list
  #                             of the variables present in each
  #                             'source_df' that are to be excluded from
  #                             processing. Variables not present in 'var_map'
  #                             but in a 'source_df' must be listed here.
  #                             Use c() for each list, within list()!
  #
  # EXAMPLE GENERATION OF 'packaged_sources':
  #   packaged_sources <- tibble::tibble(
  #       'source_df' = list(df_1, df_2, df_3),
  #       'source_df_col' = c('df_1_var', 'df_2_var', 'df_3_var'),
  #       'excluding_vars' = list(c('v1'), c('v5','v6'), c()),
  #     )
  #
  # OUTPUT:
  #       A data frame where all values of the variables in all 'source_df's
  #       have been renamed according to 'var_map', with 'excluded_vars' 
  #       omitted, and the data frame rows stacked.
  #       

  
  # Check if vm_check() has been imported
  
  if(!exists('vm_check')){
    stop("Requires the vm_check() function. Please import and try again!")
  }
  
  # Check if vm_process_source_df() has been imported
  
  if(!exists('vm_process_source_df')){
    stop("Requires the vm_process_source_df() function. Please import and try again!")
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
  
  # DATA CHECK 2: Checking packaged variables are as expected
  if(length(packaged_sources) != 3){
    stop("Wrong number of arguments in packaged_sources")
  }
  if(!identical(sort(names(packaged_sources)), 
                c('excluding_vars', 'source_df', 'source_df_col'))){
    stop("Wrong variable names in packaged_sources")
  }
  # if 'excluding_vars' is empty, replace it with an empty list of
  # an appropriate length
  
  if(length(packaged_sources$excluding_vars) == 0){
    packaged_sources$excluding_vars <- vector(mode='list', 
                                              length=length(packaged_sources$source_df))
  }
  # Check all components are the same length
  if(length(packaged_sources$source_df) !=
     length(packaged_sources$source_df_col)){
    stop("Unequal length of 'source_df' and 'source_df_col'")
  }
  if(length(packaged_sources$source_df) !=
     length(packaged_sources$excluding_vars)){
    stop("Unequal length of 'source_df' and 'excluding_vars'")
  }
  if(length(packaged_sources$source_df_col) !=
     length(packaged_sources$excluding_vars)){
    stop("Unequal length of 'source_df_col' and 'excluding_vars'")
  }
  
  # Initialize output tibble
  output_tibble <- tibble::tibble(!!!c(), .rows = 0)
  
  for(i in 1:length(packaged_sources$source_df)){
    # Unpack the variables relating to each source
    
    source_df <- packaged_sources$source_df[[i]]
    source_df_col <- packaged_sources$source_df_col[[i]]
    excluding_vars <- packaged_sources$excluding_vars[[i]]
    
    # Process the source
    processed <- vm_process_source_df(var_map, source_df, source_df_col,
                                      excluding_vars)
    
    # Add to the output tibble
    output_tibble <- bind_rows(output_tibble, processed)
    
  }
  
  # Clean up in case of memory leak
  rm(source_df)
  rm(source_df_col)
  rm(excluding_vars)
  rm(processed)
  
  # Return the output
  output_tibble
}