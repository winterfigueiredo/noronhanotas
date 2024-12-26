// import excel "bdAmanda.xlsx", sheet(bd2) firstrow clear
//
// gen id = _n
//
// lab define sn 0"Errada" 1"Correta"
//
// // Q1
// gen r1a = strpos(q1a,"c) ")>0 
// gen r1d= 0 if q1d!=""
// replace r1d = 1 if strpos(q1d,"c) ")>0 
// lab val r1a r1d sn
// tab1 r1a r1d
// mcc r1a r1d
//
// // Q2
// gen r2a = strpos(q2a,"b) ")>0 
// gen r2d= 0 if q1d!=""
// replace r2d = 1 if strpos(q2d,"b) ")>0 
// lab val r2a r2d sn
// tab1 r2a r2d
// mcc r2a r2d
//
// // Q3
// gen r3a = strpos(q3a,"c)")>0 
// gen r3d= 0 if q1d!=""
// replace r3d = 1 if strpos(q3d,"c)")>0 
// lab val r3a r3d sn
// tab1 r3a r3d
// mcc r3a r3d
//
// // Q4a
// gen r4a = strpos(q4a,"a) ")>0 
// gen r4d= 0 if q1d!=""
// replace r4d = 1 if strpos(q4d,"a) ")>0 
// lab val r4a r4d sn
// tab1 r4a r4d
// mcc r4a r4d
//
// // Q5B
// gen r5a = strpos(q5a,"b) ")>0 
// gen r5d= 0 if q1d!=""
// replace r5d = 1 if strpos(q5d,"b) ")>0 
// lab val r5a r5d sn
// tab1 r5a r5d
// mcc r5a r5d
//
// // Q6d
// gen r6a = strpos(q6a,"d) ")>0 
// gen r6d= 0 if q1d!=""
// replace r6d = 1 if strpos(q6d,"d) ")>0 
// lab val r6a r6d sn
// tab1 r6a r6d
// mcc r6a r6d
//
//
// // Q7d
// gen r7a = strpos(q7a,"d)")>0 
// gen r7d= 0 if q1d!=""
// replace r7d = 1 if strpos(q7d,"d)")>0 
// lab val r7a r7d sn
// tab1 r7a r7d
// mcc r7a r7d
//
// // Q8a
// gen r8a = strpos(q8a,"a) ")>0 
// gen r8d= 0 if q1d!=""
// replace r8d = 1 if strpos(q8d,"a) ")>0 
// lab val r8a r8d sn
// tab1 r8a r8d
// mcc r8a r8d
//
// // Q9d
// gen r9a = strpos(q9a,"d) ")>0 
// gen r9d= 0 if q1d!=""
// replace r9d = 1 if strpos(q9d,"d) ")>0 
// lab val r9a r9d sn
// tab1 r9a r9d
// mcc r9a r9d
//
// // Q10d
// gen r10a = strpos(q10a,"parto")>0 
// gen r10d= 0 if q1d!=""
// replace r10d = 1 if strpos(q10d,"d) ")>0 
// lab val r10a r10d sn
// tab1 r10a r10d
// mcc r10a r10d
//
// egen totalpre = rowtotal (r1a r2a r3a r4a r5a r6a r7a r8a r9a r10a)
//
// egen totalpos = rowtotal (r1d r2d r3d r4d r5d r6d r7d r8d r9d r10d)
//
// swilk totalpre totalpos
// signrank totalpre =totalpos
//
// graph box totalpre totalpos
//
//


// Análise com os grupos iguais
import excel "bdAmanda.xlsx", sheet(bd2) firstrow clear

gen id = _n

lab define sn 0"Errada" 1"Correta"
i
// Q1
gen r1a = strpos(q1a,"c) ")>0 
gen r1d= 0 if q1d!=""
replace r1d = 1 if strpos(q1d,"c) ")>0 
lab val r1a r1d sn
tab1 r1a r1d
mcc r1a r1d

// Q2
gen r2a = strpos(q2a,"b) ")>0 
gen r2d= 0 if q1d!=""
replace r2d = 1 if strpos(q2d,"b) ")>0 
lab val r2a r2d sn
tab1 r2a r2d
mcc r2a r2d

// Q3
gen r3a = strpos(q3a,"c)")>0 
gen r3d= 0 if q1d!=""
replace r3d = 1 if strpos(q3d,"c)")>0 
lab val r3a r3d sn
tab1 r3a r3d
mcc r3a r3d

// Q4a
gen r4a = strpos(q4a,"a) ")>0 
gen r4d= 0 if q1d!=""
replace r4d = 1 if strpos(q4d,"a) ")>0 
lab val r4a r4d sn
tab1 r4a r4d
mcc r4a r4d

// Q5B
gen r5a = strpos(q5a,"b) ")>0 
gen r5d= 0 if q1d!=""
replace r5d = 1 if strpos(q5d,"b) ")>0 
lab val r5a r5d sn
tab1 r5a r5d
mcc r5a r5d

// Q6d
gen r6a = strpos(q6a,"d) ")>0 
gen r6d= 0 if q1d!=""
replace r6d = 1 if strpos(q6d,"d) ")>0 
lab val r6a r6d sn
tab1 r6a r6d
mcc r6a r6d


// Q7d
gen r7a = strpos(q7a,"d)")>0 
gen r7d= 0 if q1d!=""
replace r7d = 1 if strpos(q7d,"d)")>0 
lab val r7a r7d sn
tab1 r7a r7d
mcc r7a r7d

// Q8a
gen r8a = strpos(q8a,"a) ")>0 
gen r8d= 0 if q1d!=""
replace r8d = 1 if strpos(q8d,"a) ")>0 
lab val r8a r8d sn
tab1 r8a r8d
mcc r8a r8d

// Q9d
gen r9a = strpos(q9a,"d) ")>0 
gen r9d= 0 if q1d!=""
replace r9d = 1 if strpos(q9d,"d) ")>0 
lab val r9a r9d sn
tab1 r9a r9d
mcc r9a r9d

// Q10d
gen r10a = strpos(q10a,"parto")>0 
gen r10d= 0 if q1d!=""
replace r10d = 1 if strpos(q10d,"d) ")>0 
lab val r10a r10d sn
tab1 r10a r10d
mcc r10a r10d

egen totalpre = rowtotal (r1a r2a r3a r4a r5a r6a r7a r8a r9a r10a)

egen totalpos = rowtotal (r1d r2d r3d r4d r5d r6d r7d r8d r9d r10d)

swilk totalpre totalpos
signrank totalpre =totalpos

graph box totalpre totalpos


i


mcc q1a q1d

