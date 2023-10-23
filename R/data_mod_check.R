data_mod_check <- function(
    df, df_path_str, orig_path_str, mod_dt, num_rows, num_cols, col_names
) {
  
  # Checks for any differences in a data file being sourced, creates an
  # informative message, and prints as a WARNING
  
  
  # Initiate list of messages
  w_messages <- list() 
  
  # Set default return value to "TRUE" (would change in message check)
  return_val <- TRUE
  
  
  # Check File Paths
  
  if (df_path_str != orig_path_str){
    w_messages <- append(w_messages, paste(
      "Path has changed! \n",
      "It was originally:", "\n",
      as.character(orig_path_str), "\n",
      "It's now:", "\n",
      as.character(df_path_str)
    )
    )
  }
  
  # Check Source File Modification Dates, if desired
  # calls "floor" on the mod date pulled from the file to avoid mili-seconds
  # creating inequalities
  
  if(!is.na(mod_dt)){
    if (floor_date(file.info(df_path_str)$mtime) != mod_dt) {
      w_messages <- append(w_messages, paste(
        "File modification date has changed! \n",
        "It was originally:", "\n",
        as.character(mod_dt), "\n",
        "It's now:", "\n",
        as.character(file.info(df_path_str)$mtime)
      )
      )
    }
  }
  
  # Check Number of Columns
  
  if (ncol(df) != num_cols){
    w_messages <- append(w_messages, paste(
      "Number of columns has changed! \n",
      "It was originally:", "\n",
      as.character(num_cols), "\n",
      "It's now:", "\n",
      as.character(ncol(df))
    )
    )
  }
  
  # Check Number of Rows
  
  if (nrow(df) != num_rows){
    w_messages <- append(w_messages, paste(
      "Number of rows has changed! \n",
      "It was originally:", "\n",
      as.character(num_rows), "\n",
      "It's now:", "\n",
      as.character(nrow(df))
    )
    )
  }
  
  # Check Column Names - Sorted to ignore position changes
  
  if (!identical(sort(colnames(df)),sort(col_names))){
    w_messages <- append(w_messages, paste(
      "Column names have changed!"
    )
    )
  }
  
  # If any check failed:  
  
  if(length(w_messages) > 0){
    
    # Modify the error messages to be more human-legible and organized
    
    for (i in 1:length(w_messages)){
      w_messages[i] <- paste0("Issue ", i, ": ", w_messages[i])
    }
    
    # Return warning
    
    warning(
      paste(paste0(as.character(length(w_messages)), " differences found: \n"),
            paste(w_messages, collapse = "\n")
      )
    )
    
    # Ensure we return as "FALSE"
    
    return_val <- FALSE
  }
  
  # Return our value  
  return_val
}