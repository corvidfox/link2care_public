* Encoding: UTF-8.
*L2C Visit 1


DATASET ACTIVATE DataSet1.
COMPUTE mms_score = MMS_1 + MMS_2 + RECAL1 +COUNT + RECAL2 + OBJECT + PAPER + MMS_11 + MMS_10 + MMS_9 + MMS_7.
VARIABLE LABELS mms_score 'MINI Mental State Exam score when participant is unable to count backwards from 100 by 7s and  are asked to spell (world) backwards'. 
EXECUTE.

IF (Count > 0) MMS_total = MMS_Score.
IF (Count = 0) MMS_total = MMS_S.
VARIABLE LABELS MMS_total 'MINI Mental State Exam total score'. 
EXECUTE.

RECODE MMS_total (Lowest thru 17=2) (18 thru 23=1) (24 thru Highest=0) INTO MMS_severity. 
VARIABLE LABELS  MMS_severity 'What is the liklihood of cognitive impairment?'. 
VALUE LABELS MMS_severity 0 'No cognitive impairment' 1 'Mild cognitive impairment' 2 'Severe cognitive impairment'. 
EXECUTE. 

*PHQ Depression

RECODE PHQ1_V1 PHQ2_V1 PHQ3_V1 PHQ4_V1 PHQ5_V1 PHQ6_V1 PHQ7_V1 PHQ8_V1 (Lowest thru 1=0) (2 thru 
    Highest=1) INTO PHQ1_V1_dicot PHQ2_V1_dicot PHQ3_V1_dicot PHQ4_V1_dicot PHQ5_V1_dicot PHQ6_V1_dicot 
    PHQ7_V1_dicot PHQ8_V1_dicot. 
VARIABLE LABELS  
PHQ1_V1_dicot 'Little interest or pleasure in doing things dicot' 
/PHQ2_V1_dicot 'Felling down, depressed, or hopeless dicot' 
/PHQ3_V1_dicot 'Trouble falling or staying asleep, or sleeping too much dicot' 
/PHQ4_V1_dicot 'Feeling tired or having little energy dicot' 
/PHQ5_V1_dicot ' Poor appetite or overeating dicot' 
/PHQ6_V1_dicot 'Failure or have let yourself or your family down dicot' 
/PHQ7_V1_dicot ' Reading the newspaper or watching television' 
/PHQ8_V1_dicot 'Fidgety or restless dicot'. 
VALUE LABELS PHQ1_V1_dicot to PHQ8_V1_dicot
0 'Not at all and several days' 1 'More than half the days and nearly every day'.
EXECUTE.
 
COMPUTE PHQ_dep_dicot_total=PHQ1_V1_dicot + PHQ2_V1_dicot + PHQ3_V1_dicot + PHQ4_V1_dicot + 
    PHQ5_V1_dicot + PHQ6_V1_dicot + PHQ7_V1_dicot + PHQ8_V1_dicot. 
VARIABLE LABELS PHQ_dep_dicot_total 'PHQ depression dichotomized total'.
EXECUTE.

IF (PHQ1_V1_dicot = 1 or PHQ2_V1_dicot = 1) PHQsymp_V1 = 1.
IF (PHQ1_V1_dicot = 0 and PHQ2_V1_dicot = 0) PHQsymp_V1 = 0.
VARIABLE LABELS PHQsymp_V1 'Does PHQ1 or PHQ2 have more than half the days and nearly every day selected?'.
VALUE LABELS PHQsymp_V1 0 'No' 1 'Yes'.
EXECUTE. 

IF (PHQsymp_V1 = 1 and PHQ_dep_dicot_total > 4) PHQmdd_V1 = 1.
IF (PHQsymp_V1 = 0) PHQmdd_V1 = 0.
IF (PHQ_dep_dicot_total < 5) PHQmdd_V1 =0.
VARIABLE LABELS PHQmdd_V1 'Is there probable major depressive disorder?'.
VALUE LABELS PHQmdd_V1 0 'No' 1 'Yes'. 
EXECUTE.

*PHQ GAD-7

COMPUTE PHQGAD_V1=PHQ9_V1 + PHQ10_V1 + PHQ11_V1 + PHQ12_V1 + PHQ13_V1 + PHQ14_V1 + PHQ15_V1. 
VARIABLE LABELS PHQGAD_V1 'Sum of PHQ GAD questions'.
EXECUTE.

*Heaviness of Smoking Index for each visit + heaviness of smoking index recoded into categories.
COMPUTE hsi_BL=HSI1_V1 + HSI2_V1. 
VARIABLE LABELS hsi_BL 'HSI_BL score'. 
EXECUTE.

RECODE hsi_BL (3=1) (4=2) (5 thru Highest=3) (Lowest thru 2=0) INTO HSI_BL_cat. 
VARIABLE LABELS  HSI_BL_cat 'HSI recoded into categories'.
VALUE LABELS hsi_BL_cat 0 'very low dependence' 1 'low to moderate dependence' 2 'moderate dependence' 3 'high dependence'.
EXECUTE.

*BRFSS Inadequate Sleep.
IF (BRS2_V1>=7) BRIS2_QD_dicot=0.
IF (BRS2_V1<7) BRIS2_QD_dicot=1.
VARIABLE LABELS BRIS2_QD_dicot 'Avg. hours of sleep categorized into less than 7 hours and 7 hours or more'.
VALUE LABELS BRIS2_QD_dicot 0 '7 hours or more' 1 'less than 7 hours'.
EXECUTE.

IF (BRS4_V1=0) QD_unintent_slp=0.
IF (BRS4_V1>0) QD_unintent_slp=1.
VARIABLE LABELS QD_unintent_slp 'Unintentional sleep dichotomizied'.
VALUE LABELS QD_unintent_slp 0 'No unintentional sleeping' 1 'At least one day of intentional sleeping'. 
EXECUTE.


*Agreesion Questionnaire. 
*Physical agreesion subscale. 
COMPUTE PA = AQ1_V1 + AQ2_V1 + AQ3_V1.
VARIABLE LABELS PA 'Physical agreesion subscale'.
EXECUTE. 

*Verbal agreesion subscale. 
COMPUTE VA = AQ4_V1 + AQ5_V1 + AQ6_V1.
VARIABLE LABELS VA 'verbal agreesion subscale'.
EXECUTE. 

*anger subscale. 
COMPUTE A = AQ7_V1 + AQ8_V1 + AQ9_V1.
VARIABLE LABELS A 'anger subscale'.
EXECUTE. 

*hostility subscale. 
COMPUTE HA = AQ10_V1 + AQ11_V1 + AQ12_V1.
VARIABLE LABELS HA 'hostility subscale'.
EXECUTE. 

*Total.
COMPUTE AQ= PA + VA + A + HA.
VARIABLE LABELS AQ 'agression questionnaire total'.
EXECUTE. 

*CES-D.
RECODE CES5_V1 CES8_V1 (0=3) (1=2) (2=1) (3=0) INTO CES5_V1r CES8_V1r. 
VARIABLE LABELS  CES5_V1r 'I felt hopeful reverse scored ' /CES8_V1r 'I was happy reverse scored'. 
EXECUTE.

COMPUTE CES_V1_total = CES1_V1 + CES2_V1 + CES3_V1 + CES4_V1 + CES5_V1r + CES6_V1 + CES7_V1 + CES8_V1r + CES9_V1 + CES10_V1.
VARIABLE LABELS  CES_V1_total 'Sum CES-D_V1 1-10 (10 or greater is considered depressed)'.
EXECUTE.

IF (CES_V1_total>=10) CES_V1_total_labelled=1.
IF (CES_V1_total<10) CES_V1_total_labelled=0.
VARIABLE LABELS CES_V1_total_labelled 'Sum CES-D_V1 1-1 categorized into depressed/not depressed'.
VALUE LABELS CES_V1_total_labelled 0 'not depressed' 1 'depressed'.
EXECUTE.

*CES-D (Dichotomized); uses the reverse scoring from above for CES5 and CES8.
RECODE CES1_V1 CES2_V1 CES3_V1 CES4_V1 CES5_V1r CES6_V1  CES7_V1  CES8_V1r CES9_V1 CES10_V1 (0=0) (1=0) 
    (2=1) (3=1) INTO CES1_V1_dichot CES2_V1_dichot CES3_V1_dichot CES4_V1_dichot CES5_V1r_dichot 
    CES6_V1_dichot CES7_V1_dichot CES8_V1r_dichot CES9_V1_dichot CES10_V1_dichot.
VARIABLE LABELS CES1_V1_dichot 'CES1_V1 Dichotomized' /CES2_V1_dichot 'CES2_V1 Dichotomized' /CES3_V1_dichot 'CES3_V1 Dichotomized' /CES4_V1_dichot 'CES4_V1 Dichotomized' 
/CES5_V1r_dichot 'CES5_V1r Dichotomized' /CES6_V1_dichot 'CES6_V1 Dichotomized' /CES7_V1_dichot 'CES7_V1 Dichotomized' /CES8_V1r_dichot 'CES8r_V1 Dichotomized' /CES9_V1_dichot 'CES9_V1 Dichotomized' /CES10_V1_dichot 'CES10_V1 Dichotomized'.
EXECUTE.
 
COMPUTE CES_V1_dichot_total = CES1_V1_dichot + CES2_V1_dichot + CES3_V1_dichot + CES4_V1_dichot + CES5_V1r_dichot + CES6_V1_dichot
+ CES7_V1_dichot + CES8_V1r_dichot + CES9_V1_dichot + CES10_V1_dichot.
VARIABLE LABELS CES_V1_dichot_total 'Sum CESV1_dichot1-10 (4 or greater is considered depressed)'.

IF (CES_V1_dichot_total>=4) CES_V1_dichot_labelled=1.
IF (CES_V1_dichot_total <4) CES_V1_dichot_labelled=0.
VARIABLE LABELS CES_V1_dichot_labelled ' Sum CES_V1_dichot1-10 categorized into depressed/ not depressed'.
VALUE LABELS CES_V1_dichot_labelled 0 'not depressed' 1 'depressed'.
EXECUTE.

***** INTER/ INTRAPERSONAL RESOURCES.
RECODE IS1_V1 IS2_V1 IS7_V1 IS8_V1 IS11_V1 IS12_V1 (1=4) (2=3) (3=2) (4=1) INTO IS1_V1r 
    IS2_V1r IS7_V1r IS8_V1r IS11_V1r IS12_V1r. 
VARIABLE LABELS  IS1_V1r 'reverse trip for a day' /IS2_V1r 'reverse no one to share worries' /IS7_V1r "reverse don't often get invited" /IS8_V1r 'reverse difficult to find home sitter' 
/IS11_V1r 'reverse difficult to find good advice' /IS12_V1r 'reverse no help moving'. 
EXECUTE.

COMPUTE ISEapp_V1= IS2_V1r + IS4_V1 + IS6_V1 + IS11_V1r.
VARIABLE LABELS ISEapp_V1 'ISE appraisal'.
EXECUTE.

COMPUTE ISEbel_V1=IS1_V1r + IS5_V1 + IS7_V1r + IS9_V1.
VARIABLE LABELS ISEbel_V1 'ISE belonging'.
EXECUTE.

COMPUTE ISEtan_V1 = IS3_V1 + IS8_V1r + IS10_V1 + IS12_V1r.
VARIABLE LABELS ISEtan_V1 'ISE tangable'.
EXECUTE.


*Lubben Socail Network Scale - revised
Family Score. 
COMPUTE LSN_V1_family = LSN1_V1 + LSN2_V1 + LSN3_V1.
VARIABLE LABELS  LSN_V1_family 'Sum LSN_V1_family 0-15 (scores of less than 6 are considered to have marginal family ties)'. 
EXECUTE.

*Friends Score.
COMPUTE LSN_V1_friends =  LSN4_V1 + LSN5_V1 + LSN6_V1.  
VARIABLE LABELS  LSN_V1_friends 'Sum LSN_V1_total 0-30 ((scores of less than 6 are considered to have marginal friendship ties)'. 
EXECUTE.

*Total.
COMPUTE LSN_V1_total = LSN1_V1 + LSN2_V1 + LSN3_V1 + LSN4_V1 + LSN5_V1 + LSN6_V1.  
VARIABLE LABELS  LSN_V1_total 'Sum LSN_V1_total 0-30 (a score of 12 and lower delineates “at-risk” for social isolation and higher scores indicate more social engagement)'. 
EXECUTE.

*Detroit Day to day discrimination. 
COMPUTE DD_V1_total =  DD1_V1 + DD2_V1 + DD3_V1 + DD4_V1 + DD5_V1 + DD6_V1 + DD7_V1  + DD8_V1 + DD9_V1.
VARIABLE LABELS  DD_V1_total 'Sum DD_V1_total'.
EXECUTE. 

*Primary Care PTSD Screen. 
COMPUTE PTSD_V1_total = PTSD1_V1 + PTSD2_V1 + PTSD3_V1 + PTSD4_V1. 
VARIABLE LABELS  PTSD_V1_total 'Sum PTSD_V1_total'.
EXECUTE. 

IF (PTSD_V1_total >=3) PTSD_V1_postive = 1. 
IF (PTSD_V1_total < 3) PTSD_V1_postive = 0.

VARIABLE LABELS PTSD_V1_postive  ' Probable PTSD'. 
VALUE LABELS PTSD_v1_postive 0 'no PTSD' 1 'probable PTSD'. 
EXECUTE. 

*Self rated health.

IF (HS1_V1 = 1 or HS1_V1= 2 or HS1_V1 =3) HS1_V1_dichotomous=0.
IF (HS1_V1=4 or HS1_V1=5) HS1_V1_dichotomous=1.
VARIABLE LABELS HS1_V1_dichotomous 'Self rated health fair or poor'.
VALUE LABELS HS1_V1_dichotomous 0 'excellent to good health' 1 'fair or poor health'.
EXECUTE.

*Alcohol.
COMPUTE AlcQF_V1=AF2M_V1 + AF3TU_V1 + AF4W_V1 + AF5TH_V1 + AF6F_V1 + AF6SA_V1 + AF8SU_V1 .
VARIABLE LABELS  AlcQF_V1 'Total drinks avg week'.
IF (AF1_V1=0) alcQF_V1 =0.
EXECUTE.

IF (AF9A_V1 >= 1 or AF9B_V1 >=11 or AF9C_V1 >=21) binge_drinker_V1=1. 
IF (AF9A_V1 =0) binge_drinker_V1 = 0.
IF (AF1_V1=0) binge_drinker_V1 = 0.
VARIABLE LABELS  binge_drinker_V1 'Binge drinking in the past 30 days'.
VALUE LABELS binge_drinker_V1 0 'no binge drinking in the past 30 days' 1 'yes binge drinking in the past 30 days'.
EXECUTE. 

IF (gender = 0 and alcQF_V1 <=14) Heavy_drinker_BL = 0.
IF (gender = 0 and alcQF_V1 >14) Heavy_drinker_BL = 1.
IF (gender = 1 and alcQF_V1 <=7) Heavy_drinker_BL = 0.
IF (gender = 1 and alcQF_V1 >7) Heavy_drinker_BL = 1.
VARIABLE LABELS  Heavy_drinker_BL 'Heavy drinker = 1 if women >7 drinks per week or men > 14 drinks per week'.
VALUE LABELS Heavy_drinker_BL 0 'not a heavy drinker' 1 'heavy drinker'.
EXECUTE.

*Variable of interest.
*BMI.
COMPUTE weight_kg_V1 = WEIGHT * 0.453592.
VARIABLE LABELS weight_kg_V1 'Weight in kilograms'. 
EXECUTE.

COMPUTE height_meter_V1= HEIGHT * 0.01.
VARIABLE LABELS height_meter_V1 'Height in meters'.
EXECUTE.

COMPUTE height_meter_sq_V1= height_meter_V1 * height_meter_V1.
VARIABLE LABELS height_meter_sq_V1 'Height in meters squared'.
EXECUTE.

COMPUTE BMI_V1= weight_kg_V1 / height_meter_sq_V1.
VARIABLE LABELS BMI_V1 'Body mass index'.
EXECUTE.

IF (bmi_V1<18.5) weight_status_V1=0.
IF (bmi_V1>=18.5 and bmi_V1<=24.99) weight_status_V1=1.
IF (bmi_V1>=25 and bmi_V1<=29.99) weight_status_V1=2.
IF (bmi_V1>=30) weight_status_V1=3.
VARIABLE LABELS weight_status_V1 'Weight categroized into underweight, normal, overweight, and obese'.
VALUE LABELS weight_status_V1 0 'underweight' 1 'normal' 2 'overweight' 3 'obese'.
EXECUTE.

IF (weight_status_V1= 0 or weight_status_V1= 1 or weight_status_V1= 2) obese_V1 =0.
IF (weight_status_V1 = 3) obese_V1=1.
VARIABLE LABELS obese_V1 'Obese'. 
VALUE LABELS obese_V1 0 'not obese' 1 'obese'.
EXECUTE.

IF (weight_status_V1= 0 or weight_status_V1= 1) ovrwt_obese_V1 =0.
IF (weight_status_V1= 2 or weight_status_V1= 3) ovrwt_obese_V1=1.
VARIABLE LABELS ovrwt_obese_V1 'Overweight or obese'.
VALUE LABELS ovrwt_obese_V1 0 'not overweight or obese' 1 'overweight or obese'.
EXECUTE.

*current period of homelessness.
AUTORECODE VARIABLES=BH4V1 
  /INTO current_months_homeless
  /PRINT.

*Ratio of close friends who smoke.
*Excludes cases where close friends = 0.
IF  (T38_v1 > 0) friends_smoke_V1=T39_V1 / T38_V1.
VARIABLE LABELS  friends_smoke_V1 'Ratio of close friends who smoke for baseline'.
EXECUTE.

*Spouse who smokes.
IF (T34_V1=1 and T35_V1=1) spouse_smoke =1.
IF (T34_V1=1 and T35_V1=0) spouse_smoke=0.
VARIABLE LABELS spouse_smoke 'if a participant has a spouse that smokes'. 
VALUE LABELS spouse_smoke 0 'participant does not have spouse who smokes' 1 'participant has spouse who smokes'.
EXECUTE. 

*history of Mental illnesses.
IF (S19_V1 = 1 or S20_V1 = 1 or S21_V1=1 or S22_V1=1 or S23_V1=1) Mental_Health_dx = 1.
IF (S19_V1 = 0 and S20_V1 = 0 and S21_V1=0 and S22_V1=0 and S23_V1=0) Mental_Health_dx = 0.
VARIABLE LABELS Mental_Health_dx 'If history of depression, anxiety, ptsd, bipolar, or schizo present'.
VALUE LABELS mental_health_dx 0 'has no history of mental illness' 1 'has a history of at least one mental illness'.
EXECUTE. 

*Pain.
RECODE S40_V1 (Lowest thru 2=0) (3 thru Highest=1) INTO pain.
VARIABLE LABELS  pain 'Pain level in last 4 weeks categorized into none-mild and mod-severe'.
VALUE LABELS pain 0 'none to mild pain' 1 'moderate or severe pain'.
EXECUTE.

*history of Substance abuse.
IF (S30_V1A = 1 or S30_V1B = 1 or S30_V1C = 1 or S30_V1D = 1 or S30_V1E = 1 or S30_V1F = 1 or S30_V1G= 1) Substance_abuse_hs = 1.
IF (S30_V1A = 0 and S30_V1B = 0 and S30_V1C = 0 and S30_V1D = 0 and S30_V1E = 0 and S30_V1F = 0 and S30_V1G= 0) Substance_abuse_hs = 0.
VARIABLE LABELS Substance_abuse_hs 'If history of alcohol, cannabis, cocaine, opiate, amphetamine, sedative, hypnotic, anxiolytic or other abuse present'.
IF (S29_V1 =0) Substance_abuse_hs = 0.
VALUE LABELS Substance_abuse_hs 0 'has no history of substance abuse' 1 'has a history of at least one substance abuse disorder '.
EXECUTE. 

*has used illicit drugs/prescription drugs in the past 30 days.
IF (S32_V1B = 1 or S32_V1C = 1 or S32_V1D = 1 or S32_V1E = 1 or S32_V1F = 1 or S32_V1G= 1 or S32_V1H= 1) Substance_use_30d= 1.
IF (S32_V1B = 0 and S32_V1C = 0 and S32_V1D = 0 and S32_V1E = 0 and S32_V1F = 0 and S32_V1G= 0 and S32_V1H= 0) Substance_use_30d = 0.
VARIABLE LABELS Substance_use_30d  'If used cannabis, cocaine, opiate, amphetamine, sedative, hypnotic, anxiolytic, K2, or other substance'.
VALUE LABELS Substance_use_30d  0 'has not used ' 1 'has used cannabis, cocaine, opiate, amphetamine, sedative, hypnotic, anxiolytic, K2, or other substance '.
EXECUTE. 

*Any Health insurance.
IF (DEM7V1A=1 or DEM7V1B=1 or DEM7V1C=1 or DEM7V1D=1) Any_health_insurance=1.
IF (DEM7V1A=0 AND DEM7V1B=0 AND DEM7V1C=0 AND DEM7V1D=0) Any_health_insurance=0.
IF (DEM7V1E=1) Any_health_insurance=0.
VARIABLE LABELS Any_health_insurance 'Does the participant have health insurance?'.
VALUE LABELS any_health_insurance 0 'no insurance' 1 'some form of insurance'.
EXECUTE.

* Date and Time Wizard: Time_to_complete.
COMPUTE  Time_to_complete_V1 =ENDTIME1 - CTIME_V1.
VARIABLE LABELS Time_to_complete_V1 "finish time minus start time".
VARIABLE LEVEL Time_to_complete_V1 (SCALE).
FORMATS  Time_to_complete_V1 (TIME5).
VARIABLE WIDTH  Time_to_complete_V1 (5).
EXECUTE.


*Number of cigarettes in the last 24 hours.
*Tobacco History Questionnaire. 
do if (T5_V1 = 0).
compute T5_V1val = 0.
else if (T5_V1 = 1).
compute T5_V1val = T5A1_V1.
else if (T5_V1 = 2).
compute T5_V1val = T5A2_V1.
else if (T5_V1 = 3).
compute T5_V1val = T5A3_V1.
else if (T5_V1 = 4).
compute T5_V1val = T5A4_V1.
else if (T5_V1 = 5).
compute T5_V1val = T5A5_V1.
else if (T5_V1 = 6).
compute T5_V1val = T5A6_V1.
end if.
VARIABLE LABELS T5_V1val 'exact number of cigarettes smoked in the last 24 hours'.
EXECUTE.

*Number of cigarettes usually smoked in a day.
*Tobacco History Questionnaire. 
do if (T6_V1 = 0).
compute T6_V1val = 0.
else if (T6_V1 = 1).
compute T6_V1val = T6A1_V1.
else if (T6_V1 = 2).
compute T6_V1val = T6A2_V1.
else if (T6_V1 = 3).
compute T6_V1val = T6A3_V1.
else if (T6_V1 = 4).
compute T6_V1val = T6A4_V1.
else if (T6_V1 = 5).
compute T6_V1val = T6A5_V1.
else if (T6_V1 = 6).
compute T6_V1val = T6A6_V1.
end if.
VARIABLE LABELS T6_V1val 'exact number of cigarettes smoked usually smoked in a day'.
EXECUTE.

COMMENT BOOKMARK;LINE_NUM=1;ID=1.
