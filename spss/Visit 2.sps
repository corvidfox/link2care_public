* Encoding: UTF-8.
*L2C Visit 2


*TCU Drug Screen 5. 
IF (DS10A_V2 = 1 or DS10B_V2 = 1) DS10_V2 = 1. 
IF (DS10A_V2 = 0 AND DS10B_V2 = 0) DS10_V2 = 0. 
VARIABLE LABELS DS10_V2 'combinted 10a or 10b'. 
VALUE LABELS DS10_V2 0 ' answered no to both 10a and 10b' 1 ' answered yes to either 10a or 10b'. 
EXECUTE. 

IF (DS11A_V2 = 1 or DS11B_V2 = 1) DS11_V2 = 1. 
IF (DS11A_V2 = 0 AND DS11B_V2 = 0) DS11_V2 = 0. 
VARIABLE LABELS DS11_V2 'combinted 11a or 11b'. 
VALUE LABELS DS11_V2 0 ' answered no to both 11a and 11b' 1 ' answered yes to either 11a or 11b'. 
EXECUTE.

COMPUTE TCU_DS_TOTAL_V2 = DS11_V2 + DS10_V2 + DS1_V2 + DS2_V2 + DS3_V2 + DS4_V2 + DS5_V2 + 
DS6_V2 + DS7_V2 + DS8_V2 + DS9_V2.
VARIABLE LABELS TCU_DS_TOTAL_V2 'Sum TCU drug screen 5'. 
EXECUTE. 

IF ( TCU_DS_TOTAL_V2 = 2 OR TCU_DS_TOTAL_V2 = 3) TCU_DS_SCORE_V2 = 1.  
IF ( TCU_DS_TOTAL_V2 = 4 OR TCU_DS_TOTAL_V2 = 5) TCU_DS_SCORE_V2 = 2.  
IF ( TCU_DS_TOTAL_V2 >5) TCU_DS_SCORE_V2 = 3.  
IF ( TCU_DS_TOTAL_V2 <= 1 ) TCU_DS_SCORE_V2 = 0.  
VARIABLE LABELS TCU_DS_SCORE_V2 'score of 0 (score total <= 1) score of 1 (mild disorder), score of 2 (moderate disorder), score of 3 (severe disorder)'.
VALUE LABELS DS11_V2 0 'score total <= 1' 1 ' mild disorder' 2 ' moderate disorder' 3 'severe disorder'. 
EXECUTE. 

*Personality Beliefs Questoinnaire. 
COMPUTE pbq_v2_total = PBQ1 + PBQ2 + PBQ3 + PBQ4 + PBQ5 + PBQ6 + PBQ7.  
VARIABLE LABELS pbq_v2_total 'Sum Antisocial Subscale of the Personality Beliefs Questionnaire'. 
EXECUTE. 

*USDA Food Security Survey.
IF (FSS1_V2 = 0 OR FSS1_V2 = 1) FSSa_V2 = 1.
IF (FSS1_V2 = 2 OR FSS1_V2 = 99) FSSa_V2 = 0.
VARIABLE LABELS FSSa_V2 'Recode into yes or no'.
VALUE LABELS FSSa_V2 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS2_V2 = 0 OR FSS2_V2 = 1) FSSb_V2 = 1.
IF (FSS2_V2 = 2 OR FSS2_V2 = 99) FSSb_V2 = 0.
VARIABLE LABELS FSSb_V2 'Recode into yes or no'.
VALUE LABELS FSSb_V2 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS3_V2 = 1) FSSc_V2 = 1.
IF (FSS3_V2 = 0 OR FSS3_V2 = 9) FSSc_V2 = 0.
VARIABLE LABELS FSSc_V2 'Recode into yes or no'.
VALUE LABELS FSSc_V2 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS4_V2 = 1) FSSd_V2 = 1.
IF (FSS4_V2 = 0 OR FSS4_V2 = 9) FSSd_V2 = 0.
VARIABLE LABELS FSSd_V2 'Recode into yes or no'.
VALUE LABELS FSSd_V2 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS5_V2 = 1) FSSe_V2 = 1.
IF (FSS5_V2 = 0 OR FSS5_V2 = 9) FSSe_V2 = 0.
VARIABLE LABELS FSSe_V2 'Recode into yes or no'.
VALUE LABELS FSSe_V2 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS3A_V2 = 0 OR FSS3A_V2 = 1) FSSf_V2 = 1.
IF (FSS3A_V2 = 2 OR FSS3A_V2 = 9 or FSSc_V2 = 0) FSSf_V2 = 0.
VARIABLE LABELS FSSf_V2 'Recode into yes or no'.
VALUE LABELS FSSf_V2 0 'no' 1 'affirmative yes'.
EXECUTE. 

Compute FSS_V2_total = FSSa_V2 + FSSb_V2  + FSSc_V2 + FSSd_V2 + FSSe_V2 + FSSf_V2. 
VARIABLE LABELS FSS_V2_total 'Sum of FSSa_v2 - FSSf_v2'.
EXECUTE. 

IF (FSS_V2_total <=1) FSS_V2_score = 1.
IF (FSS_V2_total = 2) FSS_V2_score = 2.
IF (FSS_V2_total = 3) FSS_V2_score = 2.
IF (FSS_V2_total = 4) FSS_V2_score = 2.
IF (FSS_V2_total >=5) FSS_V2_score = 3.
VARIABLE LABELS FSS_V2_score 'Food security status'.
VALUE LABELS FSS_V2_score 1 'high or marginal food security' 2 'low food security' 3 'very low food security'.
EXECUTE. 

IF (FSS_V2_total <=1) FSS_V2_score_dichotomous= 1.
IF (FSS_V2_total >=2) FSS_V2_score_dichotomous = 2.
VARIABLE LABELS FSS_V2_score_dichotomous 'Food secure or food insecure'. 
VALUE LABELS FSS_V2_score_dichotomous 1 'food secure' 2 'food insecure'.
EXECUTE. 

* TCU CJ Client Evaluation of Self and Treatment (CJ CEST). 
*Desure for help subscale. 
COMPUTE TCU_desire_v2_total = ((CJ2_V2 + CJ3_V2 + CJ4_V2 + CJ5_V2 + CJ6_V2 +CJ7_V2)*10)/6. 
IF (CJ1_V2 = 0) TCU_desire_v2_total = 888. 
Variable labels TCU_desire_v2_total 'Sum, TCU Desire for help subscale (888 indicates they have not used drugs in past 12 months)'. 
EXECUTE. 

*Treatment needs subscale. 
COMPUTE TCU_tn_v2_total = ((CJ8_V2 + CJ9_V2 + CJ10_V2 + CJ11_V2 + CJ12_V2)*10)/5. 
Variable labels TCU_tn_v2_total 'Sum, TCU Treatment needs subscale'. 
EXECUTE. 

*Treatment Satisfaction.  
COMPUTE TCU_ts_v2_total = ((CJ13_V2 + CJ14_V2 + CJ15_V2 + CJ16_V2 + CJ17_V2 +CJ18_V2 + CJ19_V2)*10)/7. 
Variable labels TCU_ts_v2_total 'Sum, TCU treatment satisfaction subscale'. 
EXECUTE. 
 
*Self esteem. 
RECODE CJ21_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ21r_V2. 
RECODE CJ22_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ22r_V2. 
RECODE CJ23_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ23r_V2. 
RECODE CJ25_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ25r_V2. 
Variable labels CJ21r_V2 'You feel like a failure recoded'.
Variable labels CJ22r_V2 'You wish you had more respect for yourself recoded'.
Variable labels CJ23r_V2 'You feel you are basically no good recoded'.
Variable labels CJ25r_V2 'You feel you are basically no good recoded'.
COMPUTE TCU_se_v2_total = ((CJ21r_V2 + CJ22r_V2 + CJ20_V2 + CJ23r_V2 + CJ24_V2 +CJ25r_V2)*10)/6. 
Variable labels TCU_se_v2_total 'Sum, TCU self esteem subscale'. 
EXECUTE. 

*Hostility. 
COMPUTE TCU_hs_v2_total = ((CJ26_V2 + CJ27_V2 + CJ28_V2 + CJ29_V2 + CJ30_V2 +CJ31_V2 + CJ32_V2 + CJ33_V2)*10)/8. 
Variable labels TCU_hs_v2_total 'Sum, TCU hostility subscale'. 
EXECUTE. 

*Risk Taking. 
RECODE CJ34_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ34r_V2. 
RECODE CJ35_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ35r_V2. 
RECODE CJ36_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO CJ36r_V2. 
Variable labels CJ34r_V2 'You only do things that feel safe recoded'.
Variable labels CJ35r_V2 'You avoid anything dangerous recoded'.
Variable labels CJ36r_V2 'You are very careful and cautious.recoded'.
COMPUTE TCU_rt_v2_total = ((CJ34r_V2 + CJ35r_V2 + CJ36_V2 + CJ37_V2 + CJ38_V2 +CJ39_V2 + CJ40_V2)*10)/7. 
VARIABLE LABELS TCU_rt_v2_total 'Sum, TCU risk taking subscale'. 
EXECUTE. 

**MacArthur Major Discrimination. 
Compute MMD_total =  (MMD1A + MMD1B + MMD1C + MMD1D + MMD1E + MMD1F + MMD1G + MMD1H + MMD1I + MMD1J + MMD1K). 
Variable labels  MMD_total 'Sum, MacArthur Major Discrimination'. 
EXECUTE. 

*Uban life stress scale. 
Compute uls_V2_total = ULS1_V2 + ULS2_V2 + ULS3_V2 + ULS4_V2 + ULS5_V2 + ULS6_V2 + ULS7_V2 + ULS8_V2 + 
ULS9_V2 + ULS10_V2 + ULS11_V2 + ULS12_V2 + ULS13_V2 + ULS14_V2 + ULS15_V2 + ULS16_V2 + ULS17_V2 + ULS18_V2 + ULS19_V2 + 
ULS20_V2 + ULS21_V2. 
VARIABLE LABELS uls_V2_total 'urban life stress total score'.
EXECUTE.

*Perceived Stress Scale.
RECODE PS2_V2 (0=4) (1=3) (2=2) (3=1) (4=0) INTO PS2r_V2.
VARIABLE LABELS  PS2r_V2 'Perceived Stress Scale Item 2 Reverse Code'.
EXECUTE.

RECODE PS3_V2 (0=4) (1=3) (2=2) (3=1) (4=0) INTO PS3r_V2.
VARIABLE LABELS  PS3r_V2 'Perceived Stress Scale Item 3 Reverse Code'.
EXECUTE.

COMPUTE PS_V2_total=PS1_V2 + PS2r_V2 + PS3r_V2 + PS4_V2.
VARIABLE LABELS PS_V2_total 'Perceived Stress Scale total score'.
EXECUTE.

*Distress Tolerance Scale (DTS). 
*all the questions in QDS were reversed coded. Each question was recoded to the correct score, except question DTS7_V2 because
that question should be reversed coded. Question DTS8_V2 is not included in any subscale or the total score. See appendix for paper citation.  
RECODE DTS1_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS1r_V2. 
RECODE DTS2_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS2r_V2. 
RECODE DTS3_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS3r_V2. 
RECODE DTS4_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS4r_V2. 
RECODE DTS5_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS5r_V2. 
RECODE DTS6_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS6r_V2. 
RECODE DTS8_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS8r_V2. 
RECODE DTS9_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS9r_V2. 
RECODE DTS10_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS10r_V2. 
RECODE DTS11_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS11r_V2. 
RECODE DTS12_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS12r_V2. 
RECODE DTS13_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS13r_V2. 
RECODE DTS14_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS14r_V2. 
RECODE DTS15_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS15r_V2. 
RECODE DTS16_V2 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DTS16r_V2. 
Variable Labels DTS1r_V2 'Feeling distressed or upset is unbearable to me '.
Variable Labels DTS2r_V2 'When I feel distressed or upset, all I can think about is how bad I feel '.
Variable Labels DTS3r_V2 'I can’t handle feeling distressed or upset '.
Variable Labels DTS4r_V2 'My feelings of distress are so intense that they completely take over '.
Variable Labels DTS5r_V2 'There’s nothing worse than feeling distressed or upset '.
Variable Labels DTS6r_V2 'My feelings of distress or being upset are just an acceptable part of life '.
Variable Labels DTS8r_V2 'My feelings of distress or being upset are not acceptable '.
Variable Labels DTS9r_V2 'I’ll do anything to avoid feeling distressed or upset '.
Variable Labels DTS10r_V2 'Other people seem to be able to tolerate feeling distressed or upset better than I can '.
Variable Labels DTS11r_V2 'Being distressed or upset is always a major ordeal for me '.
Variable Labels DTS12r_V2 'I am ashamed of myself when I feel distressed or upset '.
Variable Labels DTS13r_V2 'My feelings of distress or being upset scare me '.
Variable Labels DTS14r_V2 'I’ll do anything to stop feeling distressed or upset '.
Variable Labels DTS15r_V2 'When I feel distressed or upset, I must do something about it immediately '.
Variable Labels DTS16r_V2 'When I feel distressed or upset, I cannot help but concentrate on how bad the distress actually feels '.

*Tolerance subscale. 
Compute DTS_tolerance_V2 = (DTS1r_V2 + DTS3r_V2 + DTS5r_V2)/3. 
VARIABLE LABELS DTS_tolerance_V2 'DTS Tolerance  subscale mean total'.
EXECUTE.

*Absorption subscale. 
Compute DTS_absorption_V2 = (DTS4r_V2 + DTS2r_V2 + DTS16r_V2)/3. 
VARIABLE LABELS DTS_absorption_V2 'DTS absorption subscale mean total'.
EXECUTE.

*Appraisal subscale. 
Compute DTS_appraisal_V2 = (DTS7_V2 + DTS8r_V2 + DTS10r_V2 + DTS11r_V2 + DTS12r_V2 + DTS13r_V2)/6. 
VARIABLE LABELS DTS_appraisal_V2 'DTS appraisal subscale mean total'.
EXECUTE.

*regulation subscale. 
Compute DTS_regulation_V2 = (DTS9r_V2 + DTS14r_V2 + DTS15r_V2)/3. 
VARIABLE LABELS DTS_regulation_V2 'DTS regulation subscale mean total'.
EXECUTE.

*Total score. 
Compute DTS_total_V2 = (DTS_tolerance_V2 + DTS_absorption_V2 + DTS_appraisal_V2 + DTS_regulation_V2)/4.
VARIABLE LABELS DTS_total_V2 'DTS total mean score'.
EXECUTE.

* Date and Time Wizard: Time_to_complete.
COMPUTE  Time_to_complete_V2 =ENDTIME2 - CTIME_V2.
VARIABLE LABELS Time_to_complete_V2 "finish time minus start time".
VARIABLE LEVEL Time_to_complete_V2 (SCALE).
FORMATS  Time_to_complete_V2 (TIME5).
VARIABLE WIDTH  Time_to_complete_V2 (5).
EXECUTE.

