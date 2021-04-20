# =============================================================================
# nines_to_na
# 2021-04-14
# =============================================================================

# Convert 9's (or 7's, or 8's) to NA's and then add attributes back to vector.

# First, I have to remove the "have_labelled" and "vctrs_vctr" class from each variable for if_else() to work.

# But, I also need to keep the label attributes. They are erased when I convert the 9's to NA.

nines_to_na <- function(x, nines) {
  # Store the attributes
  x_attr <- attributes(x)
  # Remove "haven_labelled" and "vctrs_vctr" from class list so that if_else()
  # will work.
  # Set class of column to whatever is remaining in the class list.
  classes <- class(x)
  class(x) <- classes[!class(x) %in% c("haven_labelled", "vctrs_vctr")]
  # Convert 9's to NA's
  x <- if_else(x %in% nines, NA_real_, x)
  # Add attributes back to the vector
  attributes(x) <- x_attr
  # Return x
  x
}

# For testing
# test <- v1
# test$SQ_13[1] <- 7
# test$SQ_13[3] <- 9
# test$SQ_13[4] <- 99
# test %>%
#   select(SQ_13) %>%
#   mutate(SQ_13_test = nines_to_na(SQ_13, c(7, 9, 99))) %>%
#   pull(SQ_13_test) %>%
#   attributes()
# rm(test)