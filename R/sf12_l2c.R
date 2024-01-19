#############################################################################
#                                                                           #
#                    L2C SF-12 questionnaire scoring                        #
#                                                                           #
#############################################################################

#############################################################################
#                                                                           #
#     This is a modification of an R port by Ibgralia found online at       # 
#       (https://rdrr.io/github/lbraglia/QScoring/src/R/sf12.R)             #
#         The original code by Ibraglia was an R port of an SAS             #
#             algorithm by Apolone and Mosconi, credited at                 #
#          (http://crc.marionegri.it/qdv/index.php?page=sf12)               #
#         At the time of creation (2024-01-18), this link produced          #
#     404 errors, and attempts to locate the data online were unsucessful.  #
#                                                                           #
#       This version of SF-12 Scoring was written to facilitate a           #
#     data-set specific modification, as question 12 was presented          #
#     as a 6-point item, rather than a 5-point item as done in the          #
#             original SF-12 and SF-12 scoring algorithms.                  #
#   Specifically, Option 3 "A good bit of the time" was not originally      #
#     present, and this modified scoring algorithm weighs Option 3          #
#       by the average of the weight given to Option 2 and Option 4.        #
#                                                                           #
#         SF-12  is a registered trademark of medical outcomes trust.       #
#                                                                           #
#############################################################################

# Input:
#     X (dataframe, matrix):  12 column data frame of the SF12 questionnaire
#           items, with scores stored as integers. Items are required to be
#           in order, as this function overwrites column names for greater
#           flexibility in application.
#       Order | Function Var Name | Content | [valid score range for question]:
#         01    gh1       General Health                          1-5
#         02    pf02      Moderate Activities                     1-3
#         03    pf04      Climbing several flights of stairs      1-3
#         04    rp2       Accomplished less (physical)            1-2
#         05    rp3       Limited in kind of work                 1-2
#         06    re2       Accomplished less (emotional)           1-2
#         07    re3       Did work less careful                   1-2
#         08    bp2       Bodily pain                             1-5
#         09    mh3       Calm and peaceful                       1-6
#         10    vt2       Energy                                  1-6
#         11    mh4       Downhearted and Blue                    1-6
#         12    sf2       Social limitations (time)               1-6
#
# Output:
#       data.frame(PCS12, MCS12):
#               PCS12: Physical scale
#               MCS12: Mental scale

sf12_l2c <- function( X = NULL ) {
  
  # Validate input type and shape
  # =========================================================================
  
  if((!(is.data.frame(X) | is.matrix(X))) | (ncol(X)!=12) )
    stop("X must be a data.frame (or matrix) with 12 columns")
  
  # Rename columns
  # =========================================================================
  X <- as.data.frame(lapply(as.data.frame(X), as.integer))
  names(X) <- c("gh1", "pf02", "pf04", "rp2", "rp3", "re2", "re3", "bp2",
                "mh3", "vt2", "mh4", "sf2" )
  
  
  # STEP 1: Data Cleaning, Reverse Scoring
  # =========================================================================
  
  # Validate scoring ranges
  # -------------------------------------------------------------------------
  twopt <- c("rp2", "rp3", "re2", "re3")
  threept <- c("pf02", "pf04")
  fivept <- c("gh1", "bp2")
  sixpt <- c("vt2", "mh3", "mh4", "sf2")
  
  # outRangeNA was originally written and defined in utils.R under Ibraglia
  ## If a variable has values outside Min or Max, set them to NA
  outRangeNA <- function(x, Min = 1L, Max) replace(x, x < Min | x > Max, NA)
  
  X[, twopt] <- lapply(X[, twopt], outRangeNA, Max = 2L)
  X[, threept] <- lapply(X[, threept], outRangeNA, Max = 3L)
  X[, fivept] <- lapply(X[, fivept], outRangeNA, Max = 5L)
  X[, sixpt] <- lapply(X[, sixpt], outRangeNA, Max = 6L)
  
  # Reverse Scoring for gh1, bp2, mh3, and vt2
  X$rgh1  <-  6 - X$gh1
  X$rbp2  <-  6 - X$bp2
  X$rmh3  <-  7 - X$mh3
  X$rvt2  <-  7 - X$vt2
  
  # STEP 2: Generate Indicator variables from responses
  # ========================================================================
  # This is done because each value within a question is provided a different
  # weight, rather than a 'scaled weight' for an entire question. As such,
  # each possible answer to a SF12 questionnaire item is coded into a separate
  # binary dummy variable for scoring.
  #
  # Maximum values are not given dummy variables for scoring, as after 
  # reversal of necessary items, the maximum value indicates maximum health
  # (i.e. for pf02 "The following questions are about activities you might do 
  # during a typical day. Does your health now limit you in these activities? 
  # If so, how much?Moderate activities, such as moving a table, pushing a
  # vacuum cleaner, bowling, or playing golf?" Response of 
  # 3 "No, not limited at all" indicates no health impairment on the measure.)
  
  # 01    gh1       General Health  (Reversed)              1-5  
  # -------------------------------------------------------------------------
  X$gh1_1 <- as.numeric(X$rgh1 == 1L) 
  X$gh1_2 <- as.numeric(X$rgh1 == 2L) 
  X$gh1_3 <- as.numeric(X$rgh1 == 3L) 
  X$gh1_4 <- as.numeric(X$rgh1 == 4L)  
  
  
  # 02    pf02      Moderate Activities                     1-3
  # -------------------------------------------------------------------------
  X$pf02_1 <- as.numeric(X$pf02 == 1L) 
  X$pf02_2 <- as.numeric(X$pf02 == 2L) 
  
  
  # 03    pf04      Climbing several flights of stairs      1-3
  # -------------------------------------------------------------------------
  X$pf04_1 <- as.numeric(X$pf04 == 1L) 
  X$pf04_2 <- as.numeric(X$pf04 == 2L) 
  
  # 04    rp2       Accomplished less (physical)            1-2
  # -------------------------------------------------------------------------
  X$rp2_1 <- as.numeric(X$rp2 == 1L)
  
  # 05    rp3       Limited in kind of work                 1-2  
  # -------------------------------------------------------------------------
  X$rp3_1 <- as.numeric(X$rp3 == 1L) 
  
  # 06    re2       Accomplished less (emotional)           1-2
  # -------------------------------------------------------------------------
  
  X$re2_1 <- as.numeric(X$re2 == 1L) 
  
  # 07    re3       Did work less careful                   1-2
  # -------------------------------------------------------------------------
  
  X$re3_1 <- as.numeric(X$re3 == 1L) 
  
  # 08    bp2       Bodily pain (Reversed)                  1-5
  # -------------------------------------------------------------------------
  
  X$bp2_1 <- as.numeric(X$rbp2 == 1L) 
  X$bp2_2 <- as.numeric(X$rbp2 == 2L) 
  X$bp2_3 <- as.numeric(X$rbp2 == 3L) 
  X$bp2_4 <- as.numeric(X$rbp2 == 4L) 
  
  # 09    mh3       Calm and peaceful (Reversed)            1-6
  # -------------------------------------------------------------------------
  
  X$mh3_1 <- as.numeric(X$rmh3 == 1L) 
  X$mh3_2 <- as.numeric(X$rmh3 == 2L) 
  X$mh3_3 <- as.numeric(X$rmh3 == 3L) 
  X$mh3_4 <- as.numeric(X$rmh3 == 4L) 
  X$mh3_5 <- as.numeric(X$rmh3 == 5L)   
  
  # 10    vt2       Energy      (Reversed)                  1-6
  # -------------------------------------------------------------------------
  
  X$vt2_1 <- as.numeric(X$rvt2 == 1L) 
  X$vt2_2 <- as.numeric(X$rvt2 == 2L) 
  X$vt2_3 <- as.numeric(X$rvt2 == 3L) 
  X$vt2_4 <- as.numeric(X$rvt2 == 4L) 
  X$vt2_5 <- as.numeric(X$rvt2 == 5L) 
  
  # 11    mh4       Downhearted and Blue                    1-6
  # -------------------------------------------------------------------------
  
  X$mh4_1 <- as.numeric(X$mh4 == 1L) 
  X$mh4_2 <- as.numeric(X$mh4 == 2L) 
  X$mh4_3 <- as.numeric(X$mh4 == 3L) 
  X$mh4_4 <- as.numeric(X$mh4 == 4L) 
  X$mh4_5 <- as.numeric(X$mh4 == 5L) 
  
  # 12    sf2       Social limitations (time)               1-6
  # -------------------------------------------------------------------------
  
  X$sf2_1 <- as.numeric(X$sf2 == 1L) 
  X$sf2_2 <- as.numeric(X$sf2 == 2L) 
  X$sf2_3 <- as.numeric(X$sf2 == 3L) 
  X$sf2_4 <- as.numeric(X$sf2 == 4L) 
  X$sf2_4 <- as.numeric(X$sf2 == 5L) 
  
  # STEP 3: Aggregating scores into physical and mental subscoresm using
  #         weights to indicator variables
  # ========================================================================
  
  # Physical
  # -------------------------------------------------------------------------
  RAWPCS12 <- with(X,
                   (-7.23216*pf02_1) + (-3.45555*pf02_2) +
                     (-6.24397*pf04_1) + (-2.73557*pf04_2) +
                     (-4.61617*rp2_1) + 
                     (-5.51747*rp3_1) +
                     (-11.25544*bp2_1) + (-8.38063*bp2_2) +
                     (-6.50522*bp2_3) + (-3.80130*bp2_4) + (-8.37399*gh1_1) +
                     (-5.56461*gh1_2) + (-3.02396*gh1_3) + (-1.31872*gh1_4) +
                     (-2.44706*vt2_1) + (-2.02168*vt2_2) + (-1.6185*vt2_3) +
                     (-1.14387*vt2_4) + (-0.42251*vt2_5) + (-0.33682*sf2_1) +
                     (-0.94342*sf2_2) + (-0.18043*sf2_3) + (0.11038*sf2_4) +
                     (3.04365*re2_1) + (2.32091*re3_1) + (3.46638*mh3_1) +
                     (2.90426*mh3_2) + (2.37241*mh3_3) + (1.36689*mh3_4) +
                     (0.66514*mh3_5) + (4.61446*mh4_1) + (3.41593*mh4_2) +
                     (2.34247*mh4_3) + (1.28044*mh4_4) + (0.41188*mh4_5))
  # Mental
  # -------------------------------------------------------------------------
  RAWMCS12 <- with(X,
                   (3.93115*pf02_1) + (1.8684*pf02_2) +
                     (2.68282*pf04_1) + (1.43103*pf04_2) + (1.4406*rp2_1) +
                     (1.66968*rp3_1) + (1.48619*bp2_1) + (1.76691*bp2_2) +
                     (1.49384*bp2_3) + (0.90384*bp2_4) + (-1.71175*gh1_1) +
                     (-0.16891*gh1_2) + (0.03482*gh1_3) + (-0.06064*gh1_4) +
                     (-6.02409*vt2_1) + (-4.88962*vt2_2) + (-3.29805*vt2_3) +
                     (-1.65178*vt2_4) + (-0.92057*vt2_5) + (-6.29724*sf2_1) +
                     (-8.26066*sf2_2) + (-6.94676*sf_3) + (-5.63286*sf2_4) + 
                     (-3.13896*sf2_5) +     
                     (-6.82672*re2_1) + (-5.69921*re3_1) + (-10.19085*mh3_1) +
                     (-7.92717*mh3_2) + (-6.31121*mh3_3) + (-4.09842*mh3_4) +
                     (-1.94949*mh3_5) + (-16.15395*mh4_1) + (-10.77911*mh4_2) +
                     (-8.09914*mh4_3) + (-4.59055*mh4_4) + (-1.95934*mh4_5))
  
  # STEP 5: Norm-Based Standardization of Scale Scores
  # ------------------------------------------------------------------------
  
  PCS12 <- RAWPCS12 + 56.57706
  MCS12 <- RAWMCS12 + 60.75781
  
  return(data.frame(PCS12, MCS12))
  
}