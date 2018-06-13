libname rep 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis';

**Original file was created by Cailey Fitzgerald and edited by Carlee Beth Hawkins;

**2-20-2014**
Updated analyses to re-center variables to match original report
added 95% CIs to regressions;
**3-19-2014**
Hopefully the last minor updates before publication.. recoding;
**3-27-2014**
Added a couple more exploratory analyses for the manuscript..;
**4-1-2014**
more supp analyses for paper;
**5-28-2014**
more supp analyses for paper;
**6-6-2014**
changed the way standardized coefs and CIs are calculated after recognizing error in calculation of CIs;
**8-22-2014**
additional analysis by request of reviewer in round 2 os ps;


/*****************************************************/
/**************Import and clean up explicit***********/
/*****************************************************/

*import file;
data explicit;
informat questionnaire_name $40.; 
informat question_name $40.; 
informat question_response $500.;
infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\explicit.txt' delimiter='09'x firstobs = 2;
input task_number 
question_number 
questionnaire_name $ 
question_name $ 
question_response $ 
attempt 
study_name $ 
session_id;
if question_name in ("feedback", "text", "d") then delete;
drop study_name attempt; run;

*sort, identify and delete repeat rows;
proc sort; 
by session_id questionnaire_name question_name; run;
 
data explicit; set explicit;
repeat=0;
if session_id = lag(session_id) and questionnaire_name = lag(questionnaire_name) and question_name = lag(question_name) then repeat=1; 

proc means; class repeat; var session_id; run;

proc sort data=explicit; 
by session_id;
data explicit; set explicit;
if repeat = 1 then delete; run;

*transpose file;
proc transpose data=explicit name=name out=explicit; 
	var question_response; by session_id; id question_name; run; 

*idetify file contents and recode character variables as numeric;
proc contents data=explicit; run;

data explicit; set explicit;

array orig (18)

birth
birthrt
lastcycle_day
lastcycle_dayrt
lastcycle_month
lastcycle_monthrt
liking
likingrt
mpassociate
mpassociatert
pregnant
pregnantrt
status
statusrt
twocycle_day
twocycle_dayrt
twocycle_month
twocycle_monthrt
;

array new (18)

brth
brthrt
lastcycled
lastcycledrt
lastcyclem
lastcyclemrt
preferB4
preferrt
mpassocB4
mpassocrt
preg
prefrt
stat
statrt
twocycled
twocycledrt
twocyclem
twocyclemrt
;

do i = 1 to 18; 
new{i} = mean(orig{i}); end;

drop name i

birth
birthrt
birthtrt
lastcycle_day
lastcycle_dayrt
lastcycle_daytrt
lastcycle_month
lastcycle_monthrt
lastcycle_monthtrt
liking
likingrt
likingtrt
mpassociate
mpassociatert
mpassociatetrt
pregnant
pregnantrt
pregnanttrt
status
statusrt
statustrt
twocycle_day
twocycle_dayrt
twocycle_daytrt
twocycle_month
twocycle_monthrt
twocycle_monthtrt;

*ensure proper variables are numeric and character - check ranges, n, and means of numeric variables;
proc means;run;
proc contents;run;

*save clean copy of dataset in external folder;
data rep.explicit; set explicit; run;


/*****************************************************/
/**************Import and clean up sessions***********/
/*****************************************************/

*import file;
data sessions;
  infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\sessions.txt' DELIMITER='09'x LRECL=2000 FIRSTOBS  =  2;
  input session_id 
	user_id 
	study_name $ 
	session_date :ANYDTDTM21. 
	session_status $ 
	creation_date :ANYDTDTM21.
	last_update_date :ANYDTDTM21.
	previous_session_id 
	previous_session_schema $
	referrer $
	study_url $
	user_agent $
	sess_date;
  informat session_date :ANYDTDTM21.;
  informat creation_date :ANYDTDTM21.;
  informat last_update_date :ANYDTDTM21.; 
  drop study_name;


  *examine contents;
proc contents; run;

*save clean copy of dataset in external folder;
data rep.sessions; set sessions; run;

proc means data=rep.sessions; run;

/*****************************************************/
/**************Import and clean up demo***************/
/*****************************************************/

*import file;
data demo;
  informat characteristic $20.; 
  informat value $30.;
  infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\demographics.txt' delimiter='09'x firstobs = 2;
  input characteristic $ 
	value $ 
	user_id 
	study_name $;
  drop study_name;
  proc contents; run;

*sort and transpose data;
proc sort data=demo;
by user_id;

proc transpose data=demo name=name out=demo;
by user_id; var value; id characteristic; run;

*code demo data;
data demo; set demo; 

*recoding these variables into variables with numerical responses;
format edu bmonth socclass fluency race faminc racecen ethniccen politics relID 2.;
	edu = education; 
	bmonth = birthmonth; 
	socclass = class; 
	fluency = engfluency; 
	race = ethnicity;
  	faminc = income; 
	politics = politicalID; 
	relID = religionID;
  	racecen = raceomb; 
	ethniccen = ethnicityomb; 

*recoding these variables separately;
  format byear 4.; 
	byear = birthyear;
  format gender $1.; 
	gender = sex;
  format citizen resdnce $2.; 
	citizen = citizenship; 
	resdnce = residence;
  format zip work $9.; 
	zip = trim(zipcode); 
	work = trim(occupation);

*drop the old variable names;
drop name birthyear birthmonth class citizenship education engfluency ethnicity 
       income occupation politicalID religionID residence sex zipcode
       raceomb ethnicityomb; run;
*leave religion unchanged because it is character;

*check descriptives for coding errors;
proc means; run;
proc contents; run;

*save clean copy of dataset in external folder;
data rep.demo; set demo; run;


/*****************************************************/
/*********Import and clean up sessionTasks************/
/*****************************************************/

*import file;
DATA sessiontasks;
INFORMAT Study_Name $24.;		
INFORMAT Session_Last_Update_Date $21.;	
INFORMAT Session_Creation_Date $21.;
INFORMAT Task_ID $40.; 			
INFORMAT Task_Creation_Date $21.; 		
INFORMAT Session_Date $21.; 
INFORMAT Task_URL $128.; 		
INFORMAT User_Agent $16.;				
INFORMAT Session_Created_By	 $24.;
INFILE 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\sessiontasks.txt' delimiter='09'x LRECL=2000 firstobs = 2;
INPUT	Session_ID 
Task_Number 
Task_ID $ 
Task_URL $ 
User_Agent $	 
Study_URL $ 
Task_Status	$ 
Task_Sequence	 $
Task_Creation_Date $ 
User_ID 
Study_Name $ 
Session_Date $ 
Session_Status $ 
Session_Creation_Date $ 
Session_Created_By $ 
Session_Last_Update_Date $;
RUN;

*sort data, identify and delete repeat rows;
proc sort data = sessiontasks; 
by session_id task_id; 

data sessiontasks; set sessiontasks; 
repeat=0;
if session_id = lag(session_id) and task_id = lag(task_id) then repeat=1; 

proc freq; 
tables repeat; run; 

data sessiontasks; set sessiontasks;
if repeat = 1 then delete; 
drop repeat; run; 

*transpose file;
proc transpose data = sessiontasks out=sessiontasks; 
by session_id; 
id task_id; 
var task_number; run;

*view tasks and the order they appear - will use this information to code conditions and counterbalances;
proc means; run;

proc freq; run;


***will code for order of iats and then also whether demographics or reproductive questionnaire came first;

data sessiontasks; set sessiontasks; 
informat iatfirst $4.;
if att_iat_instruct = 4 then iatfirst = "att"; 
else if ster_iat_instruct = 4 then iatfirst = "ster"; 

data sessiontasks; set sessiontasks; 
informat consented 1.;
consented = 0;
if realstart = 2 then consented = 1; 

data sessiontasks; set sessiontasks; 
informat debriefed 1.;
debriefed = 0;
if debrief = 10 then debriefed = 1; 

proc freq data=sessiontasks; table iatfirst consented debriefed; run;

*keep important variables, save clean copy of dataset in external folder;

data rep.sessiontasks; set sessiontasks;
keep session_id consented debriefed iatfirst; run;


/*****************************************************/
/*********Attitude IAT********************************/
/*****************************************************/

*import file;
data iat;
  informat block_pairing_definition $50.;
  informat study_name $30.;
  informat task_name $25.;
  informat trial_name $15.;
  informat trial_response $15.; 
  infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\iat.txt' delimiter='09'x firstobs = 2;
  input block_number 
block_name $ 
block_trial_count 
block_pairing_definition $ 
study_name $ 
task_number 
task_name $ 
trial_number 
trial_name $ 
trial_response $ 
trial_latency 
trial_error 
session_id;
  drop study_name;  

*view contents; 
proc contents; run;

*delete practice blocks on IAT, recode trialerror variable for IAT algorithm, only keep necessary variables;
data temp; set iat; 
if block_name in ('BLOCK0', 'BLOCK1', 'BLOCK4') then delete;

if trial_error = 0 then trialerror = 0;
else if trial_error = 1 then trialerror = 1;

keep trial_number 
block_name 
session_id 
block_pairing_definition 
trial_latency 
trialerror 
task_name; run;

*sort data;
proc sort data=temp; 
by session_id task_name block_name trial_number; run;

*identify and delete repeat rows;
data temp; set temp;
repeat = 0;
if session_id = lag(session_id) 
and task_name= lag(task_name) 
and block_name = lag(block_name) 
and trial_number = lag(trial_number) 
then repeat=1; run; 

proc sort; 
by session_id; run; 

proc freq; 
tables repeat; run; 

data temp; set temp; 
if repeat = 1 then delete;
drop repeat; run; 

proc freq; table task_name; run;
data rep.temp; set temp; run;

*ATTITUDE IAT Script;

data att_temp ; set temp;
keep=0;
if task_name in ('blackwhite_gba', 'blackwhite_gbb') then keep=1;
run;
data att_temp; set att_temp; if keep=0 then delete;

proc freq data=att_temp; table task_name; run;

*identify block pairings in different IAT versions and recode them from PI code to algorithm code;
data att_reorder; set att_temp;
if task_name in ('blackwhite_gbb') then do;
	if block_name in ('BLOCK2') then BLOCK = 'B3';
	else if block_name in ('BLOCK3') then BLOCK = 'B4';
	else if block_name in ('BLOCK5') then BLOCK = 'B6';
	else if block_name in ('BLOCK6') then BLOCK = 'B7'; end; 

else if task_name in ('blackwhite_gba') then do;
	if block_name in ('BLOCK2') then BLOCK = 'B6';
	else if block_name in ('BLOCK3') then BLOCK = 'B7';
	else if block_name in ('BLOCK5') then BLOCK = 'B3';
	else if block_name in ('BLOCK6') then BLOCK = 'B4'; end; run;  

*run IAT algorithm - see IAT algorithm file for notation. This uses the SAS macro;
data rep.att_iat; set att_reorder; 
where task_name in ('blackwhite_gba', 'blackwhite_gbb'); 
drop block_name; run;

%iatCalc(rep, rep, att_iat, att_iat_clean, BLOCK, session_id, trial_latency, trialerror, 1, 2, 1); 

*create dataset in external folder with key variables;
data rep.att_iat_clean; set rep.att_iat_clean; 
keep session_id IAT IAT1 IAT2 EB3 EB4 EB6 EB7 FB3 FB4 FB6 FB7 MB3 MB4 MB6 MB7 SUBEXCL; run;

*pull up raw data file again and keep only necessary variables, sort data, identify block pairing definitions, transpose data;
data att_raw; set rep.att_iat;   
keep trial_number 
BLOCK 
block_pairing_definition 
session_id 
task_name 
trialerror 
trial_latency; run;

proc sort data=att_raw; 
by session_id task_name BLOCK trial_number; run;  

*identify and delete repeat rows;
data att_raw; set att_raw;
repeat = 0;
if session_id = lag(session_id) 
and task_name= lag(task_name) 
and BLOCK = lag(BLOCK) 
and trial_number = lag(trial_number) 
then repeat=1; run; 

proc sort; 
by session_id; run; 

proc freq; 
tables repeat; run; 

data att_raw; set att_raw; 
if repeat = 1 then delete;
drop repeat; run; 

data att_iat_pairingdef; set att_raw;
where trial_number = 1;
keep session_id BLOCK block_pairing_definition; run;

*output file into external folder with block pairing definitions;
proc transpose data=att_iat_pairingdef name=name out=rep.att_iat_pairingdef;
by session_id; 
var block_pairing_definition; 
id BLOCK; run;

*sort and merge iat_pairingdef and iat_clean and examine contents; 
proc sort data=rep.att_iat_pairingdef; 
by session_id; run; 

proc sort data=rep.att_iat_clean; 
by session_id; run; 

data rep.att_iat_combined; 
merge rep.att_iat_pairingdef rep.att_iat_clean 
(rename =(IAT = att_iat EB3 = att_EB3 EB4
= att_EB4 EB6 =att_EB6 EB7 = att_EB7 subexcl =
att_R_exclude));
by session_id;
keep session_id att_iat att_EB3 att_EB4 att_EB6 att_EB7 att_R_exclude;run;

proc contents data=rep.att_iat_combined; run;
proc means data=rep.att_iat_combined; run;




/*****************************************************/
/*********Stereotype IAT******************************/
/*****************************************************/

data ster_temp ; set temp;
keep=0;
if task_name in ('blackwhite_mpa', 'blackwhite_mpb') then keep=1;
run;
data ster_temp; set ster_temp; if keep=0 then delete;

*identify block pairings in different IAT versions and recode them from PI code to algorithm code;
data ster_reorder; set ster_temp;
if task_name in ('blackwhite_mpa') then do;
	if block_name in ('BLOCK2') then BLOCK = 'B3';
	else if block_name in ('BLOCK3') then BLOCK = 'B4';
	else if block_name in ('BLOCK5') then BLOCK = 'B6';
	else if block_name in ('BLOCK6') then BLOCK = 'B7'; end; 

else if task_name in ('blackwhite_mpb') then do;
	if block_name in ('BLOCK2') then BLOCK = 'B6';
	else if block_name in ('BLOCK3') then BLOCK = 'B7';
	else if block_name in ('BLOCK5') then BLOCK = 'B3';
	else if block_name in ('BLOCK6') then BLOCK = 'B4'; end; run;  

*run IAT algorithm - see IAT algorithm file for notation. This uses the SAS macro;
data rep.ster_iat; set ster_reorder;
where task_name in ('blackwhite_mpa', 'blackwhite_mpb'); 
drop block_name; run;

%iatCalc(rep, rep, ster_iat, ster_iat_clean, BLOCK, session_id, trial_latency, trialerror, 1, 2, 1); 

*create dataset in external folder with key variables;
data rep.ster_iat_clean; set rep.ster_iat_clean; 
keep session_id IAT IAT1 IAT2 EB3 EB4 EB6 EB7 FB3 FB4 FB6 FB7 MB3 MB4 MB6 MB7 SUBEXCL; run;

*pull up raw data file again and keep only necessary variables, sort data, identify block pairing definitions, transpose data;
data ster_raw; set rep.ster_iat;   
keep trial_number 
BLOCK 
block_pairing_definition 
session_id 
task_name 
trialerror 
trial_latency; run;

proc sort data=ster_raw; 
by session_id task_name BLOCK trial_number; run;  

*identify and delete repeat rows;
data ster_raw; set ster_raw;
repeat = 0;
if session_id = lag(session_id) 
and task_name= lag(task_name) 
and BLOCK = lag(BLOCK) 
and trial_number = lag(trial_number) 
then repeat=1; run; 

proc sort; 
by session_id; run; 

proc freq; 
tables repeat; run; 

data ster_raw; set ster_raw; 
if repeat = 1 then delete;
drop repeat; run; 

data ster_iat_pairingdef; set ster_raw;
where trial_number = 1;
keep session_id BLOCK block_pairing_definition; run;

*output file into external folder with block pairing definitions;
proc transpose data=ster_iat_pairingdef name=name out=rep.ster_iat_pairingdef;
by session_id; 
var block_pairing_definition; 
id BLOCK; run;

*sort and merge iat_pairingdef and iat_clean and examine contents; 
proc sort data=rep.ster_iat_pairingdef; 
by session_id; run; 

proc sort data=rep.ster_iat_clean; 
by session_id; run; 

data rep.ster_iat_combined; 
merge rep.ster_iat_pairingdef rep.ster_iat_clean 
(rename =(IAT = ster_iat EB3 = ster_EB3 EB4
= ster_EB4 EB6 =ster_EB6 EB7 = ster_EB7 subexcl =
ster_R_exclude));
by session_id;
keep session_id ster_iat ster_EB3 ster_EB4 ster_EB6 ster_EB7 ster_R_exclude;run;

proc contents data=rep.ster_iat_combined; run;
proc means data=rep.ster_iat_combined; run;




/*****************************************************/
/*********Sort and merge files************************/
/*****************************************************/

*sort and merge sessions and demo files by user_id;
proc sort data=rep.demo; 
by user_id; 

proc sort data=rep.sessions; 
by user_id; 


data demo_sessions; 
merge rep.demo rep.sessions;
by user_id; run;

*sort and merge demo_sessions, explicit, iat, and sessionTasks files by session_id;
proc sort data=demo_sessions; 
by session_id; 

proc sort data=rep.explicit; 
by session_id; 

proc sort data=rep.att_iat_combined; 
by session_id; 

proc sort data=rep.ster_iat_combined; 
by session_id; 

proc sort data=rep.sessiontasks; 
by session_id; 

data rep.all; 
merge demo_sessions rep.explicit rep.att_iat_combined rep.ster_iat_combined rep.sessiontasks; 
by session_id; run;

*examine contents and descriptives of each variable; 
proc contents data=rep.all; run;
proc means data=rep.all; run;


/*****************************************************/
/*********Suggested basic cleaning********************/
/*****************************************************/

*delete people who did not consent - these do not count as sessions since they never started the study - xx cases deleted;
data working; set rep.all;
if consented NE 1 then delete; run; *194;

data working; set working;
format education 1.;
if edu = 1 then education = 1; *elementary school;
else if edu = 2 then education = 2; *junior high;
else if edu = 3 then education = 3; *some high school;
else if edu = 4 then education = 4; *high school graduate;
else if edu in (5,6) then education = 5; *some college and associate's degree;
else if edu = 7 then education = 6; *bachelor's degree;
else if edu in (8,9,14) then education = 7; *some graduate school, master's degree, MBA;
else if edu in (10,11,13) then education = 8; *JD, MD, other advanced degree;
else if edu = 12 then education = 9; run; *PhD;

proc freq data=working; table edu education; run;

/*Combing race and ethnicity into one variable*/
data working; set working;
FORMAT racecomb 8.;
*Missing data;
   IF (ethniccen = . & racecen = . & race= .) THEN racecomb = .; 
*Hispanics-all;	
  	ELSE IF (ethniccen=1 | race=4) THEN racecomb = 4;
*Amer Indian/Alaskan;
	ELSE IF ((ethniccen IN (.,2,3) & racecen = 1 ) | race=1) THEN racecomb = 1;
*Asians;
	ELSE IF ((ethniccen IN(.,2,3) & racecen IN(2,3,4)) | race=2) THEN racecomb = 2;
*Blacks;
	ELSE IF ((ethniccen IN (.,2,3) & racecen = 5) | race=3) THEN racecomb = 3;
*Whites;	
	ELSE IF ((ethniccen IN (.,2,3) & racecen = 6) | race=5) THEN racecomb = 5;
*Multi(Black/White & NonHis) ;
	ELSE IF ((ethniccen IN (.,2,3) & racecen IN(7,8)) | race IN (7,8)) THEN racecomb = 7;
*Other/Unknown;
	ELSE IF ((ethniccen IN (.,2,3) & racecen = 9) | race=6) THEN racecomb = 6;
  ELSE racecomb = .; run;

proc freq data=working; table race racecen ethniccen racecomb; run;

*will need this for the replication model;
data working; set working; 
informat whiteblack 1.; 
if racecomb = 5 then whiteblack = 1; 
else if racecomb = 3 then whiteblack = -1; run;

data working; set working; 
informat whitenonwhite 1.; 
if racecomb = 5 then whitenonwhite = 1; 
else if racecomb in (1,2,3,4,6,7) then whitenonwhite = -1; run;

*computer age by subtracting birth information from the date they took the study;
data working; set working;
format birth MMDDYYN.;
if BMonth = 2 then birth = MDY(bmonth,28,byear); 
  else if BMonth IN (1, 3, 5, 7, 8, 10, 12)	then birth = MDY(bmonth,31,byear); 
  else if BMonth IN (4, 6, 9, 11) then birth = MDY(bmonth,30,byear); 
  else if BMonth = . AND BYear NE . then birth = MDY(12,31,byear); run;

data working; set working;
format age 2.0;
age=FLOOR((INTCK('month',birth,DATEPART(session_date))) / 12);
drop birth;RUN;




*basic IAT cleaning - set to missing IAT scores that algorithm marked for data that was excluded or incomplete;
data working; set working;
if att_R_exclude ne 0 then att_iat = .; 
if ster_R_exclude ne 0 then ster_iat = .; run; 

*identify people with too many total errors on the IAT and set IAT data to missing;
data working; set working;
att_TotalError = mean(att_EB3, att_EB4, att_EB6, att_EB7);
ster_TotalError = mean(ster_EB3, ster_EB4, ster_EB6, ster_EB7); run;

data working; set working; 
att_removeEB = 0; 
att_removetotal = 0; 
att_removeIAT = 0; 
if att_TotalError > .30 then att_removetotal = 1; 
if att_EB3 > .4 OR att_EB4 > .4 OR att_EB6 > .4 OR att_EB7 > .4 then att_removeEB = 1; 
if att_EB3 > .4 OR att_EB4 > .4 OR att_EB6 > .4 OR att_EB7 > .4 OR att_TotalError > .3 then att_removeIAT = 1; 
run;

data working; set working; 
ster_removeEB = 0; 
ster_removetotal = 0; 
ster_removeIAT = 0; 
if ster_TotalError > .30 then ster_removetotal = 1; 
if ster_EB3 > .4 OR ster_EB4 > .4 OR ster_EB6 > .4 OR ster_EB7 > .4 then ster_removeEB = 1; 
if ster_EB3 > .4 OR ster_EB4 > .4 OR ster_EB6 > .4 OR ster_EB7 > .4 OR ster_TotalError > .3 then ster_removeIAT = 1; 
run;

TITLE 'IAT Exclusions and Error Rates';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\IAT Exclusions and Error Rates.html';

proc freq data=working; 
table att_removeEB att_removetotal att_removeIAT; run;

proc freq data=working; 
table ster_removeEB ster_removetotal ster_removeIAT; run;

proc freq data=working;
tables att_R_exclude att_EB3 att_EB4 att_EB6 att_EB7 att_TotalError; run;

proc freq data=working;
tables ster_R_exclude ster_EB3 ster_EB4 ster_EB6 ster_EB7 ster_TotalError; run;

ODS HTML CLOSE;

data working; set working;
if att_TotalError > .30 then att_iat = .; run;

data working; set working;
if ster_TotalError > .30 then ster_iat = .; run;

*identify people with too many errors in each block on the IAT and set IAT data to missing;
data working; set working;
if att_EB3 > .40 then att_iat = .;
else if att_EB4 > .40 then att_iat = .;
else if att_EB6 > .40 then att_iat = .;
else if att_EB7 > .40 then att_iat = .;
run;
*identify people with too many errors in each block on the IAT and set IAT data to missing;
data working; set working;
if ster_EB3 > .40 then ster_iat = .;
else if ster_EB4 > .40 then ster_iat = .;
else if ster_EB6 > .40 then ster_iat = .;
else if ster_EB7 > .40 then ster_iat = .;
run;






*study specific coding;
data working; set working; 
format repstatus $15.;
format pregnow $6.;
format givenbirth $4.; 

if stat = 1 then repstatus = "fertile"; 
else if stat = 2 then repstatus = "contraceptives"; 
else if stat = 3 then repstatus = "sterile"; 
else if stat = 4 then repstatus = "unsure"; 
else if stat = 5 then repstatus = "PNTS"; 
else repstatus = "."; 

if preg = 1 then pregnow = "yes"; 
else if preg = 2 then pregnow = "no"; 
else if preg = 3 then pregnow = "unsure"; 
else if preg = 4 then pregnow = "PNTS"; 
else pregnow = "."; 

if brth = 1 then givenbirth = "yes"; 
else if brth = 2 then givenbirth = "no"; 
else if brth = 3 then givenbirth = "PNTS"; 
else givenbirth = "."; run;

proc freq data=working; tables repstatus pregnow givenbirth; run;

proc freq data=working; 
tables lastcycled lastcyclem twocycled twocyclem; run;

proc means data=working; 
var lastcycled lastcyclem twocycled twocyclem; run;

data working; set working;

format lastcycleday_other $4.; 
format lastcyclemonth_other $4.;
format twocycleday_other $4.; 
format twocyclemonth_other $4.; 

if lastcycled = 32 then lastcycleday_other = "none"; 
else if lastcycled = 33 then lastcycleday_other = "DR"; 
else if lastcycled = 34 then lastcycleday_other = "PNTS"; 

else if lastcyclem = 13 then lastcyclemonth_other = "none"; 
else if lastcyclem = 14 then lastcyclemonth_other = "DR"; 
else if lastcyclem = 15 then lastcyclemonth_other = "PNTS"; 

else if twocycled = 32 then twocycleday_other = "none"; 
else if twocycled = 33 then twocycleday_other = "DR"; 
else if twocycled = 34 then twocycleday_other = "PNTS"; 

else if twocyclem = 13 then twocyclemonth_other = "none"; 
else if twocyclem = 14 then twocyclemonth_other = "DR"; 
else if twocyclem = 15 then twocyclemonth_other = "PNTS"; run;

proc freq data=working; 
tables lastcycleday_other lastcyclemonth_other twocycleday_other twocyclemonth_other; run;

data working; set working; 
 
if lastcycled = 32 then lastcycleday = .; 
else if lastcycled = 33 then lastcycleday = .; 
else if lastcycled = 34 then lastcycleday = .; 
else lastcycleday = lastcycled; 

if lastcyclem = 13 then lastcyclemonth = .; 
else if lastcyclem = 14 then lastcyclemonth = .; 
else if lastcyclem = 15 then lastcyclemonth = .; 
else lastcyclemonth = lastcyclem; 

if twocycled = 32 then twocycleday = .; 
else if twocycled = 33 then twocycleday = .; 
else if twocycled = 34 then twocycleday = .; 
else twocycleday = twocycled; 

if twocyclem = 13 then twocyclemonth = .; 
else if twocyclem = 14 then twocyclemonth = .; 
else if twocyclem = 15 then twocyclemonth = .; 
else twocyclemonth = twocyclem; run;

proc freq data=working; 
tables lastcycleday lastcyclemonth twocycleday twocyclemonth; run;

proc means data=working; 
var lastcycleday lastcyclemonth twocycleday twocyclemonth; run;


*calculating the current day in the cycle;
proc freq data=working; 
tables sess_date lastcycleday lastcyclemonth; run;

*2012 was a leap year -- accounted for in this computation;
data working; set working;
if lastcyclemonth = 1 then lastcycle_numday = lastcycleday; 
else if lastcyclemonth = 2 then lastcycle_numday = 31+lastcycleday; 
else if lastcyclemonth = 3 then lastcycle_numday = 60+lastcycleday; 
else if lastcyclemonth = 4 then lastcycle_numday = 91+lastcycleday; 
else if lastcyclemonth = 5 then lastcycle_numday = 121+lastcycleday; 
else if lastcyclemonth = 6 then lastcycle_numday = 152+lastcycleday; 
else if lastcyclemonth = 7 then lastcycle_numday = 182+lastcycleday; 
else if lastcyclemonth = 8 then lastcycle_numday = 213+lastcycleday; 
else if lastcyclemonth = 9 then lastcycle_numday = 244+lastcycleday; 
else if lastcyclemonth = 10 then lastcycle_numday = 274+lastcycleday; 
else if lastcyclemonth = 11 then lastcycle_numday = 305+lastcycleday; 
else if lastcyclemonth = 12 then lastcycle_numday = 335+lastcycleday; run;

proc freq data=working; 
tables lastcycle_numday sess_date; run;

data working; set working; 
currentcycle_day = sess_date - lastcycle_numday; run;

proc freq data=working; 
table currentcycle_day; run;

*now for two cycles ago;
data working; set working;
if twocyclemonth = 1 then twocycle_numday = twocycleday; 
else if twocyclemonth = 2 then twocycle_numday = 31+twocycleday; 
else if twocyclemonth = 3 then twocycle_numday = 60+twocycleday; 
else if twocyclemonth = 4 then twocycle_numday = 91+twocycleday; 
else if twocyclemonth = 5 then twocycle_numday = 121+twocycleday; 
else if twocyclemonth = 6 then twocycle_numday = 152+twocycleday; 
else if twocyclemonth = 7 then twocycle_numday = 182+twocycleday; 
else if twocyclemonth = 8 then twocycle_numday = 213+twocycleday; 
else if twocyclemonth = 9 then twocycle_numday = 244+twocycleday; 
else if twocyclemonth = 10 then twocycle_numday = 274+twocycleday; 
else if twocyclemonth = 11 then twocycle_numday = 305+twocycleday; 
else if twocyclemonth = 12 then twocycle_numday = 335+twocycleday; run;

proc freq data=working; 
tables twocycle_numday; run;

data working; set working; 
cycle_length = lastcycle_numday - twocycle_numday; run;

proc freq data=working; 
tables cycle_length; run;



*now coding for conception risk based on the actuarial data and the current date in the cycle;
data working; set working; 
if currentcycle_day = 1 then risk = 0; 
else if currentcycle_day = 2 then risk = 0; 
else if currentcycle_day = 3 then risk = 0.001; 
else if currentcycle_day = 4 then risk = 0.002; 
else if currentcycle_day = 5 then risk = 0.004; 
else if currentcycle_day = 6 then risk = 0.009; 
else if currentcycle_day = 7 then risk = 0.017; 
else if currentcycle_day = 8 then risk = 0.029; 
else if currentcycle_day = 9 then risk = 0.044; 
else if currentcycle_day = 10 then risk = 0.061; 

else if currentcycle_day = 11 then risk = 0.075; 
else if currentcycle_day = 12 then risk = 0.084; 
else if currentcycle_day = 13 then risk = 0.086; 
else if currentcycle_day = 14 then risk = 0.081; 
else if currentcycle_day = 15 then risk = 0.072; 
else if currentcycle_day = 16 then risk = 0.061; 
else if currentcycle_day = 17 then risk = 0.050; 
else if currentcycle_day = 18 then risk = 0.040; 
else if currentcycle_day = 19 then risk = 0.032; 
else if currentcycle_day = 20 then risk = 0.025; 

else if currentcycle_day = 21 then risk = 0.020; 
else if currentcycle_day = 22 then risk = 0.016; 
else if currentcycle_day = 23 then risk = 0.013; 
else if currentcycle_day = 24 then risk = 0.011; 
else if currentcycle_day = 25 then risk = 0.009; 
else if currentcycle_day = 26 then risk = 0.008; 
else if currentcycle_day = 27 then risk = 0.007; 
else if currentcycle_day = 28 then risk = 0.007; 
else if currentcycle_day = 29 then risk = 0.007; 
else if currentcycle_day = 30 then risk = 0.007; 

else if currentcycle_day = 31 then risk = 0.008; 
else if currentcycle_day = 32 then risk = 0.008; 
else if currentcycle_day = 33 then risk = 0.009; 
else if currentcycle_day = 34 then risk = 0.009; 
else if currentcycle_day = 35 then risk = 0.010; 
else if currentcycle_day = 36 then risk = 0.011; 
else if currentcycle_day = 37 then risk = 0.012; 
else if currentcycle_day = 38 then risk = 0.013; 
else if currentcycle_day = 39 then risk = 0.014; 
else if currentcycle_day = 40 then risk = 0.015; run;

proc freq data=working; 
tables risk; run;

proc means data=working; 
var risk; run;

*reverse and rescoring explicit preference and stereotypes so midpoint is 0; 
data working; set working; 
preferR = 8 - preferB4; 
mpassocR = 8 - mpassocB4; run;

data working; set working; 
prefer = preferR - 4; 
mpassoc = mpassocR - 4; run;

proc corr data=working; 
var preferB4 preferR prefer mpassocB4 mpassocR mpassoc; run;

*reverse score iat;
data working; set working; 
ster_iat=0-ster_iat; run; 

*save working dataset externally and check it out;
data rep.cleaned; set working; run;

proc means data=rep.cleaned; run;
proc contents data=rep.cleaned; run;

*shorten the dataset;
data rep.short; set rep.cleaned; 
keep session_id session_status session_date 

consented debriefed iatfirst 

age citizen education racecomb racecen ethniccen gender politics relID resdnce work

att_iat ster_iat prefer preferrt mpassoc mpassocrt

repstatus pregnow givenbirth

lastcycleday_other lastcyclemonth_other twocycleday_other twocyclemonth_other
lastcycleday lastcyclemonth twocycleday twocyclemonth
sess_date lastcycle_numday twocycle_numday 
currentcycle_day cycle_length risk 
whiteblack whitenonwhite; run;

proc contents data=rep.short; run;
proc means data=rep.short; run;


TITLE 'Sample Characteristics for Full Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\Sample Characteristics for Full Sample.html';

proc freq data=rep.short;
tables gender citizen education; run;

proc freq data=rep.short;
tables racecomb racecen ethniccen; run;

proc means data=rep.short; 
var relID age politics; run;

ODS HTML CLOSE;


*creating dataset where only qualified participants are included;
data rep.short; set rep.short; 
keep2 = 0; 
if repstatus = "fertile" then keep2 = 1; run;

data rep.short; set rep.short; 
keep3 = 0;
if pregnow = "no" then keep3=1; run;

data rep.short; set rep.short; 
keep4 = 0;
if currentcycle_day < 41 AND currentcycle_day > 0 then keep4=1; run;

data rep.short; set rep.short; 
keep5 = 0; 
if cycle_length in (20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) then keep5 = 1; run;

proc freq data=rep.short; table keep2 keep3 keep4 keep5 risk; run;

data rep.qualify; set rep.short; 
if keep2 = 0 then delete; run; 

data rep.qualify; set rep.qualify; 
if keep3 = 0 then delete; run;

data rep.qualify; set rep.qualify; 
if keep4 = 0 then delete; run;

data rep.qualify; set rep.qualify; 
if keep5 = 0 then delete; run;

data rep.qualify; set rep.qualify; 
if gender NE 'f' then delete; run;

proc freq data=rep.qualify;
table risk; run;

*reverse-scoring stereotype and bias IAT scores for black participants per McDonald et al.;
data rep.qualify; set rep.qualify;

ster_iatR = .; 
att_iatR = .; 

if whiteblack = -1 then ster_iatR = 0-ster_iat; 
else if whiteblack = 1 then  ster_iatR = ster_iat; 

if whiteblack = -1 then att_iatR = 0-att_iat; 
else if whiteblack = 1 then  att_iatR = att_iat; run;

proc means data=rep.qualify; 
var ster_iat ster_iatR att_iat att_iatR; run;

proc means data=rep.qualify; 
class whiteblack; 
var ster_iat ster_iatR att_iat att_iatR; run;

proc means data=rep.qualify; 
class whitenonwhite; 
var ster_iat ster_iatR att_iat att_iatR; run;

*creating standardized outcome variable like they did in the article;
proc standard data=rep.qualify MEAN=0 STD=1 OUT=rep.zqualify;
var att_iat att_iatR ster_iat ster_iatR prefer mpassoc risk whiteblack whitenonwhite; run;

data rep.zqualify; set rep.zqualify; 
keep session_id att_iat att_iatR ster_iat ster_iatR prefer mpassoc risk whiteblack whitenonwhite; run;

proc means data=rep.zqualify; run;
proc contents data=rep.zqualify; run;

data rep.zqualify; set rep.zqualify; 
att_composite = mean(att_iat, ster_iat, prefer, mpassoc); 
att_compositeR = mean(att_iatR, ster_iatR, prefer, mpassoc); run;

proc means data=rep.zqualify; run;
proc contents data=rep.zqualify; run;

data rep.zqualify; set rep.zqualify; 
zrisk = risk; 
zatt_iat = att_iat; 
zatt_iatR = att_iatR; 
zster_iat = ster_iat; 
zster_iatR = ster_iatR; 
zprefer = prefer; 
zmpassoc = mpassoc; 
zwhiteblack = whiteblack; 
zwhitenonwhite = whitenonwhite; 
keep session_id zrisk zatt_iat zatt_iatR zster_iat zster_iatR zprefer zmpassoc att_composite att_compositeR zwhiteblack zwhitenonwhite; run;

proc sort data=rep.qualify; by session_id; 
proc sort data=rep.zqualify; by session_id; 

data rep.qualified; 
merge rep.zqualify rep.qualify; 
by session_id; run;

proc corr data=rep.qualified; 
var risk zrisk ster_iat zster_iat ster_iatR zster_iatR att_iat zatt_iat att_iatR zatt_iatR prefer zprefer mpassoc zmpassoc att_composite att_compositeR whiteblack zwhiteblack whitenonwhite zwhitenonwhite; run;

proc contents data=rep.qualified; run;
proc means data=rep.qualified; run;

data rep.qualified; set rep.qualified; 
drop keep2 keep3 keep4 keep5; run;



TITLE 'Sample Characteristics for Qualifying Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\Sample Characteristics for Qualifying Sample.html';

proc freq data=rep.qualified;
tables gender citizen education; run;

proc freq data=rep.qualified;
tables racecomb racecen ethniccen; run;

proc means data=rep.qualified; 
var relID age politics; run;

ODS HTML CLOSE;




TITLE 'Hypothesis Tests for Qualifying Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\Hypothesis Tests for Qualifying Sample.html';

TITLE 'Creating and Double-Checking Centered IVs';

proc means data=rep.qualified; 
var ster_iat ster_iatR risk; run;

data rep.qualified; set rep.qualified;
risk_cent = risk - 0.03583; 
ster_iat_cent = ster_iat - 0.25852;
ster_iatR_cent = ster_iatR - 0.2375199; run;

proc corr data=rep.qualified; 
var risk risk_cent ster_iat ster_iat_cent ster_iatR ster_iatR_cent; run;

TITLE 'Correlations';
proc corr data=rep.qualified; 
var risk att_iat att_iatR ster_iat ster_iatR prefer mpassoc att_composite; run;

TITLE 'Restricting to only White women';
data rep.white; set rep.qualified; 
if whiteblack NE 1 then delete; run;

proc corr data=rep.white; 
var risk att_iat att_iatR ster_iat ster_iatR prefer mpassoc att_composite; run;

TITLE 'Main regression on reverse-coded implicit stereotypes and bias controlling for race as Black/White';
proc ttest data=rep.qualified; 
class whiteblack; 
var att_iatR; run;

proc glm data=rep.qualified; 
model att_iatR = whiteblack risk_cent ster_iatR_cent risk_cent*ster_iatR_cent / CLPARM; run;

*create interaction terms manually because proc reg does not recognize interaction terms in the model statement - annoying;
data rep.qualified; set rep.qualified; 
sterR_risk_int = risk_cent*ster_iatR_cent; run;

proc reg data=rep.qualified; 
model att_iatR = whiteblack risk_cent ster_iatR_cent sterR_risk_int / stb; run;

ODS HTML CLOSE;



TITLE 'Follow up Tests for Qualifying Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\research site study\analysis\Follow up Tests for Qualifying Sample.html';

TITLE 'Controlling for Race - White or NonWhite';
proc ttest data=rep.qualified; 
class whitenonwhite; 
var att_iatR; run;

proc glm data=rep.qualified; 
model att_iatR = whitenonwhite risk_cent ster_iatR_cent risk_cent*ster_iatR_cent / CLPARM; run;

proc reg data=rep.qualified; 
model att_iatR = whitenonwhite risk_cent ster_iatR_cent sterR_risk_int / stb; run;

TITLE 'Restricting to only White women';
data rep.white; set rep.qualified; 
if whiteblack NE 1 then delete; run;

proc glm data=rep.white; 
model att_iatR = risk_cent ster_iatR_cent risk_cent*ster_iatR_cent / CLPARM; run;

proc reg data=rep.white; 
model att_iatR = risk_cent ster_iatR_cent sterR_risk_int / stb; run;

TITLE 'Restricting to 18-23, College Students, US Citizens';
data rep.usyoungcollege; set rep.qualified; 
keep_us = 0; 
keep_young = 0; 
keep_college = 0; 

if citizen = 'us' then keep_us = 1; 

if age in (18,19,20,21,22,23) then keep_young = 1; 

if work = '25-9999' then keep_college = 1; run;

proc freq data=rep.usyoungcollege; 
table keep_us keep_young keep_college; run;

data rep.usyoungcollege; set rep.usyoungcollege; 
if keep_us = 0 then delete; 
if keep_young = 0 then delete; 
if keep_college = 0 then delete; run; 

proc glm data=rep.usyoungcollege; 
model att_iatR = whiteblack risk_cent ster_iatR_cent risk_cent*ster_iatR_cent / CLPARM; run;

proc reg data=rep.usyoungcollege; 
model att_iatR = whiteblack risk_cent ster_iatR_cent sterR_risk_int / stb; run;

TITLE 'Unrestricted sample; No control variables';
proc glm data=rep.qualified; 
model att_iatR = risk_cent ster_iatR_cent risk_cent*ster_iatR_cent / CLPARM; run;

proc reg data=rep.qualified; 
model att_iatR = risk_cent ster_iatR_cent sterR_risk_int / stb; run;

/*Below was the original pre-registered analysis, but it does not actually appear in the final report. Please see the following addendum to the pre-registered analysis plan for why.
Addendum: Data Analysis in Response to Peer Review
During the peer review process, a reviewer alerted us to a flaw in our analysis strategy. The reviewer suggested that in McDonald et al. (2011), implicit race bias and stereotypes 
had been reverse-scored for Black participants, reflecting ingroup bias rather than racial bias. Upon further examination of the original publication, we came to agree with the 
reviewer that this was a necessary change to our analysis plan and reran the multiple regression analyses for Studies 3 and 4. The results were not substantively changed with this 
new analyses strategy, and the slight change in numbers is reflected in the final manuscript. Thus, our analyses differed slightly in the final report from the registration in response 
to the suggestions of a helpful reviewer.*/

TITLE 'Main regression controlling for race as Black/White - Bias and stereotypes NOT reverse-coded';
proc ttest data=rep.qualified; 
class whiteblack; 
var att_iat; run;

proc glm data=rep.qualified; 
model att_iat = whiteblack risk_cent ster_iat_cent risk_cent*ster_iat_cent / CLPARM; run;

*create interaction terms manually because proc reg does not recognize interaction terms in the model statement - annoying;
data rep.qualified; set rep.qualified; 
ster_risk_int = risk_cent*ster_iat_cent; run;

proc reg data=rep.qualified; 
model att_iat = whiteblack risk_cent ster_iat_cent ster_risk_int / stb; run;

ODS HTML CLOSE;





