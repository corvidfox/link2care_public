* Encoding: UTF-8.
*Visit 4*


*PHQ Depression

RECODE PHQ1_V4 PHQ2_V4 PHQ3_V4 PHQ4_V4 PHQ5_V4  PHQ6_V4 PHQ7_V4 PHQ8_V4  (Lowest thru 1=0) (2 thru 
    Highest=1) INTO PHQ1_V4_dicot PHQ2_V4_dicot PHQ3_V4_dicot PHQ4_V4_dicot PHQ5_V4_dicot PHQ6_V4_dicot 
    PHQ7_V4_dicot PHQ8_V4_dicot. 
VARIABLE LABELS 
PHQ1_V4_dicot 'Little interest or pleasure in doing things dicot' 
/PHQ2_V4_dicot 'Felling down, depressed, or hopeless dicot' 
/PHQ3_V4_dicot 'Trouble falling or staying asleep, or sleeping too much dicot' 
/PHQ4_V4_dicot 'Feeling tired or having little energy dicot' 
/PHQ5_V4_dicot ' Poor appetite or overeating dicot' 
/PHQ6_V4_dicot 'Failure or have let yourself or your family down dicot' 
/PHQ7_V4_dicot ' Reading the newspaper or watching television' 
/PHQ8_V4_dicot 'Fidgety or restless dicot'. 
VALUE LABELS PHQ1_V4_dicot to PHQ8_V4_dicot
0 'Not at all and several days' 1 'More than half the days and nearly every day'.
EXECUTE.
 
COMPUTE PHQ_dep_dicot_total_V4 =PHQ1_V4_dicot + PHQ2_V4_dicot + PHQ3_V4_dicot + PHQ4_V4_dicot + 
    PHQ5_V4_dicot + PHQ6_V4_dicot + PHQ7_V4_dicot + PHQ8_V4_dicot. 
VARIABLE LABELS PHQ_dep_dicot_total_V4  'PHQ depression dichotomized total'.
EXECUTE.

IF (PHQ1_V4_dicot = 1 or PHQ2_V4_dicot = 1) PHQsymp_V4  = 1.
IF (PHQ1_V4_dicot = 0 and PHQ2_V4_dicot = 0) PHQsymp_V4 = 0.
VARIABLE LABELS PHQsymp_V4 'Does PHQ1 or PHQ2 have more than half the days and nearly every day selected?'.
VALUE LABELS PHQsymp_V4 0 'No' 1 'Yes'.
EXECUTE. 

IF (PHQsymp_V4 = 1 and PHQ_dep_dicot_total_V4 > 4) PHQmdd_V4  = 1.
IF (PHQsymp_V4 = 0) PHQmdd_V4 = 0.
IF (PHQ_dep_dicot_total_V4 < 5) PHQmdd_V4 =0.
VARIABLE LABELS PHQmdd_V4 'Is there probable major depressive disorder?'.
VALUE LABELS PHQmdd_V4 0 'No' 1 'Yes'. 
EXECUTE.

*PHQ GAD-7

COMPUTE PHQGAD_V4=PHQ9_V4 + PHQ10_V4 + PHQ11_V4 + PHQ12_V4 + PHQ13_V4 + PHQ14_V4 + PHQ15_V4. 
VARIABLE LABELS PHQGAD_V4 'Sum of PHQ GAD questions'.
EXECUTE.

*Self rated health.

IF (HS1_V4 = 1 or HS1_V4= 2 or HS1_V4 =3) HS1_V4_dichotomous=0.
IF (HS1_V4 =4 or HS1_V4=5) HS1_V4_dichotomous=1.
VARIABLE LABELS HS1_V4_dichotomous 'Self rated health fair or poor'.
VALUE LABELS HS1_V4_dichotomous 0 'excellent to good health' 1 'fair or poor health'.
EXECUTE.

*Heaviness of Smoking Index for each visit + heaviness of smoking index recoded into categories.
COMPUTE hsi_V4=HSI1_V4 + HSI2_V14. 
VARIABLE LABELS hsi_V4 'HSI_V4 score'. 
EXECUTE.

RECODE hsi_V4 (3=1) (4=2) (5 thru Highest=3) (Lowest thru 2=0) INTO HSI_V4_cat. 
VARIABLE LABELS  HSI_V4_cat 'HSI recoded into categories'.
VALUE LABELS hsi_V4_cat 0 'very low dependence' 1 'low to moderate dependence' 2 'moderate dependence' 3 'high dependence'.
EXECUTE.

*BRFSS Inadequate Sleep.
IF (BRS2_V4>=7) BRIS2_V4_dicot=0.
IF (BRS2_V4<7) BRIS2_V4_dicot=1.
VARIABLE LABELS BRIS2_V4_dicot 'Avg. hours of sleep categorized into less than 7 hours and 7 hours or more'.
VALUE LABELS BRIS2_V4_dicot 0 '7 hours or more' 1 'less than 7 hours'.
EXECUTE.

IF (BRS4_V4=0) unintent_slp_V4=0.
IF (BRS4_V4>0) unintent_slp_V4=1.
VARIABLE LABELS unintent_slp_V4 'Unintentional sleep dichotomizied'.
VALUE LABELS unintent_slp_V4 0 'No unintentional sleeping' 1 'At least one day of intentional sleeping'. 
EXECUTE.

*Alcohol.
COMPUTE AlcQF_V4=AF2M_V4 + AF3TU_V4 + AF4W_V4 + AF5TH_V4 + AF6F_V4 + AF6SA_V4 + AF8SU_V4 .
VARIABLE LABELS  AlcQF_V4 'Total drinks avg week'.
IF (AF1_V4=0) alcQF_V4 =0.
EXECUTE.

IF (AF9A_V4 >= 1 or AF9B_V4 >=11 or AF9C_V4 >=21) binge_drinker_V4=1. 
IF (AF9A_V4 =0) binge_drinker_V4 = 0.
IF (AF1_V4=0) binge_drinker_V4 = 0.
VARIABLE LABELS  binge_drinker_V4 'Binge drinking in the past 30 days'.
VALUE LABELS binge_drinker_V4 0 'no binge drinking in the past 30 days' 1 'yes binge drinking in the past 30 days'.
EXECUTE. 

IF (gender = 0 and alcQF_V4 <=14) Heavy_drinker_V4 = 0.
IF (gender = 0 and alcQF_V4 >14) Heavy_drinker_V4 = 1.
IF (gender = 1 and alcQF_V4 <=7) Heavy_drinker_V4 = 0.
IF (gender = 1 and alcQF_V4 >7) Heavy_drinker_V4 = 1.
VARIABLE LABELS  Heavy_drinker_V4 'Heavy drinker = 1 if women >7 drinks per week or men > 14 drinks per week'.
VALUE LABELS Heavy_drinker_V4 0 'not a heavy drinker' 1 'heavy drinker'.
EXECUTE.

*USDA Food Security Survey.
IF (FSS1_V4 = 0 OR FSS1_V4 = 1) FSSa_V4 = 1.
IF (FSS1_V4 = 2 OR FSS1_V4 = 99) FSSa_V4 = 0.
VARIABLE LABELS FSSa_V4 'Recode into yes or no'.
VALUE LABELS FSSa_V4 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS2_V4 = 0 OR FSS2_V4 = 1) FSSb_V4 = 1.
IF (FSS2_V4 = 2 OR FSS2_V4 = 99) FSSb_V4 = 0.
VARIABLE LABELS FSSb_V4 'Recode into yes or no'.
VALUE LABELS FSSb_V4 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS3_V4 = 1) FSSc_V4 = 1.
IF (FSS3_V4 = 0 OR FSS3_V4 = 9) FSSc_V4 = 0.
VARIABLE LABELS FSSc_V4 'Recode into yes or no'.
VALUE LABELS FSSc_V4 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS4_V4 = 1) FSSd_V4 = 1.
IF (FSS4_V4= 0 OR FSS4_V4 = 9) FSSd_V4 = 0.
VARIABLE LABELS FSSd_V4 'Recode into yes or no'.
VALUE LABELS FSSd_V4 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS5_V4 = 1) FSSe_V4 = 1.
IF (FSS5_V4 = 0 OR FSS5_V4 = 9) FSSe_V4 = 0.
VARIABLE LABELS FSSe_V4 'Recode into yes or no'.
VALUE LABELS FSSe_V4 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS3A_V4 = 0 OR FSS3A_V4 = 1) FSSf_V4 = 1.
IF (FSS3A_V4 = 2 OR FSS3A_V4 = 9 or FSSc_V4 = 0) FSSf_V4 = 0.
VARIABLE LABELS FSSf_V4 'Recode into yes or no'.
VALUE LABELS FSSf_V4 0 'no' 1 'affirmative yes'.
EXECUTE. 

Compute FSS_V4_total = FSSa_V4 + FSSb_V4  + FSSc_V4 + FSSd_V4 + FSSe_V4 + FSSf_V4. 
VARIABLE LABELS FSS_V4_total 'Sum of FSSa_v4 - FSSf_v4'.
EXECUTE. 

IF (FSS_V4_total <=1) FSS_V4_score = 1.
IF (FSS_V4_total = 2) FSS_V4_score = 2.
IF (FSS_V4_total = 3) FSS_V4_score = 2.
IF (FSS_V4_total = 4) FSS_V4_score = 2.
IF (FSS_V4_total >=5) FSS_V4_score = 3.
VARIABLE LABELS FSS_V4_score 'Food security status'.
VALUE LABELS FSS_V4_score 1 'high or marginal food security' 2 'low food security' 3 'very low food security'.
EXECUTE. 

IF (FSS_V4_total <=1) FSS_V4_score_dichotomous= 1.
IF (FSS_V4_total >=2) FSS_V4_score_dichotomous = 2.
VARIABLE LABELS FSS_V4_score_dichotomous 'Food secure or food insecure'. 
VALUE LABELS FSS_V4_score_dichotomous 1 'food secure' 2 'food insecure'.
EXECUTE. 

* TCU CJ Client Evaluation of Self and Treatment (CJ CEST). 
*Desure for help subscale. 
COMPUTE TCU_desire_v4_total = ((CJ2_V4 + CJ3_V4 + CJ4_V4 + CJ5_V4 + CJ6_V4 +CJ7_V4)*10)/6. 
IF (CJ1_V4 = 0) TCU_desire_V4_total = 888. 
Variable labels TCU_desire_v4_total 'Sum, TCU Desire for help subscale (888 indicates they have not used drugs in past 12 months)'. 
EXECUTE. 

*Treatment needs subscale. 
COMPUTE TCU_tn_v4_total = ((CJ8_V4 + CJ9_V4 + CJ10_V4 + CJ11_V4 + CJ12_V4)*10)/5. 
Variable labels TCU_tn_v4_total 'Sum, TCU Treatment needs subscale'. 
EXECUTE. 

*Treatment Satisfaction.  
COMPUTE TCU_ts_V4_total = ((CJ13_V4 + CJ14_V4 + CJ15_V4 + CJ16_V4 + CJ17_V4 +CJ18_V4 + CJ19_V4)*10)/7. 
Variable labels TCU_ts_v4_total 'Sum, TCU treatment satisfaction subscale'. 
EXECUTE. 


*Detroit Day to day discrimination. 
COMPUTE DD_V4_total =  DD1_V4 + DD2_V4 + DD3_V4 + DD4_V4 + DD5_V4 + DD6_V4 + DD7_V4  + DD8_V4 + DD9_V4.
VARIABLE LABELS  DD_V4_total 'Sum DD_V4_total'.
EXECUTE. 

*Uban life stress scale. 
Compute uls_V4_total = ULS1_V4 + ULS2_V4 + ULS3_V4 + ULS4_V4 + ULS5_V4 + ULS6_V4 + ULS7_V4 + ULS8_V4 + 
ULS9_V4 + ULS10_V4 + ULS11_V4 + ULS12_V4 + ULS13_V4 + ULS14_V4 + ULS15_V4 + ULS16_V4 + ULS17_V4 + ULS18_V4 + ULS19_V4 + 
ULS20_V4 + ULS21_V4. 
VARIABLE LABELS uls_V4_total 'urban life stress total score'.
EXECUTE.

*Perceived Stress Scale.
RECODE PS2_V4 (0=4) (1=3) (2=2) (3=1) (4=0) INTO PS2r_V4.
VARIABLE LABELS  PS2r_V4 'Perceived Stress Scale Item 2 Reverse Code'.
EXECUTE.

RECODE PS3_V4 (0=4) (1=3) (2=2) (3=1) (4=0) INTO PS3r_V4.
VARIABLE LABELS  PS3r_V4 'Perceived Stress Scale Item 3 Reverse Code'.
EXECUTE.

COMPUTE PS_V4_total=PS1_V4 + PS2r_V4 + PS3r_V4 + PS4_V4.
VARIABLE LABELS PS_V4_total 'Perceived Stress Scale total score'.
EXECUTE.

*Agreesion Questionnaire. 
*Physical agreesion subscale. 
COMPUTE PA_V4 = AQ1_V4 + AQ2_V4 + AQ3_V4.
VARIABLE LABELS PA_V4 'Physical agreesion subscale'.
EXECUTE. 

*Verbal agreesion subscale. 
COMPUTE VA_V4 = AQ4_V4 + AQ5_V4 + AQ6_V4.
VARIABLE LABELS VA_V4 'verbal agreesion subscale'.
EXECUTE. 

*anger subscale. 
COMPUTE A_V4 = AQ7_V4+ AQ8_V4 + AQ9_V4.
VARIABLE LABELS A_V4 'anger subscale'.
EXECUTE. 

*hostility subscale. 
COMPUTE HA_V4= AQ10_V4 + AQ11_V4 + AQ12_V4.
VARIABLE LABELS HA_V4 'hostility subscale'.
EXECUTE. 

*Total.
COMPUTE AQ_V4= PA_V4 + VA_V4+ A_V4 + HA_V4.
VARIABLE LABELS AQ_V4 'agression questionnaire total'.
EXECUTE. 

*CES-D.
RECODE CES5_V4 CES8_V4 (0=3) (1=2) (2=1) (3=0) INTO CES5_V4r CES8_V4r. 
VARIABLE LABELS  CES5_V4r 'I felt hopeful reverse scored ' /CES8_V4r 'I was happy reverse scored'. 
EXECUTE.

COMPUTE CES_V4_total = CES1_V4 + CES2_V4 + CES3_V4 + CES4_V4 + CES5_V4r + CES6_V4 + CES7_V4 + CES8_V4r + CES9_V4 + CES10_V4.
VARIABLE LABELS  CES_V4_total 'Sum CES-D_V4 1-10 (10 or greater is considered depressed)'.
EXECUTE.

IF (CES_V4_total>=10) CES_V4_total_labelled=1.
IF (CES_V4_total<10) CES_V4_total_labelled=0.
VARIABLE LABELS CES_V4_total_labelled 'Sum CES-D_V4 1-1 categorized into depressed/not depressed'.
VALUE LABELS CES_V4_total_labelled 0 'not depressed' 1 'depressed'.
EXECUTE.

*CES-D (Dichotomized); uses the reverse scoring from above for CES5 and CES8.
RECODE CES1_V4 CES2_V4 CES3_V4 CES4_V4 CES5_V4r CES6_V4  CES7_V4  CES8_V4r CES9_V4 CES10_V4 (0=0) (1=0) 
    (2=1) (3=1) INTO CES1_V4_dichot CES2_V4_dichot CES3_V4_dichot CES4_V4_dichot CES5_V4r_dichot 
    CES6_V4_dichot CES7_V4_dichot CES8_V4r_dichot CES9_V4_dichot CES10_V4_dichot.
VARIABLE LABELS CES1_V4_dichot 'CES1_V4 Dichotomized' /CES2_V4_dichot 'CES2_V4 Dichotomized' /CES3_V4_dichot 'CES3_V4 Dichotomized' /CES4_V4_dichot 'CES4_V4 Dichotomized' 
/CES5_V4r_dichot 'CES5_V4r Dichotomized' /CES6_V4_dichot 'CES6_V4 Dichotomized' /CES7_V4_dichot 'CES7_V4 Dichotomized' /CES8_V4r_dichot 'CES8r_V4 Dichotomized' /CES9_V4_dichot 'CES9_V4 Dichotomized' /CES10_V4_dichot 'CES10_V4 Dichotomized'.
EXECUTE.
 
COMPUTE CES_V4_dichot_total = CES1_V4_dichot + CES2_V4_dichot + CES3_V4_dichot + CES4_V4_dichot + CES5_V4r_dichot + CES6_V4_dichot
+ CES7_V4_dichot + CES8_V4r_dichot + CES9_V4_dichot + CES10_V4_dichot.
VARIABLE LABELS CES_V4_dichot_total 'Sum CES_V4_dichot1-10 (4 or greater is considered depressed)'.

IF (CES_V4_dichot_total>=4) CES_V4_dichot_labelled=1.
IF (CES_V4_dichot_total <4) CES_V4_dichot_labelled=0.
VARIABLE LABELS CES_V4_dichot_labelled ' Sum CES_V4_dichot1-10 categorized into depressed/ not depressed'.
VALUE LABELS CES_V4_dichot_labelled 0 'not depressed' 1 'depressed'.
EXECUTE.

***** INTER/ INTRAPERSONAL RESOURCES.
RECODE IS1_V4 IS2_V4 IS7_V4 IS8_V4 IS11_V4 IS12_V4 (1=4) (2=3) (3=2) (4=1) INTO IS1_V4r 
    IS2_V4r IS7_V4r IS8_V4r IS11_V4r IS12_V4r. 
VARIABLE LABELS  IS1_V4r 'reverse trip for a day' /IS2_V4r 'reverse no one to share worries' /IS7_V4r "reverse don't often get invited" /IS8_V4r 'reverse difficult to find home sitter' 
/IS11_V4r 'reverse difficult to find good advice' /IS12_V4r 'reverse no help moving'. 
EXECUTE.

COMPUTE ISEapp_V4= IS2_V4r + IS4_V4 + IS6_V4 + IS11_V4r.
VARIABLE LABELS ISEapp_V4 'ISE appraisal'.
EXECUTE.

COMPUTE ISEbel_V4=IS1_V4r + IS5_V4 + IS7_V4r + IS9_V4.
VARIABLE LABELS ISEbel_V4 'ISE belonging'.
EXECUTE.

COMPUTE ISEtan_V4 = IS3_V4 + IS8_V4r + IS10_V4 + IS12_V4r.
VARIABLE LABELS ISEtan_V4 'ISE tangable'.
EXECUTE.

*Lubben Socail Network Scale - revised
Family Score. 
COMPUTE LSN_V4_family = LSN1_V4 + LSN2_V4 + LSN3_V4.
VARIABLE LABELS  LSN_V4_family 'Sum LSN_V4_family 0-15 (scores of less than 6 are considered to have marginal family ties)'. 
EXECUTE.

*Friends Score.
COMPUTE LSN_V4_friends =  LSN4_V4 + LSN5_V4 + LSN6_V4.  
VARIABLE LABELS  LSN_V4_friends 'Sum LSN_V4_total 0-30 (scores of less than 6 are considered to have marginal friendship ties)'. 
EXECUTE.

*Total.
COMPUTE LSN_V4_total = LSN1_V4 + LSN2_V4 + LSN3_V4 + LSN4_V4 + LSN5_V4 + LSN6_V4.  
VARIABLE LABELS  LSN_V4_total 'Sum LSN_V4_total 0-30 (a score of 12 and lower delineates “at-risk” for social isolation and higher scores indicate more social engagement)'. 
EXECUTE.

*Variable of interest.
*BMI.
COMPUTE weight_kg_V4 = WEIGHT_4 * 0.453592.
VARIABLE LABELS weight_kg_V4 'Weight in kilograms'. 
EXECUTE.

COMPUTE height_meter_V4= HEIGHT * 0.01.
VARIABLE LABELS height_meter_V4 'Height in meters'.
EXECUTE.

COMPUTE height_meter_sq_V4= height_meter_V4 * height_meter_V4.
VARIABLE LABELS height_meter_sq_V4 'Height in meters squared'.
EXECUTE.

COMPUTE BMI_V4= weight_kg_V4 / height_meter_sq_V4.
VARIABLE LABELS BMI_V4 'Body mass index'.
EXECUTE.

IF (bmi_V4<18.5) weight_status_V4=0.
IF (bmi_V4>=18.5 and bmi_V4<=24.99) weight_status_V4=1.
IF (bmi_V4>=25 and bmi_V4<=29.99) weight_status_V4=2.
IF (bmi_V4>=30) weight_status_V4=3.
VARIABLE LABELS weight_status_V4 'Weight categroized into underweight, normal, overweight, and obese'.
VALUE LABELS weight_status_V4 0 'underweight' 1 'normal' 2 'overweight' 3 'obese'.
EXECUTE.

IF (weight_status_V4= 0 or weight_status_V4= 1 or weight_status_V4= 2) obese_V4 =0.
IF (weight_status_V4 = 3) obese_V4=1.
VARIABLE LABELS obese_V4 'Obese'. 
VALUE LABELS obese_V4 0 'not obese' 1 'obese'.
EXECUTE.

IF (weight_status_V4= 0 or weight_status_V4= 1) ovrwt_obese_V4 =0.
IF (weight_status_V4= 2 or weight_status_V4= 3) ovrwt_obese_V4=1.
VARIABLE LABELS ovrwt_obese_V4 'Overweight or obese'.
VALUE LABELS ovrwt_obese_V4 0 'not overweight or obese' 1 'overweight or obese'.
EXECUTE.


*Number of cigarettes in the last 24 hours.
*Tobacco History Questionnaire. 
do if (T5_V4 = 0).
compute T5_V4val = 0.
else if (T5_V4 = 1).
compute T5_V4val = T5A3_V4.
else if (T5_V4 = 2).
compute T5_V4val = T5A2_V4.
else if (T5_V4 = 3).
compute T5_V4val = T5A3_V4.
else if (T5_V4 = 4).
compute T5_V4val = T5A4_V4.
else if (T5_V4 = 5).
compute T5_V4val = T5A5_V4.
else if (T5_V4 = 6).
compute T5_V4val = T5A6_V4.
end if.
VARIABLE LABELS T5_V4val 'exact number of cigarettes smoked in the last 24 hours'.
EXECUTE.

*Number of cigarettes usually smoked in a day.
*Tobacco History Questionnaire. 
do if (T6_V4 = 0).
compute T6_V4val = 0.
else if (T6_V4 = 1).
compute T6_V4val = T6A1_V4.
else if (T6_V4 = 2).
compute T6_V4val = T6A2_V4.
else if (T6_V4 = 3).
compute T6_V4val = T6A3_V4.
else if (T6_V4= 4).
compute T6_V4val = T6A4_V4.
else if (T6_V4 = 5).
compute T6_V4val = T6A5_V4.
else if (T6_V4 = 6).
compute T6_V4val = T6A6_V4.
end if.
VARIABLE LABELS T6_V4val 'exact number of cigarettes smoked usually smoked in a day'.
EXECUTE.

* Date and Time Wizard: Time_to_complete.
COMPUTE  Time_to_complete_V4 =ENDTIME4 - CTIME_V4.
VARIABLE LABELS Time_to_complete_V4 "finish time minus start time".
VARIABLE LEVEL Time_to_complete_V4 (SCALE).
FORMATS  Time_to_complete_V4 (TIME5).
VARIABLE WIDTH  Time_to_complete_V4 (5).
EXECUTE.








