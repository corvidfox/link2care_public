# =============================================================================
# source_rmd
# 2021-05-10

# Source an R markdown file like an R Script. 
# Solution comes from this post on the RStudio Community: 
# https://community.rstudio.com/t/prevent-rmarkdown-document-from-creating-any-output-file/81871
# =============================================================================


source_rmd <- function(file, ...) {
  tmp_file = tempfile(fileext=".R")
  on.exit(unlink(tmp_file), add = TRUE)
  knitr::purl(file, output=tmp_file)
  source(file = tmp_file, ...)
}