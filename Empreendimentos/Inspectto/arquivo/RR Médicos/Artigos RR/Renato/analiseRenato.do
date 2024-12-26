use "C:\Users\Winter\Google Drive\Empreendimentos\Inspectto\RR Médicos\Artigos\Renato\bdRenato.dta", replace
 set dp comma

 *Definindo labels
 lab define gruporenato 1"Gastroplastia com derivação intestinal (Bypass gástrico)" 2"Gastrectomia vertical em manga (Sleeve)" 3"Gastroplastia vertical com banda gástrica" 4"Gastrectomia vertical c/ ou s/ desvio duodenal (duodenal switch)"
 lab val gruporenato gruporenato
 tab gruporenato
 
 
 
 lab define sn 0"Não" 1"Sim"
  gen faixaetaria = 0
  replace faixaetaria =1 if IDADE>=18 & IDADE<60
  replace faixaetaria =2 if IDADE>60 & IDADE<.
  tab faixaetaria
  i
 tab idoso
 lab val idoso sn
 
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


encode MES_CMPT, gen(mês)
drop MES_CMPT


encode SEXO, gen(sexo)
tab sexo, nolab
lab define sex 1"Masc" 2"Fem"
lab val sexo sex
tab sexo

gen uti = 0 if UTI_MES_TO==0
replace uti = 1 if UTI_MES_TO>0 & UTI_MES_TO<.
lab val uti sn
recode UTI_MES_TO 0=.
recode VAL_UTI 0=.
 
global quanti    IDADE DIAS_PERM VAL_SH UTI_MES_TO  VAL_UTI VAL_TOT
  



recode DIAR_ACOM 0=.
recode DIAS_PERM 0=.

recode QT_DIARIAS 0=.
gen customedioint= VAL_TOT/DIAS_PERM
su customedioint
gen customediodia = VAL_TOT/QT_DIARIAS
su customediodia

gen compObesidadeAdquirida = 0 
replace compObesidadeAdquirida =1 if TPDISEC1=="2" & regex(DIAGSEC1 , "E66")
tab compObesidadeAdquirida

gen diabetesmellitusAdquirida = 0 
replace diabetesmellitusAdquirida =1 if TPDISEC1=="2" & regex(DIAGSEC1, "E10")
replace diabetesmellitusAdquirida =1 if TPDISEC1=="2" & regex(DIAGSEC1 , "E11")
replace diabetesmellitusAdquirida =1 if TPDISEC1=="2" & regex(DIAGSEC1 , "E13")
replace diabetesmellitusAdquirida =1 if TPDISEC1=="2" & regex(DIAGSEC1 , "E14")
tab diabetesmellitusAdquirida

gen hipertensãoAdquirida = 0 
replace hipertensãoAdquirida =1 if TPDISEC1=="2" & regex(DIAGSEC1 , "I1")
tab hipertensãoAdquirida

global valores VAL_SH VAL_SP  VAL_UTI  VAL_TOT customedioint customediodia
global internação DIAS_PERM DIAR_ACOM QT_DIARIAS UTI_MES_TO 

 tab DIAGSEC1 if TPDISEC1=="2" , sort

*Análise dos dados
global variaveis gruporenato sexo cor_branca idoso  tipointernação uti obito  
global doencasadquiridas  compObesidadeAdquirida  diabetesmellitusAdquirida hipertensãoAdquirida

tabstat VAL_SH VAL_UTI, stat(sum)


asdoc tab1 $variaveis, replace
asdoc su $quanti, append
asdoc su $valores $internação, append
asdoc tab1 $doencasadquiridas, append


