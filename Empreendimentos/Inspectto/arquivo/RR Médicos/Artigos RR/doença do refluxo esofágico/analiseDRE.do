use "C:\bancosDatasus\AIH RD\SP\SPdre.dta", replace

 *Definindo labels
 
lab define sn 0"Não" 1"Sim"
  

encode SEXO, gen(sexo)
lab define sexo2 1"Masculino" 2"Feminino"
lab val sexo sexo2
  
 *Faixa Etária
gen faixaEtaria = 0 if IDADE>0 & IDADE<18
replace faixaEtaria = 1 if IDADE>=18 & IDADE<60
replace faixaEtaria = 2 if IDADE>=60 & IDADE<.
lab define faixaEtaria 0"Crianças e Adolescentes" 1"Adultos" 2"Idosos"
lab val faixaEtaria faixaEtaria
tab faixaEtaria

replace dreDiagPrimario = 1 if regex(DIAG_PRINC, "K210")
 

 *Raça_Cor
  lab define raçaCor2 1"Branca" 2"Preta" 3"Parda"4"Amarela"5"Indígena"
* lab val raçaCor raçaCor
 encode RACA_COR, gen(raçaCor) label(raçaCor)
 lab val raçaCor raçaCor2
 recode raçaCor 6=.
  tab raçaCor
 
 rename CAR_INT caraterinternação
 encode caraterinternação, gen (tipoint)
 gen tipointernação = 0 if tipoint==1
 replace tipointernação =1 if tipoint ==2
 lab define tipointernação 0"Eletivo" 1"Urgência"
 lab val tipointernação tipointernação

rename MORTE obito
lab val obito sn

gen uti = 0 if UTI_MES_TO==0
replace uti = 1 if UTI_MES_TO>0 & UTI_MES_TO<.
lab val uti sn

gen tratamentoCirurgico = 0 
replace tratamentoCirurgico = 1 if regex( PROC_REA, "0407010297")
tab tratamentoCirurgico
lab val tratamentoCirurgico sn

tab DIAG_PRINC
global perfilquali sexo faixaEtaria    raçaCor   obito  tipointernação     tratamentoCirurgico  uti dreDiagPrimario
global perfilquanti  IDADE DIAS_PERM UTI_MES_TO DIAR_ACOM QT_DIARIAS    
global custos VAL_SH VAL_SP VAL_TOT VAL_UTI
 


asdoc tab1 $perfilquali, replace
asdoc tabstat $perfilquanti, stat(mean sd p50 p25 p75) append fs(10) dec(2)
bysort faixaEtaria:  tab1    PROC_REA, sort
bysort  dreDiagPrimario  :  tab1    PROC_REA, sort
 i

*Fatores associados a mortalidade por DRE
foreach i in $perfilquali {
	tab `i' obito, row chi2
}
swilk $perfilquanti
foreach i in $perfilquanti {
	bysort obito: centile `i'
	ranksum `i', by(obito)
}

global ajustequali   sexo i.faixaEtaria IDADE uti UTI_MES_TO 
logistic obito $ajustequali  dreDiagPrimario

*ANÁLISE DE SOBREVIDA  DE PACIENTES INTERNADOS NA UTI

stset UTI_MES_TO, failure(obito)
stdescribe
sts list
sts graph, lost
/*
stset DIAS_PERM, failure(obito)
sts list, by(faixaEtaria) compare
sts graph , by(uti)
sts graph, lost
stcox sexo tratamentoCirurgico
stcurve, hazard at1(sexo=1) at2(sexo=2)
*/

*DETERMINANTES DO CUSTO 
asdoc su $custos


