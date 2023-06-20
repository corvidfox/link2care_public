Notes on files in the data subdirectory
================
Created: 2021-04-23 <br> Updated: 2023-06-20

# ignored

This folder contains data files with PHI and/or other HIPAA protected
data. This folder, and all files in it, are ignored by git and are not
uploaded to GitHub. Therefore, each local repository will need to
manually download the data from our secure server and add it to this
folder in order for the code files to access the data they need.

# columns.csv

**Created in:** data_survey_01_qds_v1_import.Rmd  
**Updated in:** The plan is to update this file for v2-v5. Come back and
update this when that happens.  
**Description:** A key that links all the new column names in the
combined analysis data set with the column names from the original
separate data set codebooks.

# questionnaire_section.rds

**Created in:** data_survey_01_qds_v1_import.Rmd  
**Updated in:** The plan is to update this file for v2-v5. Come back and
update this when that happens.  
**Description:** We will use this for checking to make sure all of the
correct questionnaire sections merge later.

# v1_spss_calc_vars.sav

**Created in:** data_survey_01_qds_v1_import.Rmd  
**Description:** The calculated variables that were created by the SPSS
script that converts the visit 1 QDS data into an SPSS .SAV file. We
recreate these columns in {file name}, but preserved them in this data
set for double checking the calculations.
