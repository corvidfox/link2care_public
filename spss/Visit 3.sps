* Encoding: UTF-8.
*Visit 3*


*PHQ Depression

RECODE PHQ1_V3 PHQ2_V3 PHQ3_V3 PHQ4_V3 PHQ5_V3  PHQ6_V3 PHQ7_V3 PHQ8_V3  (Lowest thru 1=0) (2 thru 
    Highest=1) INTO PHQ1_V3_dicot PHQ2_V3_dicot PHQ3_V3_dicot PHQ4_V3_dicot PHQ5_V3_dicot PHQ6_V3_dicot 
    PHQ7_V3_dicot PHQ8_V3_dicot. 
VARIABLE LABELS 
PHQ1_V3_dicot 'Little interest or pleasure in doing things dicot' 
/PHQ2_V3_dicot 'Felling down, depressed, or hopeless dicot' 
/PHQ3_V3_dicot 'Trouble falling or staying asleep, or sleeping too much dicot' 
/PHQ4_V3_dicot 'Feeling tired or having little energy dicot' 
/PHQ5_V3_dicot ' Poor appetite or overeating dicot' 
/PHQ6_V3_dicot 'Failure or have let yourself or your family down dicot' 
/PHQ7_V3_dicot ' Reading the newspaper or watching television' 
/PHQ8_V3_dicot 'Fidgety or restless dicot'. 
VALUE LABELS PHQ1_V3_dicot to PHQ8_V3_dicot
0 'Not at all and several days' 1 'More than half the days and nearly every day'.
EXECUTE.
 
COMPUTE PHQ_dep_dicot_total_V3 =PHQ1_V3_dicot + PHQ2_V3_dicot + PHQ3_V3_dicot + PHQ4_V3_dicot + 
    PHQ5_V3_dicot + PHQ6_V3_dicot + PHQ7_V3_dicot + PHQ8_V3_dicot. 
VARIABLE LABELS PHQ_dep_dicot_total_V3  'PHQ depression dichotomized total'.
EXECUTE.

IF (PHQ1_V3_dicot = 1 or PHQ2_V3_dicot = 1) PHQsymp_V3  = 1.
IF (PHQ1_V3_dicot = 0 and PHQ2_V3_dicot = 0) PHQsymp_V3 = 0.
VARIABLE LABELS PHQsymp_V3 'Does PHQ1 or PHQ2 have more than half the days and nearly every day selected?'.
VALUE LABELS PHQsymp_V3 0 'No' 1 'Yes'.
EXECUTE. 

IF (PHQsymp_V3 = 1 and PHQ_dep_dicot_total_V3 > 4) PHQmdd_V3  = 1.
IF (PHQsymp_V3 = 0) PHQmdd_V3 = 0.
IF (PHQ_dep_dicot_total_V3 < 5) PHQmdd_V3 =0.
VARIABLE LABELS PHQmdd_V3 'Is there probable major depressive disorder?'.
VALUE LABELS PHQmdd_V3 0 'No' 1 'Yes'. 
EXECUTE.

*PHQ GAD-7

COMPUTE PHQGAD_V3=PHQ9_V3 + PHQ10_V3 + PHQ11_V3 + PHQ12_V3 + PHQ13_V3 + PHQ14_V3 + PHQ15_V3. 
VARIABLE LABELS PHQGAD_V3 'Sum of PHQ GAD questions'.
EXECUTE.

*Self rated health.

IF (HS1_V3 = 1 or HS1_V3= 2 or HS1_V3 =3) HS1_V3_dichotomous=0.
IF (HS1_V3 =4 or HS1_V3=5) HS1_V3_dichotomous=1.
VARIABLE LABELS HS1_V3_dichotomous 'Self rated health fair or poor'.
VALUE LABELS HS1_V3_dichotomous 0 'excellent to good health' 1 'fair or poor health'.
EXECUTE.

*Heaviness of Smoking Index for each visit + heaviness of smoking index recoded into categories.
COMPUTE hsi_V3=HSI1_V3 + HSI2_V13. 
VARIABLE LABELS hsi_V3 'HSI_V3 score'. 
EXECUTE.

RECODE hsi_V3 (3=1) (4=2) (5 thru Highest=3) (Lowest thru 2=0) INTO HSI_V3_cat. 
VARIABLE LABELS  HSI_V3_cat 'HSI recoded into categories'.
VALUE LABELS hsi_V3_cat 0 'very low dependence' 1 'low to moderate dependence' 2 'moderate dependence' 3 'high dependence'.
EXECUTE.

*BRFSS Inadequate Sleep.
IF (BRS2_V3>=7) BRIS2_V3_dicot=0.
IF (BRS2_V3<7) BRIS2_V3_dicot=1.
VARIABLE LABELS BRIS2_V3_dicot 'Avg. hours of sleep categorized into less than 7 hours and 7 hours or more'.
VALUE LABELS BRIS2_V3_dicot 0 '7 hours or more' 1 'less than 7 hours'.
EXECUTE.

IF (BRS4_V3=0) unintent_slp_V3=0.
IF (BRS4_V3>0) unintent_slp_V3=1.
VARIABLE LABELS unintent_slp_V3 'Unintentional sleep dichotomizied'.
VALUE LABELS unintent_slp_V3 0 'No unintentional sleeping' 1 'At least one day of intentional sleeping'. 
EXECUTE.

*Alcohol.
COMPUTE AlcQF_V3=AF2M_V3 + AF3TU_V3 + AF4W_V3 + AF5TH_V3 + AF6F_V3 + AF6SA_V3 + AF8SU_V3 .
VARIABLE LABELS  AlcQF_V3 'Total drinks avg week'.
IF (AF1_V3=0) alcQF_V3 =0.
EXECUTE.

IF (AF9A_V3 >= 1 or AF9B_V3 >=11 or AF9C_V3 >=21) binge_drinker_V3=1. 
IF (AF9A_V3 =0) binge_drinker_V3 = 0.
IF (AF1_V3=0) binge_drinker_V3 = 0.
VARIABLE LABELS  binge_drinker_V3 'Binge drinking in the past 30 days'.
VALUE LABELS binge_drinker_V3 0 'no binge drinking in the past 30 days' 1 'yes binge drinking in the past 30 days'.
EXECUTE. 

IF (gender = 0 and alcQF_V3 <=14) Heavy_drinker_V3 = 0.
IF (gender = 0 and alcQF_V3 >14) Heavy_drinker_V3 = 1.
IF (gender = 1 and alcQF_V3 <=7) Heavy_drinker_V3 = 0.
IF (gender = 1 and alcQF_V3 >7) Heavy_drinker_V3 = 1.
VARIABLE LABELS  Heavy_drinker_V3 'Heavy drinker = 1 if women >7 drinks per week or men > 14 drinks per week'.
VALUE LABELS Heavy_drinker_V3 0 'not a heavy drinker' 1 'heavy drinker'.
EXECUTE.

*USDA Food Security Survey.
IF (FSS1_V3 = 0 OR FSS1_V3 = 1) FSSa_V3 = 1.
IF (FSS1_V3 = 2 OR FSS1_V3 = 99) FSSa_V3 = 0.
VARIABLE LABELS FSSa_V3 'Recode into yes or no'.
VALUE LABELS FSSa_V3 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS2_V3 = 0 OR FSS2_V3 = 1) FSSb_V3 = 1.
IF (FSS2_V3 = 2 OR FSS2_V3 = 99) FSSb_V3 = 0.
VARIABLE LABELS FSSb_V3 'Recode into yes or no'.
VALUE LABELS FSSb_V3 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS3_V3 = 1) FSSc_V3 = 1.
IF (FSS3_V3 = 0 OR FSS3_V3 = 9) FSSc_V3 = 0.
VARIABLE LABELS FSSc_V3 'Recode into yes or no'.
VALUE LABELS FSSc_V3 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS4_V3 = 1) FSSd_V3 = 1.
IF (FSS4_V3 = 0 OR FSS4_V3 = 9) FSSd_V3 = 0.
VARIABLE LABELS FSSd_V3 'Recode into yes or no'.
VALUE LABELS FSSd_V3 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS5_V3 = 1) FSSe_V3 = 1.
IF (FSS5_V3 = 0 OR FSS5_V3 = 9) FSSe_V3 = 0.
VARIABLE LABELS FSSe_V3 'Recode into yes or no'.
VALUE LABELS FSSe_V3 0 'no' 1 'affirmative yes'.
EXECUTE. 

IF (FSS3A_V3 = 0 OR FSS3A_V3 = 1) FSSf_V3 = 1.
IF (FSS3A_V3 = 2 OR FSS3A_V3 = 9 or FSSc_V3 = 0) FSSf_V3 = 0.
VARIABLE LABELS FSSf_V3 'Recode into yes or no'.
VALUE LABELS FSSf_V3 0 'no' 1 'affirmative yes'.
EXECUTE. 

Compute FSS_V3_total = FSSa_V3 + FSSb_V3  + FSSc_V3 + FSSd_V3 + FSSe_V3 + FSSf_V3. 
VARIABLE LABELS FSS_V3_total 'Sum of FSSa_v3 - FSSf_v3'.
EXECUTE. 

IF (FSS_V3_total <=1) FSS_V3_score = 1.
IF (FSS_V3_total = 2) FSS_V3_score = 2.
IF (FSS_V3_total = 3) FSS_V3_score = 2.
IF (FSS_V3_total = 4) FSS_V3_score = 2.
IF (FSS_V3_total >=5) FSS_V3_score = 3.
VARIABLE LABELS FSS_V3_score 'Food security status'.
VALUE LABELS FSS_v3_score 1 'high or marginal food security' 2 'low food security' 3 'very low food security'.
EXECUTE. 

IF (FSS_V3_total <=1) FSS_V3_score_dichotomous= 1.
IF (FSS_V3_total >=2) FSS_V3_score_dichotomous = 2.
VARIABLE LABELS FSS_V3_score_dichotomous 'Food secure or food insecure'. 
VALUE LABELS FSS_V3_score_dichotomous 1 'food secure' 2 'food insecure'.
EXECUTE. 

*Detroit Day to day discrimination. 
COMPUTE DD_V3_total =  DD1_V3 + DD2_V3 + DD3_V3 + DD4_V3 + DD5_V3 + DD6_V3 + DD7_V3  + DD8_V3 + DD9_V3.
VARIABLE LABELS  DD_V3_total 'Sum DD_V3_total'.
EXECUTE. 

*Uban life stress scale. 
Compute uls_V3_total = ULS1_V3 + ULS2_V3 + ULS3_V3 + ULS4_V3 + ULS5_V3 + ULS6_V3 + ULS7_V3 + ULS8_V3 + 
ULS9_V3 + ULS10_V3 + ULS11_V3 + ULS12_V3 + ULS13_V3 + ULS14_V3 + ULS15_V3 + ULS16_V3 + ULS17_V3 + ULS18_V3 + ULS19_V3 + 
ULS20_V3 + ULS21_V3. 
VARIABLE LABELS uls_V3_total 'urban life stress total score'.
EXECUTE.

*Perceived Stress Scale.
RECODE PS2_V3 (0=4) (1=3) (2=2) (3=1) (4=0) INTO PS2r_V3.
VARIABLE LABELS  PS2r_V3 'Perceived Stress Scale Item 2 Reverse Code'.
EXECUTE.

RECODE PS3_V3 (0=4) (1=3) (2=2) (3=1) (4=0) INTO PS3r_V3.
VARIABLE LABELS  PS3r_V3 'Perceived Stress Scale Item 3 Reverse Code'.
EXECUTE.

COMPUTE PS_V3_total=PS1_V3 + PS2r_V3 + PS3r_V3 + PS4_V3.
VARIABLE LABELS PS_V3_total 'Perceived Stress Scale total score'.
EXECUTE.

*Agreesion Questionnaire. 
*Physical agreesion subscale. 
COMPUTE PA_V3 = AQ1_V3 + AQ2_V3 + AQ3_V3.
VARIABLE LABELS PA_V3 'Physical agreesion subscale'.
EXECUTE. 

*Verbal agreesion subscale. 
COMPUTE VA_V3 = AQ4_V3 + AQ5_V3 + AQ6_V3.
VARIABLE LABELS VA_V3 'verbal agreesion subscale'.
EXECUTE. 

*anger subscale. 
COMPUTE A_V3 = AQ7_V3 + AQ8_V3 + AQ9_V3.
VARIABLE LABELS A_V3 'anger subscale'.
EXECUTE. 

*hostility subscale. 
COMPUTE HA_V3 = AQ10_V3 + AQ11_V3 + AQ12_V3.
VARIABLE LABELS HA_V3 'hostility subscale'.
EXECUTE. 

*Total.
COMPUTE AQ_V3= PA_V3 + VA_V3 + A_V3 + HA_V3.
VARIABLE LABELS AQ_V3 'agression questionnaire total'.
EXECUTE. 

*CES-D.
RECODE CES5_V3 CES8_V3 (0=3) (1=2) (2=1) (3=0) INTO CES5_V3r CES8_V3r. 
VARIABLE LABELS  CES5_V3r 'I felt hopeful reverse scored ' /CES8_V3r 'I was happy reverse scored'. 
EXECUTE.

COMPUTE CES_V3_total = CES1_V3 + CES2_V3 + CES3_V3 + CES4_V3 + CES5_V3r + CES6_V3 + CES7_V3 + CES8_V3r + CES9_V3 + CES10_V3.
VARIABLE LABELS  CES_V3_total 'Sum CES-D_V3 1-10 (10 or greater is considered depressed)'.
EXECUTE.

IF (CES_V3_total>=10) CES_V3_total_labelled=1.
IF (CES_V3_total<10) CES_V3_total_labelled=0.
VARIABLE LABELS CES_V3_total_labelled 'Sum CES-D_V3 1-1 categorized into depressed/not depressed'.
VALUE LABELS CES_V3_total_labelled 0 'not depressed' 1 'depressed'.
EXECUTE.

*CES-D (Dichotomized); uses the reverse scoring from above for CES5 and CES8.
RECODE CES1_V3 CES2_V3 CES3_V3 CES4_V3 CES5_V3r CES6_V3  CES7_V3  CES8_V3r CES9_V3 CES10_V3 (0=0) (1=0) 
    (2=1) (3=1) INTO CES1_V3_dichot CES2_V3_dichot CES3_V3_dichot CES4_V3_dichot CES5_V3r_dichot 
    CES6_V3_dichot CES7_V3_dichot CES8_V3r_dichot CES9_V3_dichot CES10_V3_dichot.
VARIABLE LABELS CES1_V3_dichot 'CES1_V3 Dichotomized' /CES2_V3_dichot 'CES2_V3 Dichotomized' /CES3_V3_dichot 'CES3_V3 Dichotomized' /CES4_V3_dichot 'CES4_V3 Dichotomized' 
/CES5_V3r_dichot 'CES5_V3r Dichotomized' /CES6_V3_dichot 'CES6_V3 Dichotomized' /CES7_V3_dichot 'CES7_V3 Dichotomized' /CES8_V3r_dichot 'CES8r_V3 Dichotomized' /CES9_V3_dichot 'CES9_V3 Dichotomized' /CES10_V3_dichot 'CES10_V3 Dichotomized'.
EXECUTE.
 
COMPUTE CES_V3_dichot_total = CES1_V3_dichot + CES2_V3_dichot + CES3_V3_dichot + CES4_V3_dichot + CES5_V3r_dichot + CES6_V3_dichot
+ CES7_V3_dichot + CES8_V3r_dichot + CES9_V3_dichot + CES10_V3_dichot.
VARIABLE LABELS CES_V3_dichot_total 'Sum CES_V3_dichot1-10 (4 or greater is considered depressed)'.

IF (CES_V3_dichot_total>=4) CES_V3_dichot_labelled=1.
IF (CES_V3_dichot_total <4) CES_V3_dichot_labelled=0.
VARIABLE LABELS CES_V3_dichot_labelled ' Sum CES_V3_dichot1-10 categorized into depressed/ not depressed'.
VALUE LABELS CES_V3_dichot_labelled 0 'not depressed' 1 'depressed'.
EXECUTE.

***** INTER/ INTRAPERSONAL RESOURCES.
RECODE IS1_V3 IS2_V3 IS7_V3 IS8_V3 IS11_V3 IS12_V3 (1=4) (2=3) (3=2) (4=1) INTO IS1_V3r 
    IS2_V3r IS7_V3r IS8_V3r IS11_V3r IS12_V3r. 
VARIABLE LABELS  IS1_V3r 'reverse trip for a day' /IS2_V3r 'reverse no one to share worries' /IS7_V3r "reverse don't often get invited" /IS8_V3r 'reverse difficult to find home sitter' 
/IS11_V3r 'reverse difficult to find good advice' /IS12_V3r 'reverse no help moving'. 
EXECUTE.

COMPUTE ISEapp_V3= IS2_V3r + IS4_V3 + IS6_V3 + IS11_V3r.
VARIABLE LABELS ISEapp_V3 'ISE appraisal'.
EXECUTE.

COMPUTE ISEbel_V3=IS1_V3r + IS5_V3 + IS7_V3r + IS9_V3.
VARIABLE LABELS ISEbel_V3 'ISE belonging'.
EXECUTE.

COMPUTE ISEtan_V3 = IS3_V3 + IS8_V3r + IS10_V3 + IS12_V3r.
VARIABLE LABELS ISEtan_V3 'ISE tangable'.
EXECUTE.

*Lubben Socail Network Scale - revised
Family Score. 
COMPUTE LSN_V3_family = LSN1_V3 + LSN2_V3 + LSN3_V3.
VARIABLE LABELS  LSN_V3_family 'Sum LSN_V3_family 0-15 (scores of less than 6 are considered to have marginal family ties)'. 
EXECUTE.

*Friends Score.
COMPUTE LSN_V3_friends =  LSN4_V3 + LSN5_V3 + LSN6_V3.  
VARIABLE LABELS  LSN_V3_friends 'Sum LSN_V3_total 0-30 (scores of less than 6 are considered to have marginal friendship ties)'. 
EXECUTE.

*Total.
COMPUTE LSN_V3_total = LSN1_V3 + LSN2_V3 + LSN3_V3 + LSN4_V3 + LSN5_V3 + LSN6_V3.  
VARIABLE LABELS  LSN_V3_total 'Sum LSN_V3_total 0-30 (a score of 12 and lower delineates “at-risk” for social isolation and higher scores indicate more social engagement)'. 
EXECUTE.


*Variable of interest.
*BMI.
COMPUTE weight_kg_V3 = WEIGHT_3 * 0.453592.
VARIABLE LABELS weight_kg_V3 'Weight in kilograms'. 
EXECUTE.

COMPUTE height_meter_V3= HEIGHT_3 * 0.01.
VARIABLE LABELS height_meter_V3 'Height in meters'.
EXECUTE.

COMPUTE height_meter_sq_V3= height_meter_V3 * height_meter_V3.
VARIABLE LABELS height_meter_sq_V3 'Height in meters squared'.
EXECUTE.

COMPUTE BMI_V3= weight_kg_V3 / height_meter_sq_V3.
VARIABLE LABELS BMI_V3 'Body mass index'.
EXECUTE.

IF (bmi_V3<18.5) weight_status_V3=0.
IF (bmi_V3>=18.5 and bmi_V3<=24.99) weight_status_V3=1.
IF (bmi_V3>=25 and bmi_V3<=29.99) weight_status_V3=2.
IF (bmi_V3>=30) weight_status_V3=3.
VARIABLE LABELS weight_status_V3 'Weight categroized into underweight, normal, overweight, and obese'.
VALUE LABELS weight_status_V3 0 'underweight' 1 'normal' 2 'overweight' 3 'obese'.
EXECUTE.

IF (weight_status_V3= 0 or weight_status_V3= 1 or weight_status_V3= 2) obese_V3 =0.
IF (weight_status_V3 = 3) obese_V3=1.
VARIABLE LABELS obese_V3 'Obese'. 
VALUE LABELS obese_V3 0 'not obese' 1 'obese'.
EXECUTE.

IF (weight_status_V3= 0 or weight_status_V3= 1) ovrwt_obese_V3 =0.
IF (weight_status_V3= 2 or weight_status_V3= 3) ovrwt_obese_V3=1.
VARIABLE LABELS ovrwt_obese_V3 'Overweight or obese'.
VALUE LABELS ovrwt_obese_V3 0 'not overweight or obese' 1 'overweight or obese'.
EXECUTE.


*Number of cigarettes in the last 24 hours.
*Tobacco History Questionnaire. 
do if (T5_V3 = 0).
compute T5_V3val = 0.
else if (T5_V3 = 1).
compute T5_V3val = T5A3_V3.
else if (T5_V3 = 2).
compute T5_V3val = T5A2_V3.
else if (T5_V3 = 3).
compute T5_V3val = T5A3_V3.
else if (T5_V3 = 4).
compute T5_V3val = T5A4_V3.
else if (T5_V3 = 5).
compute T5_V3val = T5A5_V3.
else if (T5_V3 = 6).
compute T5_V3val = T5A6_V3.
end if.
VARIABLE LABELS T5_V3val 'exact number of cigarettes smoked in the last 24 hours'.
EXECUTE.

*Number of cigarettes usually smoked in a day.
*Tobacco History Questionnaire. 
do if (T6_V3 = 0).
compute T6_V3val = 0.
else if (T6_V3 = 1).
compute T6_V3val = T6A1_V3.
else if (T6_V3 = 2).
compute T6_V3val = T6A2_V3.
else if (T6_V3 = 3).
compute T6_V3val = T6A3_V3.
else if (T6_V3= 4).
compute T6_V3val = T6A4_V3.
else if (T6_V3 = 5).
compute T6_V3val = T6A5_V3.
else if (T6_V3 = 6).
compute T6_V3val = T6A6_V3.
end if.
VARIABLE LABELS T6_V3val 'exact number of cigarettes smoked usually smoked in a day'.
EXECUTE.

* Date and Time Wizard: Time_to_complete.
COMPUTE  Time_to_complete_V3 =ENDTIME3 - CTIME_V3.
VARIABLE LABELS Time_to_complete_V3 "finish time minus start time".
VARIABLE LEVEL Time_to_complete_V3 (SCALE).
FORMATS  Time_to_complete_V3 (TIME5).
VARIABLE WIDTH  Time_to_complete_V3 (5).
EXECUTE.


