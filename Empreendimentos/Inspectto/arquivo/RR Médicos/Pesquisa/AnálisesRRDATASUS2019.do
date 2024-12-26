set more off
use "C:\bancosDatasus\AIH RD\SP\SP2020.dta", replace


*dre = doença do refluxo gastroesofágico 
gen dre = 1 if regex(DIAG_PRINC, "K21")
replace dre = 2 if regex(DIAGSEC1, "K21")
replace dre = 3 if regex(DIAGSEC2, "K21")
replace dre = 4 if regex(DIAGSEC3, "K21")
replace dre = 5 if regex(DIAGSEC4, "K21")
replace dre = 6 if regex(DIAGSEC5, "K21")
replace dre = 7 if regex(DIAGSEC6, "K21")
tab dre


gen dreDiagPrimario = 0 if dre!=.
replace dreDiagPrimario = 1 if dre==1
lab define dreDiagPrimario 0"Secundário" 1"Primário"
lab val dreDiagPrimario dreDiagPrimario
tab dreDiagPrimario

drop if dre==.
save "C:\bancosDatasus\AIH RD\SP\SPdre.dta", replace
i




 *Definindo labels
 
 *lab define sn 0"Não" 1"Sim"
  gen idosa = IDADE>60
 tab idosa
 lab val idosa sn
 
 *Raça_Cor
 encode RACA_COR, gen(raca)
 recode raca 6=.
 gen cor_branca =1 if raca !=1 & raca<.
 replace cor_branca =0 if raca==1
 lab define cor_branca 0"Branca" 1"Não branca"
 lab val cor_branca cor_branca
 tab cor_branca
 
 encode NACIONAL, gen (nacional)
 gen nacionalidade = 0 if nacional==1
 replace nacionalidade =1 if nacional!=1
 lab define nacionalidade 0"BR" 1"Estrangeira"
 lab val nacionalidade nacionalidade
 tab nacionalidade
 
 rename CAR_INT caraterinternação
 encode caraterinternação, gen (tipoint)
 gen tipointernação = 0 if tipoint==1
 replace tipointernação =1 if tipoint ==2
 lab define tipointernação 0"Eletivo" 1"Urgência"
 lab val tipointernação tipointernação

rename MORTE obito
lab val obito sn


global perfilquali idosa    cor_branca  nacionalidade obito  tipointernação  DIAG_PRINC   
global perfilquanti  IDADE DIAS_PERM UTI_MES_TO
global custos VAL_SH VAL_SP VAL_TOT VAL_UTI
global internaçãoquanti   DIAR_ACOM QT_DIARIAS   IDADE

asdoc tab1 $perfilquali, replace
asdoc tabstat $perfilquanti, stat(p50 iqr) append
tabstat UTI_MES_TO if UTI_MES_TO>0, stat(p50 iqr)
