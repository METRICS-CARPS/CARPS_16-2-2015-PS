libname bias2 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2';

**1-8-2014**
changed library names
added ethnic breakdown in a different way to sample characteristics for paper;

**2-19-2014**
calculated CIs for paper;

**4-1-2014**
more supp analyses for paper;

**5-28-2014**
more supp analyses for paper;

**6-6-2014**
changed the way standardized coefs and CIs are calculated after recognizing error in calculation of CIs;

/*****************************************************/
/**************Import and clean up explicit***********/
/*****************************************************/

*import file;
data bias2.explicit;
informat questionnaire_name $40.; 
informat question_name $40.; 
informat question_response $500.;
infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\explicit.txt' delimiter='09'x firstobs = 2;
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
 
data bias2.explicit; set bias2.explicit;
repeat=0;
if session_id = lag(session_id) and questionnaire_name = lag(questionnaire_name) and question_name = lag(question_name) then repeat=1; 

proc means; class repeat; var session_id; run;

proc sort data=bias2.explicit; 
by session_id;
data bias2.explicit; set bias2.explicit;
if repeat = 1 then delete; run;

*transpose file;
proc transpose data=bias2.explicit name=name out=bias2.explicit; 
	var question_response; by session_id; id question_name; run; 

*idetify file contents and recode character variables as numeric;
proc contents data=bias2.explicit; run;


data bias2.explicit; set bias2.explicit;

format citizen residence $2.; 
citizen = countrycit; 
residence = countryres;

format gender $1.; 
gender = sex;

format ziplong zipnow fieldofstudy work realage $9.; 
ziplong = trim(postcodelong); 
zipnow = trim(postcodenow); 
fieldofstudy = trim(major);
work = occupation; 
realage = age;

lastcycleday = mean(reprlastcycleday); 
lastcyclemonth = mean(reprlastcyclemonth); 
twocycleday = mean(reprtwocycleday); 
twocyclemonth = mean(reprtwocyclemonth); 

realage = mean(age);
education = mean(edu); 
ethnicity = mean(ethnicityomb); 
polid = mean(politicalid); 
race = mean(raceomb); 
relid = mean(religionid); 

attitudeB4 = mean(att); 
warmth_black = mean(Tblack); 
warmth_white = mean(Twhite); 

birth = mean(reprbirth); 
pregnant = mean(reprpregnant); 
status = mean(reprstatus); 

drop name IMPTASKTO 
Tblack Twhite
admission age att
bfi_a1 bfi_a2 bfi_a3 bfi_a4 bfi_a5 bfi_a6 bfi_a7 bfi_a8 bfi_a9
bfi_c1 bfi_c2 bfi_c3 bfi_c4 bfi_c5 bfi_c6 bfi_c7 bfi_c8 bfi_c9
bfi_e1 bfi_e2 bfi_e3 bfi_e4 bfi_e5 bfi_e6 bfi_e7 bfi_e8 
bfi_n1 bfi_n2 bfi_n3 bfi_n4 bfi_n5 bfi_n6 bfi_n7 bfi_n8
bfi_o1 bfi_o2 bfi_o3 bfi_o4 bfi_o5 bfi_o6 bfi_o7 bfi_o8 bfi_o9 bfi_o10
bidr_im1 bidr_im2 bidr_im3 bidr_im4 bidr_im5 bidr_im6 bidr_im7 bidr_im8 bidr_im9 bidr_im10
bidr_im11 bidr_im12 bidr_im13 bidr_im14 bidr_im15 bidr_im16 bidr_im17 bidr_im18 
bidr_sde1 bidr_sde2 bidr_sde3 bidr_sde4 bidr_sde5 bidr_sde6 bidr_sde7 bidr_sde8 bidr_sde9
bidr_sde10 bidr_sde11 bidr_sde12 bidr_sde13 bidr_sde14 bidr_sde15 bidr_sde16 bidr_sde17 bidr_sde18
bjw1 bjw2 bjw3 bjw4  bjw5 bjw6  
brs1 brs2 brs3 brs4 brs5 brs6 brs7 brs8 brs9 brs10 brs11 brs12 brs13 brs14 brs15
countrycit countryres customs edu employ ethnicityomb 
he1 he2 he3 he4 he5 he6 he7 he8 he9 he10
major nfc1 nfc2 nfc3 nfc4 nfc5 nfc6 nfc7 nfc8
nfc9 nfc10 nfc11 nfc12 nfc13 nfc14 nfc15 nfc16 nfc17 nfc18
nfcc_a1 nfcc_a2 nfcc_a3 nfcc_a4 nfcc_a5 nfcc_a6 nfcc_a7 nfcc_a8 nfcc_a9
nfcc_c1 nfcc_c2 nfcc_c3 nfcc_c4 nfcc_c5 nfcc_c6 nfcc_c7 nfcc_c8 
nfcc_d1 nfcc_d2 nfcc_d3 nfcc_d4 nfcc_d5 nfcc_d6 nfcc_d7
nfcc_o1 nfcc_o2 nfcc_o3 nfcc_o4 nfcc_o5 nfcc_o6 nfcc_o7 nfcc_o8 nfcc_o9 nfcc_o10 
nfcc_p1 nfcc_p2 nfcc_p3 nfcc_p4 nfcc_p5 nfcc_p6 nfcc_p7 nfcc_p8
num occupation pe1 pe2 pe3 pe4 pe5 pe6 pe7 pe8 pe9 pe10 pe11
pns1 pns2 pns3 pns4 pns5 pns6 pns7 pns8 pns9 pns10 pns11 pns12
politicalid postcodelong postcodenow
q4 q1a q1b q1c q1d q1e q1f q1g q1h q1i q2a q2b q2c q2d q3a q3b q3c
raceomb religionid reprbirth
reprlastcycleday reprlastcyclemonth reprpregnant reprstatus reprtwocycleday reprtwocyclemonth
rwaz01 rwaz02 rwaz03 rwaz04 rwaz05 rwaz06 rwaz07 rwaz08 rwaz09 rwaz10 rwaz11 rwaz12 rwaz13 rwaz14 rwaz15
sdo1 sdo2 sdo3 sdo4 sdo5 sdo6 sdo7 sdo8 sdo9 sdo10 sdo11 sdo12
sex sm1 sm2 sm3 sm4 sm5 sm6 sm7 sm8 sm9 sm10
sm11 sm12 sm13 sm14 sm15 sm16 sm17 sm18 taxi; run;

*ensure proper variables are numeric and character - check ranges, n, and means of numeric variables;
proc means;run;
proc contents;run;

*save clean copy of dataset in external folder;
data bias2.explicit; set bias2.explicit; run;

proc freq data=bias2.explicit; table citizen residence; run;



/*****************************************************/
/**************Import and clean up sessions***********/
/*****************************************************/

*import file;
data bias2.sessions;
  infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\sessions.txt' DELIMITER='09'x LRECL=2000 FIRSTOBS  =  2;
  input session_id 
	user_id 
	study_name $ 
	session_date :mmddyy8. 
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
  drop study_name; run;

*examine contents;
proc contents; run;

proc freq; table session_date sess_date; run;

*save clean copy of dataset in external folder;
data bias2.sessions; set bias2.sessions; run;




/*****************************************************/
/*********Import and clean up sessionTasks************/
/*****************************************************/

*import file;
DATA bias2.sessiontasks;
INFORMAT Study_Name $24.;		
INFORMAT Session_Last_Update_Date $21.;	
INFORMAT Session_Creation_Date $21.;
INFORMAT Task_ID $40.; 			
INFORMAT Task_Creation_Date $21.; 		
INFORMAT Session_Date $21.; 
INFORMAT Task_URL $128.; 		
INFORMAT User_Agent $16.;				
INFORMAT Session_Created_By	 $24.;
INFILE 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\sessionTasks.txt' delimiter='09'x LRECL=2000 firstobs = 2;
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
proc sort data = bias2.sessiontasks; 
by session_id task_id; 

data bias2.sessiontasks; set bias2.sessiontasks; 
repeat=0;
if session_id = lag(session_id) and task_id = lag(task_id) then repeat=1; 

proc freq; 
tables repeat; run; 

data bias2.sessiontasks; set bias2.sessiontasks;
if repeat = 1 then delete; 
drop repeat; run; 

*transpose file;
proc transpose data = bias2.sessiontasks out=bias2.sessiontasks; 
by session_id; 
id task_id; 
var task_number; run;

*view tasks and the order they appear - will use this information to code conditions and counterbalances;
proc means; run;

data bias2.sessiontasks; set bias2.sessiontasks;
keep = 0;
if reprod = 7 then keep = 1; run;
*keeping people who saw the reproduction questionnaire for the full sample. this technically eliminates people who saw the indtroduction page but not the questionnaire.;

****coding for consenters vs completers;
data bias2.sessiontasks; set bias2.sessiontasks;
format debriefed 1.; 
if debriefing1 in (6,7,8,9) then debriefed = 1; run;

proc freq data=bias2.sessiontasks; table debriefed keep; run;

*keep important variables, save clean copy of dataset in external folder;
data bias2.sessiontasks; set bias2.sessiontasks;
keep session_id debriefed keep; run;



/*****************************************************/
/*********Import and clean up IAT*********************/
/*****************************************************/

*import file;
data bias2.iat;
  informat block_pairing_definition $50.;
  informat study_name $30.;
  informat task_name $25.;
  informat trial_name $15.;
  informat trial_response $15.; 
  infile 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\iat.txt' delimiter='09'x firstobs = 2;
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
proc means; run;

*delete practice blocks on IAT, recode trialerror variable for IAT algorithm, only keep necessary variables;
data bias2.temp; set bias2.iat; 
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
proc sort data=bias2.temp; 
by session_id task_name block_name trial_number; run;

*identify and delete repeat rows;
data bias2.temp; set bias2.temp;
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

data bias2.temp; set bias2.temp; 
if repeat = 1 then delete;
drop repeat; run; 

proc freq; table task_name; run;

*identify block pairings in different IAT versions and recode them from PI code to algorithm code;
data bias2.reorder; set bias2.temp;
if task_name in ("demo_racea","demo_raced") then do;
	if block_name in ('BLOCK2') then BLOCK = 'B3';
	else if block_name in ('BLOCK3') then BLOCK = 'B4';
	else if block_name in ('BLOCK5') then BLOCK = 'B6';
	else if block_name in ('BLOCK6') then BLOCK = 'B7'; end; 

else if task_name in ("demo_raceb","demo_racec") then do;
	if block_name in ('BLOCK2') then BLOCK = 'B6';
	else if block_name in ('BLOCK3') then BLOCK = 'B7';
	else if block_name in ('BLOCK5') then BLOCK = 'B3';
	else if block_name in ('BLOCK6') then BLOCK = 'B4'; end; run;  

*run IAT algorithm - see IAT algorithm file for notation. This uses the SAS macro;
data bias2.iat; set bias2.reorder; 
where task_name in ("demo_racea","demo_raceb","demo_racec","demo_raced"); 
drop block_name; run;

%iatCalc(bias2, bias2, iat, iat_clean, BLOCK, session_id, trial_latency, trialerror, 1, 2, 1); 

*create dataset in external folder with key variables;
data bias2.iat_clean; set bias2.iat_clean; 
keep session_id IAT IAT1 IAT2 EB3 EB4 EB6 EB7 FB3 FB4 FB6 FB7 MB3 MB4 MB6 MB7 SUBEXCL; run;

*pull up raw data file again and keep only necessary variables, sort data, identify block pairing definitions, transpose data;
data bias2.raw; set bias2.iat;   
keep trial_number 
BLOCK 
block_pairing_definition 
session_id 
task_name 
trialerror 
trial_latency; run;

proc sort data=bias2.raw; 
by session_id BLOCK; run; 

data bias2.iat_pairingdef; set bias2.raw;
where trial_number = 1;
keep session_id BLOCK block_pairing_definition; run;

*output file into external folder with block pairing definitions;
proc transpose data=bias2.iat_pairingdef name=name out=bias2.iat_pairingdef;
by session_id; 
var block_pairing_definition; 
id BLOCK; run;

*sort and merge iat_pairingdef and iat_clean and examine contents; 
proc sort data=bias2.iat_pairingdef; 
by session_id; run; 

proc sort data=bias2.iat_clean; 
by session_id; run; 

data bias2.iat_combined; 
merge bias2.iat_pairingdef bias2.iat_clean; 
by session_id; run;

proc contents data=bias2.iat_combined; run;

proc means data=bias2.iat_combined; run;

/*****************************************************/
/*********Sort and merge files************************/
/*****************************************************/

*sort and merge demo_sessions, explicit, iat, and sessionTasks files by session_id;
proc sort data=bias2.sessions; 
by session_id; 

proc sort data=bias2.explicit; 
by session_id; 

proc sort data=bias2.iat_combined; 
by session_id; 

proc sort data=bias2.sessionTasks; 
by session_id; 

data bias2.all; 
merge bias2.sessions bias2.explicit bias2.iat_combined bias2.sessionTasks; 
by session_id; run;

*examine contents and descriptives of each variable; 
proc contents data=bias2.all; run;
proc means data=bias2.all; run;



/*****************************************************/
/*********Suggested basic cleaning********************/
/*****************************************************/

data bias2.working; set bias2.all;
format edu 1.;
if education = 1 then edu = 1; *elementary school;
else if education = 2 then edu = 2; *junior high;
else if education = 3 then edu = 3; *some high school;
else if education = 4 then edu = 4; *high school graduate;
else if education in (5,6) then edu = 5; *some college and associate's degree;
else if education = 7 then edu = 6; *bachelor's degree;
else if education in (8,9,14) then edu = 7; *some graduate school, master's degree, MBA;
else if education in (10,11,13) then edu = 8; *JD, MD, other advanced degree;
else if education = 12 then edu = 9; run; *PhD;

data bias2.working; set bias2.working; 
informat ninetyplus $3.; 
ninetyplus = '.'; 
if realage = '90+' then ninetyplus = '90+'; run;

data bias2.working; set bias2.working; 
if realage = '90+' then realage = '90'; run;

data bias2.working; set bias2.working; 
age = mean(realage); 
drop realage; run;

proc freq data=bias2.working; table race ethnicity; run;


/*Combing race and ethnicity into one variable*/
data bias2.working; set bias2.working;
FORMAT racecomb 8.;
*Missing data;
   IF (ethnicity = . & race = .) THEN racecomb = .; 
*Hispanics-all;	
  	ELSE IF (ethnicity=1) THEN racecomb = 4;
*Amer Indian/Alaskan;
	ELSE IF (ethnicity IN (.,2,3) & race = 1 ) THEN racecomb = 1;
*Asians;
	ELSE IF (ethnicity IN(.,2,3) & race IN(2,3,4)) THEN racecomb = 2;
*Blacks;
	ELSE IF (ethnicity IN (.,2,3) & race = 5) THEN racecomb = 3;
*Whites;	
	ELSE IF (ethnicity IN (.,2,3) & race = 6) THEN racecomb = 5;
*Multi(Black/White & NonHis) ;
	ELSE IF (ethnicity IN (.,2,3) & race IN(7,8)) THEN racecomb = 7;
*Other/Unknown;
	ELSE IF (ethnicity IN (.,2,3) & race = 9) THEN racecomb = 6;
  ELSE racecomb = .; run;

proc freq data=bias2.working; table race ethnicity racecomb; run;

*will need this for the replication model;
data bias2.working; set bias2.working; 
informat whiteblack 1.; 
if racecomb = 5 then whiteblack = 1; 
else if racecomb = 3 then whiteblack = -1; run;

data bias2.working; set bias2.working; 
informat whitenonwhite 1.; 
if racecomb = 5 then whitenonwhite = 1; 
else if racecomb in (1,2,3,4,6,7) then whitenonwhite = -1; run;


proc means data=bias2.working;
class keep; 
var IAT; run;


*basic IAT cleaning - set to missing IAT scores that algorithm marked for data that was excluded or incomplete;
data bias2.working; set bias2.working;
if SUBEXCL ne 0 then IAT = .; run; 

*identify people with too many total errors on the IAT and set IAT data to missing;
data bias2.working; set bias2.working;
TotalError = mean(EB3, EB4, EB6, EB7); 

data bias2.working; set bias2.working; 
removeEB = 0; 
removetotal = 0; 
removeIAT = 0; 
if TotalError > .30 then removetotal = 1; 
if EB3 > .4 OR EB4 > .4 OR EB6 > .4 OR EB7 > .4 then removeEB = 1; 
if EB3 > .4 OR EB4 > .4 OR EB6 > .4 OR EB7 > .4 OR TotalError > .3 then removeIAT = 1; 
run;

TITLE 'IAT Exclusions and Error Rates';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\IAT Exclusions and Error Rates.html';

proc freq data=bias2.working; 
table removeEB removetotal removeIAT; run;

proc freq data=bias2.working;
tables SUBEXCL EB3 EB4 EB6 EB7 TotalError; run;

ODS HTML CLOSE;

data bias2.working; set bias2.working;
if TotalError > .30 then IAT = .; run;

*identify people with too many errors in each block on the IAT and set IAT data to missing;
data bias2.working; set bias2.working;
if EB3 > .40 then IAT = .;
else if EB4 > .40 then IAT = .;
else if EB6 > .40 then IAT = .;
else if EB7 > .40 then IAT = .;
run;


*study specific coding;
data bias2.working; set bias2.working; 
format repstatus $15.;
format pregnow $6.;
format givenbirth $4.; 

if status = 1 then repstatus = "fertile"; 
else if status = 2 then repstatus = "contraceptives"; 
else if status = 3 then repstatus = "sterile"; 
else if status = 4 then repstatus = "unsure"; 
else if status = 5 then repstatus = "PNTS"; 
else repstatus = "."; 

if pregnant = 1 then pregnow = "yes"; 
else if pregnant = 2 then pregnow = "no"; 
else if pregnant = 3 then pregnow = "unsure"; 
else if pregnant = 4 then pregnow = "PNTS"; 
else pregnow = "."; 

if birth = 1 then givenbirth = "yes"; 
else if birth = 2 then givenbirth = "no"; 
else if birth = 3 then givenbirth = "PNTS"; 
else givenbirth = "."; run;

proc freq data=bias2.working; tables repstatus pregnow givenbirth; run;

proc freq data=bias2.working; 
tables lastcycleday lastcyclemonth twocycleday twocyclemonth; run;

proc means data=bias2.working; 
var lastcycleday lastcyclemonth twocycleday twocyclemonth; run;

data bias2.working; set bias2.working;

format lastcycleday_other $4.; 
format lastcyclemonth_other $4.;
format twocycleday_other $4.; 
format twocyclemonth_other $4.; 

if lastcycleday = 97 then lastcycleday_other = "none"; 
else if lastcycleday = 98 then lastcycleday_other = "DR"; 
else if lastcycleday = 99 then lastcycleday_other = "PNTS"; 

else if lastcyclemonth = 97 then lastcyclemonth_other = "none"; 
else if lastcyclemonth = 98 then lastcyclemonth_other = "DR"; 
else if lastcyclemonth = 99 then lastcyclemonth_other = "PNTS"; 

else if twocycleday = 97 then twocycleday_other = "none"; 
else if twocycleday = 98 then twocycleday_other = "DR"; 
else if twocycleday = 99 then twocycleday_other = "PNTS"; 

else if twocyclemonth = 97 then twocyclemonth_other = "none"; 
else if twocyclemonth = 98 then twocyclemonth_other = "DR"; 
else if twocyclemonth = 99 then twocyclemonth_other = "PNTS"; run;

proc freq data=bias2.working; 
tables lastcycleday_other lastcyclemonth_other twocycleday_other twocyclemonth_other; run;

data bias2.working; set bias2.working; 

if lastcycleday = 96 then lastcycle_day = .; 
else if lastcycleday = 97 then lastcycle_day = .; 
else if lastcycleday = 98 then lastcycle_day = .; 
else if lastcycleday = 99 then lastcycle_day = .; 
else lastcycle_day = lastcycleday; 

if lastcyclemonth = 96 then lastcycle_month = .; 
else if lastcyclemonth = 97 then lastcycle_month = .; 
else if lastcyclemonth = 98 then lastcycle_month = .; 
else if lastcyclemonth = 99 then lastcycle_month = .; 
else lastcycle_month = lastcyclemonth; 

if twocycleday = 96 then twocycle_day = .; 
else if twocycleday = 97 then twocycle_day = .; 
else if twocycleday = 98 then twocycle_day = .; 
else if twocycleday = 99 then twocycle_day = .; 
else twocycle_day = twocycleday; 

if twocyclemonth = 96 then twocycle_month = .; 
else if twocyclemonth = 97 then twocycle_month = .; 
else if twocyclemonth = 98 then twocycle_month = .; 
else if twocyclemonth = 99 then twocycle_month = .; 
else twocycle_month = twocyclemonth; run;

proc freq data=bias2.working; 
tables lastcycle_day lastcycle_month twocycle_day twocycle_month; run;

proc means data=bias2.working; 
var lastcycle_day lastcycle_month twocycle_day twocycle_month; run;


*calculating the current day in the cycle;
proc freq data=bias2.working; 
tables sess_date lastcycle_day lastcycle_month; run;

data bias2.working; set bias2.working;
sess_day = 304 + sess_date; run;

proc freq data=bias2.working; 
tables sess_day; run;

data bias2.working; set bias2.working;
if lastcycle_month = 1 then lastcycle_numday = lastcycle_day; 
else if lastcycle_month = 2 then lastcycle_numday = 31+lastcycle_day; 
else if lastcycle_month = 3 then lastcycle_numday = 59+lastcycle_day; 
else if lastcycle_month = 4 then lastcycle_numday = 90+lastcycle_day; 
else if lastcycle_month = 5 then lastcycle_numday = 120+lastcycle_day; 
else if lastcycle_month = 6 then lastcycle_numday = 151+lastcycle_day; 
else if lastcycle_month = 7 then lastcycle_numday = 181+lastcycle_day; 
else if lastcycle_month = 8 then lastcycle_numday = 212+lastcycle_day; 
else if lastcycle_month = 9 then lastcycle_numday = 243+lastcycle_day; 
else if lastcycle_month = 10 then lastcycle_numday = 273+lastcycle_day; 
else if lastcycle_month = 11 then lastcycle_numday = 304+lastcycle_day; 
else if lastcycle_month = 12 then lastcycle_numday = 334+lastcycle_day; run;

proc freq data=bias2.working; 
tables lastcycle_numday; run;

data bias2.working; set bias2.working; 
currentcycle_day = sess_day - lastcycle_numday; run;

proc freq data=bias2.working; 
table currentcycle_day; run;

*now for two cycles ago;
data bias2.working; set bias2.working;
if twocycle_month = 1 then twocycle_numday = twocycle_day; 
else if twocycle_month = 2 then twocycle_numday = 31+twocycle_day; 
else if twocycle_month = 3 then twocycle_numday = 59+twocycle_day; 
else if twocycle_month = 4 then twocycle_numday = 90+twocycle_day; 
else if twocycle_month = 5 then twocycle_numday = 120+twocycle_day; 
else if twocycle_month = 6 then twocycle_numday = 151+twocycle_day; 
else if twocycle_month = 7 then twocycle_numday = 181+twocycle_day; 
else if twocycle_month = 8 then twocycle_numday = 212+twocycle_day; 
else if twocycle_month = 9 then twocycle_numday = 243+twocycle_day; 
else if twocycle_month = 10 then twocycle_numday = 273+twocycle_day; 
else if twocycle_month = 11 then twocycle_numday = 304+twocycle_day; 
else if twocycle_month = 12 then twocycle_numday = 334+twocycle_day; run;

proc freq data=bias2.working; 
tables twocycle_numday; run;

data bias2.working; set bias2.working; 
cycle_length = lastcycle_numday - twocycle_numday; run;

proc freq data=bias2.working; 
tables cycle_length; run;

*now coding for conception risk based on the actuarial data and the current date in the cycle;
data bias2.working; set bias2.working; 
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

proc freq data=bias2.working; 
tables risk; run;

proc means data=bias2.working; 
var risk; run;

*rescoring explicit preference so midpoint is 0; 
data bias2.working; set bias2.working; 
attitude = attitudeB4 - 4; run;

proc corr data=bias2.working; 
var attitudeB4 attitude; run;

*save bias2.working dataset externally and check it out;
data bias2.cleaned; set bias2.working; run;

proc means data=bias2.cleaned; run;
proc contents data=bias2.cleaned; run;

*shorten the dataset;
data bias2.short; set bias2.cleaned; 
keep session_id session_status session_date 

age citizen edu gender residence religion2009 relid ethnicity fieldofstudy polid racecomb zipnow ziplong whiteblack whitenonwhite work race

IAT attitude warmth_black warmth_white 

repstatus pregnow givenbirth
lastcycleday_other lastcyclemonth_other twocycleday_other twocyclemonth_other
lastcycle_day lastcycle_month twocycle_day twocycle_month
sess_date sess_day lastcycle_numday twocycle_numday 
currentcycle_day cycle_length risk

debriefed keep; run;

*keeping people who saw the reproduction questionnaire. this technically eliminates people who saw the instructions but not the questionnaire.;
data bias2.short; set bias2.short; 
if keep NE 1 then delete; run;

proc contents data=bias2.short; run;
proc means data=bias2.short; run;


TITLE 'Full Sample Characteristics - People who saw the reproduction questionnaire';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\Full Sample Characteristics - People who saw the reproduction questionnaire.html';

proc means data=bias2.short; 
var age relid polid; run;

proc freq data=bias2.short;
tables gender edu racecomb race religion2009 citizen residence; run;

ODS HTML CLOSE;


*creating dataset where only qualified participants are included;
data bias2.short; set bias2.short; 
keep2 = 0; 
if repstatus = "fertile" then keep2 = 1; run;

data bias2.short; set bias2.short; 
keep3 = 0;
if pregnow = "no" then keep3=1; run;

data bias2.short; set bias2.short; 
keep4 = 0;
if currentcycle_day < 41 AND currentcycle_day > 0 then keep4=1; run;

data bias2.short; set bias2.short; 
keep5 = 0; 
if cycle_length in (20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) then keep5 = 1; run;

proc freq data=bias2.short; table keep2 keep3 keep4 keep5 risk; run;

data bias2.qualify; set bias2.short; 
if keep2 = 0 then delete; run; 

data bias2.qualify; set bias2.qualify; 
if keep3 = 0 then delete; run;

data bias2.qualify; set bias2.qualify; 
if keep4 = 0 then delete; run;

data bias2.qualify; set bias2.qualify; 
if keep5 = 0 then delete; run;

data bias2.qualify; set bias2.qualify; 
if gender NE 'f' then delete; run;

proc freq data=bias2.qualify;
table risk; run;

*creating standardized outcome variable like they did in the article;
proc standard data=bias2.qualify MEAN=0 STD=1 OUT=bias2.zqualify;
var IAT attitude warmth_black warmth_white risk whiteblack whitenonwhite; run;

proc contents data=bias2.zqualify; run;
proc means data=bias2.zqualify; run;

data bias2.zqualify; set bias2.zqualify; 
keep session_id IAT attitude warmth_black warmth_white risk whiteblack whitenonwhite; run;

proc contents data=bias2.zqualify; run;

data bias2.zqualify; set bias2.zqualify; 
warmth_diff = warmth_white - warmth_black; run;

proc corr data = bias2.zqualify; 
var warmth_white warmth_black warmth_diff; run;

data bias2.zqualify; set bias2.zqualify; 
att_composite = mean(IAT, attitude, warmth_diff); run;

proc contents data=bias2.zqualify; run;
proc means data=bias2.zqualify; run;

data bias2.zqualify; set bias2.zqualify; 
zIAT = IAT; 
zattitude = attitude; 
zwarmth_black = warmth_black; 
zwarmth_white = warmth_white; 
zwarmth_diff = warmth_diff; 
zrisk = risk; 
zatt_composite = att_composite; 
zwhiteblack = whiteblack; 
zwhitenonwhite = whitenonwhite; 
drop IAT attitude warmth_black warmth_white warmth_diff risk whiteblack whitenonwhite; run;

proc sort data=bias2.qualify; by session_id; 
proc sort data=bias2.zqualify; by session_id; 

data bias2.qualified; 
merge bias2.zqualify bias2.qualify; 
by session_id; run;

proc contents data=bias2.qualified; run;
proc means data=bias2.qualified; run;

data bias2.qualified; set bias2.qualified; 
drop keep2 keep3 keep4 keep5; run;




TITLE 'Sample Characteristics for Qualifying Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\Sample Characteristics for Qualifying Sample.html';

proc means data=bias2.qualified; 
var age relid polid; run;

proc freq data=bias2.qualified;
tables gender edu race ethnicity racecomb religion2009 citizen residence; run;

ODS HTML CLOSE;



TITLE 'Hypothesis Tests for Qualifying Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\Hypothesis Tests for Qualifying Sample.html';

proc corr data=bias2.qualified; 
var risk IAT attitude warmth_black warmth_white att_composite; run;

TITLE 'Restricting to only White women';
data bias2.white; set bias2.qualified; 
if whiteblack NE 1 then delete; run;

proc corr data=bias2.white; 
var risk IAT attitude warmth_black warmth_white att_composite; run;

ODS HTML CLOSE;



TITLE 'Follow up Tests for Qualifying Sample';
ODS HTML BODY = 'C:\Users\chawkins\Documents\Research Projects\Race and Reproduction\analysis\study2\Follow up Tests for Qualifying Sample.html';

TITLE 'Controlling for Race - White or Black';
proc ttest data=bias2.qualified; 
class whiteblack; 
var att_composite; run;

proc glm data=bias2.qualified; 
model att_composite=whiteblack risk  / CLPARM; run;

proc reg data=bias2.qualified; 
model att_composite=whiteblack risk  / stb; run;

TITLE 'Controlling for Race - White or NonWhite';
proc ttest data=bias2.qualified; 
class whitenonwhite; 
var att_composite; run;

proc glm data=bias2.qualified; 
model att_composite=whitenonwhite risk  / CLPARM; run;

proc reg data=bias2.qualified; 
model att_composite=whitenonwhite risk  / stb; run;

TITLE 'Restricting to 18-23, College Students, US Citizens';
data bias2.restricted; set bias2.qualified; 

if age < 18 then delete; 
else if age > 23 then delete; 

if citizen NE 'US' then delete; 

if work NE '25-9999' then delete; run;

proc freq data=bias2.restricted; 
table citizen age work; run;

proc glm data=bias2.restricted; 
model att_composite=whiteblack risk  / CLPARM; run;

proc reg data=bias2.restricted; 
model att_composite=whiteblack risk  / stb; run;

ODS HTML CLOSE;




*removing zip code and other irrelevant variables so i can post the data online without identifying information;
proc contents data=bias2.short; run;
proc contents data=bias2.qualified; run;

data bias2.full; set bias2.short; 
drop zipnow ziplong religion2009 fieldofstudy keep session_date; run;
*session_date dropped because SAS transforms into weird format that is unreadable. recoded sess_date has this information;

data bias2.qualified; set bias2.qualified; 
drop zipnow ziplong lastcycleday_other lastcyclemonth_other twocycleday_other twocyclemonth_other session_date; run;
