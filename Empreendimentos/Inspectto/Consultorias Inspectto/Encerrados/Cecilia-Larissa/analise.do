import excel "Tcc.xlsx", sheet("Planilha1") firstrow clear
lab define grupo 0"  Fáscia Ilíaca" 1"Bloqueio Femoral"
lab val grupo grupo

asdoc tab1 Sexo Comorbidades Víciosalergias Mobilidadenoleito AlfaBeta Tipodefratura Mecanismodotrauma resgatedemorfina grupo 

lab define sn 0"Não" 1 "Sim"
  
tab Comorbidades
gen comorbidadescat = 1
replace comorbidadescat = 0  if regex(Comorbidades,"Nega")
tab comorbidadescat
 
gen vicioscat = 1
replace vicioscat = 0  if regex(Víciosalergias,"Nega")
tab vicioscat


su Idade
lab val comorbidadescat vicioscat sn 


table1_mc, by(grupo)  vars (Sexo cate\ comorbidadescat cate\ vicioscat cate\ Idade contn) onecol nospace 

rename Dor15min Dor1
rename Dor30min Dor2

egen codigo  = concat(Idade Sexo Víciosalergias )

encode Tipodefratura, gen(tipofratura)
regress Dor0 grupo i.tipofratura
margins tipofratura
marginsplot

 
ttest Dor0, by(Sexo)
ttest Dor0, by(comorbidadescat)
ttest Dor0, by(vicioscat)

encode Mecanismodotrauma, gen(mecanismo)
bysort mecanismo: su Dor0
anova Dor0 mecanismo

bysort tipofratura: su Dor0
anova Dor0 tipofratura


ttest Dor0, by( grupo)
pwcorr Dor0 Idade, sig

i

reshape long Dor, i(codigo) j(momento)
swilk Dor
regress Dor grupo momento
regress Dor grupo#momento
margins momento, over(grupo)
marginsplot,recastci(rcap) ytitle("Escala Visual Analógica - EVA") xtitle("") ylabel(0 (1)10, nogrid) title("") xlabel(0"Início" 1"15 min" 2"30 min", labsize(small)) note("Regressão Linear, p=0,97")  text(42 59 "grupoa") 
graph export "figura.emf", replace

