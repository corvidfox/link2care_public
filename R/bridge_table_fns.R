# =============================================================================
# Helpers for the Bridge sessions Table
# 2023-03-21
# =============================================================================

# Helper function to calculate median, min, and max sessions and minutes
med_sesssions_minutes_fn <- function(.data, .col="Overall") {
  
  # If .col = Overall, then calculate stats without stratifying by group
  # Otherwise, filter .data for the value passed to .col (e.g., "UCM")
  if (.col != "Overall") {
    .data <- .data |> 
      filter(group_f == .col)
  }
  
  # Calculate the summary stats
  .data <- .data |> 
    summarise(
      sessions_median = median(total_sessions),
      sessions_min = min(total_sessions),
      sessions_max = max(total_sessions),
      minutes_median = median(total_minutes),
      minutes_min = min(total_minutes),
      minutes_max = max(total_minutes)
    )
  
  # Pass the value of .col on to med_sesssions_minutes_format_fn so we don't
  # have to type it as an argument to both functions 
  .data |> 
    mutate(col = .col)
}


# Helper function to format median, min, and max sessions and minutes for easy
# copy and paste into the Word document.
med_sesssions_minutes_format_fn <- function(.data) {
  
  # Grab the value of .col that was set in med_sesssions_minutes_fn
  # Then remove it from the data frame
  .col <- pull(.data, col)
  .data$col <- NULL
  
  .data |> 
    # Remove decimals and add commas to numbers
    mutate(
      across(
        everything(),
        ~ round(.x, 0) |> format(big.mark = ",")
      )
    ) |> 
    
    # Concatenate median, min, and max into a single string
    mutate(
      sessions = paste0(sessions_median, " (", sessions_min, "-", sessions_max, ")"),
      minutes = paste0(minutes_median, " (", minutes_min, "-", minutes_max, ")")
    ) |>
    
    # Pivot for column bind later
    select(sessions, minutes) |> 
    pivot_longer(
      everything(),
      names_to = c("measure"),
      values_to = .col
    )
}