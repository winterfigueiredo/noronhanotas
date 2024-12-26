set dp comma
import excel "C:\Users\winte\O meu disco\Empreendimentos\Inspectto\Consultorias Inspectto\Celiana_novo\bdCelianaNovo.xlsx", sheet("banco") firstrow clear

**# Gerenciamento do banco de dados
// #Excluindo pacientes com dados apenas do frênico
drop if idade==.
drop if idade <18
drop if fuma==1 & grupo==0

 
// Se feminino
gen pimax = ((-0.49*idade)+110.5) if sexo==0
gen lipimax = pimax  - 14.92 if sexo==0
// gen pemax = ((-0.62*idade)+115.7) if sexo==0
gen lipemax = pe  - 18.36 if sexo==0

// Se masculino
replace pimax = ((-0.80*idade+0.48*peso)+119.7) if sexo==1
replace lipimax = pimax  - 27.38 if sexo==1
// replace pemax = ((-0.81*idade)+165.3) if sexo==1
replace lipemax = pe  - 25.58 if sexo==1

gen altCondFren =  Amplitmédia <0.46
tab altCondFren


lab define grupo 0"controle"1"AF" 2"SCA2" 3"SCA3" 4"SCA7"
lab val grupo grupo
tab grupo

global norm cvfl cvfp vef1l  vef1p pfel pfep lipe etco2  Amplitmédia Alfa
global nnorm vef1cvfl vef1cvfp pimax lipimax pimax pe snip pft spo2 Amplitmáx  AmplitTrapéziomv MunixTrapézio sara icars
// #Artigo SCA2
recode grupo 0 = 5
foreach i in $norm{
	su `i'
	ttest `i' if grupo== 5 | grupo==2, by(grupo) 
}
i

foreach i in $nnorm{
	su `i'
	qreg `i' grupo if grupo==0 | grupo==2
}

lab define sexo 0"Feminino" 1"Masculino"
lab val sexo sexo
tab sexo

lab define    padraoVent 0"Normal" 1"Restritivo" 2"Obstrutivo"
lab val padraoVent padraoVent
tab padraoVent

lab define sn 0"Não" 1"Sim"
lab val disfagia sn 

lab define fuma 0"Não" 1"Sim" 2"Ex"
lab val fuma fuma 

lab define berlim 0"Baixo risco SAOS" 1"Alto risco SAOS"
lab val berlim berlim 




drop piorneuropatia

// Verificar com Celiana
// Cálculo do pin na fórmula validada é a partir de 20 anos, e na amostra tem até crianças
//
// gen pin = .
// replace pin = idade - (1.645 * 27.4) if sexo == 1
// replace pin = idade - (1.645 * 18.6) if sexo == 0
// su pin


**# // Definindo variáveis globais 

// ########Verificar se  o IMC de 35 do grupo controle é normal
global socioquanti  idade peso altura imc     tempoDoenca idadeIniSintomas
global socioquali sexo   fuma   
 

 
//  #Definindo variáveis normais e não normais
global resppar cvfl cvfp vef1l vef1p  pfep pe lipemax fr fc etco2
global respnpar vef1cvfl vef1cvfp  pfel   pimax lipimax  piSent snip pft spo2 sara icars borg
 
// ########Verificar se  o IMC de 35 do grupo controle é normal


global caract idade   peso altura imc  Circunfcervicalcm  CircunfAbdominalcm
 global desfecho tempoDoenca idadeIniSintomas
swilk $caract


global demograficos idade tempoDoenca  
global antropometricos peso altura imc  Circunfcervicalcm  CircunfAbdominalcm
global resp  cvfl cvfp vef1l vef1p vef1cvfl vef1cvfp pfel pfep pimax lipimax   piSent pe lipemax snip  pft spo2 fr fc etco2  
global escalas sara icars borg
global frenico   Amplitmáx Amplitmédia AmplitTrapéziomv  MunixTrapézio Alfa
global desfecho  sara icars  borg
global expo tempoDoenca idadeIniSintomas 

global antro peso altura imc circabdomcm circcervicalcm

global desfAnalise $resp  $escalas $frenico  

**# Análise AF tab1 

//  // // Comparação das características sociodemográficas entre os grupos
dtable i.sexo  i.fuma i.disfagia $caract  i.padraoVent  $expo i.altCondFren  if grupo==0 | grupo==1,  by(grupo, nototals tests  testnotes)  continuous(tempoDoenca altura imc ,test(kwallis)) nformat(%9.1f)  factor(,test(pearson))  title("Tabela 1. Comparação das características entre os grupos controle e Friedreich.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Fisher para variáveis qualitativas) sample(, place(seplabels)) export(tesetab1.docx, replace) 
dtable i.sexo  i.fuma  i.disfagia $caract  i.padraoVent  $expo i.altCondFren  if grupo==0 | grupo==1,  by(grupo, nototals tests  testnotes)  continuous(tempoDoenca altura imc ,test(kwallis)) nformat(%9.2f)  factor(,test(pearson))  sample(, place(seplabels)) export(tesetab1a.docx, replace)

  
**Análise AF tab2 
dtable $resp  $escalas $frenico    if grupo==0 | grupo==1, by(grupo, tests testnotes nototals) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.1f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tesetab2.docx, replace) 
 
dtable  $resp  $escalas $frenico    if grupo==0 | grupo==1, by(grupo, tests testnotes nototals) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.2f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tesetab2a.docx, replace) 


// Análise AF Tab 3
spearman   idade $resp  $escalas $frenico if grupo==1, stats(rho p) pw star(.05)
spearman   tempoDoenca  $resp  $escalas $frenico  if grupo==1, stats(rho p) pw star(.05)
spearman   peso  $resp  $escalas $frenico  if grupo==1, stats(rho p) pw star(.05)
spearman   altura  $resp  $escalas $frenico   if grupo==1, stats(rho p)
spearman   imc  $resp  $escalas $frenico   if grupo==1, stats(rho p)
spearman   Circunfcervicalcm  $resp  $escalas $frenico  if grupo==1, stats(rho p)
spearman   CircunfAbdominalcm  $resp  $escalas $frenico  if grupo==1, stats(rho p)
spearman   sara  $resp  $escalas $frenico   if grupo==1, stats(rho p)
spearman   icars  $resp  $escalas $frenico   if grupo==1, stats(rho p)


//Correlação SARA e ICARS
scatter  icars sara if grupo==1, ytitle(ICARS) xtitle(SARA) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,92; p<0,01") 
graph export afsaraicars.svg, replace


// Painel de correlações - SARA
scatter  cvfl sara if grupo==1, ytitle(CVF(L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,63; p=0,09") 
graph save afsaracvf, replace

scatter  vef1l sara if grupo==1, ytitle(VEF1 (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,80; p=0,02") 
graph save afsaravef1, replace

 scatter  vef1cvfl sara if grupo==1, ytitle(VEF1/CVF (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,15; p=0,72") 
 graph save afsaravef1cvf, replace
 
 scatter  pfel sara if grupo==1, ytitle(PFE (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)10, nogrid) note("Spearman's rho = -0,17; p=0,67") 
 graph save afpel, replace
 

 scatter  pimax sara if grupo==1, ytitle(Pi máx.) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,48; p=0,21") 
 graph save afsarapimax, replace
 
 scatter  snip sara if grupo==1, ytitle(SNIP) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = 0,29; p=0,47") 
graph save afsarasnip, replace

graph combine afsaracvf.gph afsaravef1.gph afsaravef1cvf.gph afpel.gph afsarapimax.gph afsarasnip.gph
  
graph save  afsararesp.gph, replace
graph export afsararesp.svg, replace



// Painel de correlações - icars
scatter  cvfl icars if grupo==1, ytitle(CVF(L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,33; p=0,41") 
graph save aficarscvf, replace

scatter  vef1l icars if grupo==1, ytitle(VEF1 (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,50; p=0,20") 
graph save aficarsvef1, replace

 scatter  vef1cvfl icars if grupo==1, ytitle(VEF1/CVF (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,14; p=0,73") 
 graph save aficarsvef1cvf, replace
 
 scatter  pfel icars if grupo==1, ytitle(PFE (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)10, nogrid) note("Spearman's rho = 0,01; p=0,81") 
 graph save afpel, replace
 

 scatter  pimax icars if grupo==1, ytitle(Pi máx.) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,30; p=0,44") 
 graph save aficarspimax, replace
 
 scatter  snip icars if grupo==1, ytitle(SNIP) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = 0,02; p=0,95") 
graph save aficarssnip, replace

graph combine aficarscvf.gph aficarsvef1.gph aficarsvef1cvf.gph afpel.gph aficarspimax.gph aficarssnip.gph
  
graph save  aficarsresp.gph, replace
graph export aficarsresp.svg, replace

**# Análise SCA2 tab1 

//  // // Comparação das características sociodemográficas entre os grupos
dtable i.sexo  i.fuma i.disfagia $caract  i.padraoVent  $expo i.altCondFren  if grupo==0 | grupo==2,  by(grupo, nototals tests  testnotes)  continuous(tempoDoenca altura imc ,test(kwallis)) nformat(%9.1f)  factor(,test(pearson))  title("Tabela 1. Comparação das características entre os grupos controle e Friedreich.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Fisher para variáveis qualitativas) sample(, place(seplabels)) export(tesesca2tab1.docx, replace) 
dtable i.sexo  i.fuma  i.disfagia $caract  i.padraoVent  $expo i.altCondFren  if grupo==0 | grupo==2,  by(grupo, nototals tests  testnotes)  continuous(tempoDoenca altura imc ,test(kwallis)) nformat(%9.2f)  factor(,test(pearson))  sample(, place(seplabels)) export(teseSCA2a.docx, replace)
ha
  
**Análise SCA2 tab2 
dtable $resp  $escalas $frenico  if grupo==0 | grupo==2, by(grupo, tests testnotes nototals) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.1f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(teseSCA2b.docx, replace) 
 
dtable  $resp $frenico  $escalas  if grupo==0 | grupo==2, by(grupo, tests testnotes nototals) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.2f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tesetab2a.docx, replace) 


// Análise SCA2 Tab 3
spearman   idade $resp  $escalas $frenico if grupo==2, stats(rho p) pw star(.05)
spearman   tempoDoenca  $resp  $escalas $frenico if grupo==2, stats(rho p) pw star(.05)
spearman   peso $resp  $escalas $frenico  if grupo==2, stats(rho p) pw star(.05)
spearman   altura  $resp  $escalas $frenico if grupo==2, stats(rho p)
spearman   imc  $resp  $escalas $frenico  if grupo==2, stats(rho p)
spearman   Circunfcervicalcm  $resp  $escalas $frenico if grupo==2, stats(rho p)
spearman   CircunfAbdominalcm  $resp  $escalas $frenico  if grupo==2, stats(rho p)
spearman   sara  $resp  $escalas $frenico  if grupo==2, stats(rho p)
spearman   icars  $resp  $escalas $frenico  if grupo==2, stats(rho p)



//Correlação SARA e ICARS
scatter  icars sara if grupo==2, ytitle(ICARS) xtitle(SARA) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,84; p<0,01") 
graph export sca2saraicars.svg, replace


// Painel de correlações - SARA
scatter  cvfl sara if grupo==2, ytitle(CVF(L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,39; p=0,37") 
graph save sca2saracvf, replace

scatter  vef1l sara if grupo==2, ytitle(VEF1 (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = 0,11; p=0,81") 
graph save sca2saravef1, replace

 scatter  vef1cvfl sara if grupo==2, ytitle(VEF1/CVF (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,71; p=0,07") 
 graph save sca2aravef1cvf, replace
 
 scatter  pfel sara if grupo==2, ytitle(PFE (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)10, nogrid) note("Spearman's rho = -0,14; p=0,75") 
 graph save sca2pel, replace
 

 scatter  pimax sara if grupo==2, ytitle(Pi máx.) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,17; p=0,69") 
 graph save sca2sarapimax, replace
 
 scatter  snip sara if grupo==2, ytitle(SNIP) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,46; p=0,28") 
graph save sca2sarasnip, replace

graph combine sca2saracvf.gph sca2saravef1.gph sca2aravef1cvf.gph sca2pel.gph sca2sarapimax.gph sca2sarasnip.gph
  
graph save  sca2sararesp.gph, replace
graph export sca2sararesp.svg, replace



//Painel de correlação ICARS

scatter  cvfl icars if grupo==2, ytitle(CVF(L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,46; p=0,28") 
graph save sca2icarscvf, replace

scatter  vef1l icars if grupo==2, ytitle(VEF1 (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = 0,01; p=0,99") 
graph save sca2icarsvef1, replace

 scatter  vef1cvfl icars if grupo==2, ytitle(VEF1/CVF (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,19; p=0,69") 
 graph save sca2aravef1cvf, replace
 
 scatter  pfel icars if grupo==2, ytitle(PFE (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)10, nogrid) note("Spearman's rho = -0,53; p=0,21") 
 graph save sca2pel, replace
 

 scatter  pimax icars if grupo==2, ytitle(Pi máx.) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,35; p=0,42") 
 graph save sca2icarspimax, replace
 
 scatter  snip icars if grupo==2, ytitle(SNIP) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,57; p=0,17") 
graph save sca2icarssnip, replace

graph combine sca2icarscvf.gph sca2icarsvef1.gph sca2aravef1cvf.gph sca2pel.gph sca2icarspimax.gph sca2icarssnip.gph
  
graph save  sca2icarsresp.gph, replace
graph export sca2icarsresp.svg, replace




**# Análise SCA3 tab1 

//  // // Comparação das características sociodemográficas entre os grupos
dtable i.sexo  i.fuma i.disfagia $caract  i.padraoVent  $expo i.altCondFren  if grupo==0 | grupo==3,  by(grupo, nototals tests  testnotes)  continuous(tempoDoenca altura imc ,test(kwallis)) nformat(%9.1f)  factor(,test(pearson))  title("Tabela 1. Comparação das características entre os grupos controle e Friedreich.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Fisher para variáveis qualitativas) sample(, place(seplabels)) export(tesesca3tab1.docx, replace) 
dtable i.sexo  i.fuma  i.disfagia $caract  i.padraoVent  $expo i.altCondFren  if grupo==0 | grupo==3,  by(grupo, nototals tests  testnotes)  continuous(tempoDoenca altura imc ,test(kwallis)) nformat(%9.2f)  factor(,test(pearson))  sample(, place(seplabels)) export(teseSCA3a.docx, replace)


**#Análise SCA3 tab2 
dtable $resp  $escalas $frenico  if grupo==0 | grupo==3, by(grupo, tests testnotes nototals) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.1f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(teseSCA2b.docx, replace) 
 
dtable  $resp $frenico  $escalas  if grupo==0 | grupo==3, by(grupo, tests testnotes nototals) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.2f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tesetab2a.docx, replace) 


**#Análise SCA2 Tab 3
spearman   idade $resp  $escalas $frenico if grupo==3, stats(rho p) pw star(.05)
spearman   tempoDoenca  $resp  $escalas $frenico if grupo==3, stats(rho p) pw star(.05)
spearman   peso $resp  $escalas $frenico  if grupo==3, stats(rho p) pw star(.05)
spearman   altura  $resp  $escalas $frenico if grupo==3, stats(rho p)
spearman   imc  $resp  $escalas $frenico  if grupo==3, stats(rho p)
spearman   Circunfcervicalcm  $resp  $escalas $frenico if grupo==3, stats(rho p)
spearman   CircunfAbdominalcm  $resp  $escalas $frenico  if grupo==3, stats(rho p)
spearman   sara  $resp  $escalas $frenico  if grupo==3, stats(rho p)
spearman   icars  $resp  $escalas $frenico  if grupo==3, stats(rho p)


//#Correlação SARA e ICARS - SCA3
scatter  icars sara if grupo==3, ytitle(ICARS) xtitle(SARA) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = 0,93; p<0,01") 
graph export sca3saraicars.svg, replace


// Painel de correlações - SARA
scatter  cvfl sara if grupo==3, ytitle(CVF(L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,45; p=0,18") 
graph save sca3saracvf, replace

scatter  vef1l sara if grupo==3, ytitle(VEF1 (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,44; p=0,19") 
graph save sca3saravef1, replace

 scatter  vef1cvfl sara if grupo==3, ytitle(VEF1/CVF (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = -0,11; p=0,74") 
 graph save sca3aravef1cvf, replace
 
 scatter  pfel sara if grupo==3, ytitle(PFE (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)10, nogrid) note("Spearman's rho = -0,27; p=0,42") 
 graph save sca3pel, replace
 

 scatter  pimax sara if grupo==3, ytitle(Pi máx.) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,19; p=0,58") 
 graph save sca3sarapimax, replace
 
 scatter  snip sara if grupo==3, ytitle(SNIP) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,29; p=0,39") 
graph save sca3sarasnip, replace

graph combine sca3saracvf.gph sca3saravef1.gph sca3aravef1cvf.gph sca3pel.gph sca3sarapimax.gph sca3sarasnip.gph
  
graph save  sca3sararesp.gph, replace
graph export sca3sararesp.svg, replace


//Painel de correlação ICARS -SCA3

scatter  cvfl icars if grupo==3, ytitle(CVF(L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,72; p=0,02") 
graph save sca3icarscvf, replace

scatter  vef1l icars if grupo==3, ytitle(VEF1 (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,72; p=0,02") 
graph save sca3icarsvef1, replace

 scatter  vef1cvfl icars if grupo==3, ytitle(VEF1/CVF (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(10)100, nogrid) note("Spearman's rho = -0,35; p=0,30") 
 graph save sca3aravef1cvf, replace
 
 scatter  pfel icars if grupo==3, ytitle(PFE (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)10, nogrid) note("Spearman's rho = -0,56; p=0,09") 
 graph save sca3pel, replace
 

 scatter  pimax icars if grupo==3, ytitle(Pi máx.) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,32; p=0,35") 
 graph save sca3icarspimax, replace
 
 scatter  snip icars if grupo==3, ytitle(SNIP) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,60; p=0,06") 
graph save sca3icarssnip, replace

graph combine sca3icarscvf.gph sca3icarsvef1.gph sca3aravef1cvf.gph sca3pel.gph sca3icarspimax.gph sca3icarssnip.gph
  
graph save  sca3icarsresp.gph, replace
graph export sca3icarsresp.svg, replace


i







































































i

foreach i in 1 2 3 4 {
	dtable $resp  if grupo==0 | grupo==`i', by(grupo, tests testnotes nototals) continuous($respnpar, statistics(med iqr)  test(kwallis)) sformat("(%s)" iqr)   nformat(%9.2f) column(by(hide) test(p-value)) factor(,test(fisher))  sample(, place(seplabels)) export(tab2`i'.docx, replace) 
}


// Tabela 3
swilk $frenico
global fpar  Amplitmédia   Alfa 
global fnpar  Amplitmáx AmplitTrapéziomv MunixTrapézio


dtable  $frenico , by(grupo, tests testnotes nototals) continuous(altura imc $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.1f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 2. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tab3geralaf.docx, replace) 

foreach i in 1 2 3 4 {
	dtable $frenico  if grupo==0 | grupo==`i', by(grupo, tests testnotes nototals) continuous($fnpar , statistics(med iqr)  test(kwallis)) sformat("(%s)" iqr)   nformat(%9.2f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tab3`i'.docx, replace) 
}


// ##AF
// // Comparação das características sociodemográficas entre os grupos
dtable i.sexo i.fuma  $demograficos $socioquanti  $antropometricos   $resp $frenico i.altCondFren if grupo==0 | grupo==1, by(grupo, tests testnotes nototals) continuous(altura imc $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)   nformat(%9.2f) column(by(hide) test(p-value)) factor(,test(fisher)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tab1af.docx, replace) 




i
dtable i.sexo i.fuma  $demograficos $socioquanti  $antropometricos   $resp $frenico  i.piorneuropatia if grupo==0 | grupo==2, by(grupo, tests nototals) continuous(altura imc, statistics(med iqr) )   nformat(%9.2f)  factor(,test(fisher)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)  sample(, place(seplabels)) export(tab1sca2.docx, replace) 

dtable i.sexo i.fuma  $demograficos $socioquanti  $antropometricos   $resp $frenico  i.piorneuropatia  if grupo==0 | grupo==3, by(grupo, tests nototals ) continuous(altura imc, statistics(med iqr) )   nformat(%9.2f)  factor(,test(fisher)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle) sample(, place(seplabels)) export(tab1sca3.docx, replace) 

dtable i.sexo i.fuma  $demograficos $socioquanti  $antropometricos   $resp $frenico  i.piorneuropatia , by(grupo, tests nototals ) continuous(altura imc, statistics(med iqr) )   nformat(%9.2f)  factor(,test(fisher)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Fisher comparado ao grupo controle") note(Teste t de student comparado ao grupo controle) note(Teste de Mann-Whitney comparado ao grupo controle)sample(, place(seplabels)) export(tab1sca7.docx, replace) 

**# Tabela 3
dtable i.sexo i.fuma  $socioquanti if grupo==0 | grupo==1, by(grupo, tests nototals ) continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(fisher)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(tab1af.docx, replace) 


swilk $antropometricos   $resp
global resppar cvfl cvfp vef1l vef1p  pfep pe lipemax fr fc etco2
global respnpar vef1cvfl vef1cvfp  pfel   pimax lipimax  piSup piSent snip pft spo2 sara icars borg


**# Tabela 3
spearman   tempoDoenca $resp  if grupo==1, stats(rho p) pw star(.05)

// Artigo SCA2 
spearman   tempoDoenca $resp  $frenico  if grupo==2, stats(rho p) pw star(.05)
spearman   idade $resp  $frenico  if grupo==2, stats(rho p) pw star(.05)
 
 
 
 
**# Tabela 2
dtable cvfl cvfp vef1l vef1p piSup piSent pe pfe snip if grupo==1, by(piorneuropatia, tests nototals ) continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(fisher)) title("Tabela 4. Comparação das características entre os grupos.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(tab4af.docx, replace) 
 
**# Bookmark #1
dtable cvfl cvfp vef1l vef1p vef1cvfl vef1cvfp pimax piSent   pe pfel pfep snip if grupo==2, by(altCondFren, tests nototals ) continuous( $respnpar, statistics(med iqr)  test(kwallis )) sformat("(%s)" iqr)  continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(fisher)) title("Tabela 4. Comparação das características entre os grupos.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(tab4sca2.docx, replace) 

 
dtable cvfl cvfp vef1l vef1p vef1cvfl vef1cvfp pimax piSent   pe pfel pfep snip if grupo==3, by(piorneuropatia, tests nototals ) continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(fisher)) title("Tabela 4. Comparação das características entre os grupos.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(tab4sca3.docx, replace) 


 spearman   sara $resp $frenico  if grupo==2, stats(rho p) pw star(.05)
  spearman   icars $resp $frenico  if grupo==2, stats(rho p) pw star(.05)

 
// Painel de correlações - SARA
scatter  cvfl sara if grupo==2, ytitle(CVF(L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,31; p=0,29") 
graph export saracvf.svg, replace
scatter  vef1l sara if grupo==2, ytitle(VEF1 (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,10; p=0,72") 
graph export saravef1.svg, replace
 scatter  vef1l sara if grupo==2, ytitle(VEF1/CVF (L)) xtitle(SARA) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = 0,11; p=0,70") 
graph export saravef1cvf.svg, replace
 scatter  pimax sara if grupo==2, ytitle(Pi máx.) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,28; p=0,34") 
graph export sarapimax.svg, replace
 scatter  snip sara if grupo==2, ytitle(SNIP) xtitle(SARA) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,46; p=0,10") 
graph export sarasnip.svg, replace

 // Painel de correlações - icars
  
 
 scatter  cvfl icars if grupo==2, ytitle(CVF(L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,37; p=0,20") 
graph export icarscvf.svg, replace
scatter  vef1l icars if grupo==2, ytitle(VEF1 (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = -0,224; p=0,41") 
graph export icarsvef1.svg, replace
 scatter  vef1l icars if grupo==2, ytitle(VEF1/CVF (L)) xtitle(ICARS) xlabel(, nogrid) ylabel(0(1)6, nogrid) note("Spearman's rho = 0,05; p=0,84") 
graph export icarsvef1cvf.svg, replace
 scatter  pimax icars if grupo==2, ytitle(Pi máx.) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,60; p=0,03") 
graph export icarspimax.svg, replace
 scatter  snip icars if grupo==2, ytitle(SNIP) xtitle(ICARS) xlabel(, nogrid) ylabel(0(25)150, nogrid) note("Spearman's rho = -0,29; p=0,32") 
graph export sarasnip.svg, replace
i
i
// Comparação das características pulmonares
//
// dtable $funpul if grupo=="AF" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(af_tab2.docx, replace)
dtable $funpul if grupo==0 | grupo==1, by(grupo, tests )continuous(,test(kwallis)) nformat(%9.2f)    export(af_tab2f.docx, replace)

// Comparação dos dados do Frênico
//
// dtable $frenico if grupo=="AF" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(af_tab3.docx, replace)
dtable $frenico if grupo=="AF" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis))  nformat(%9.2f)  export(af_tab3f.docx, replace)


//
//  No artigo serão as mesmas correlações que fizemos com enfoque em tempo de doença e possível piora da capacidade respiratória (quanto maior o tempo de doença, piores os parâmetros ventilatórios),  dos parâmetros respiratórios com SARA, ICARS e a escala de Berlim que pelo que vi os valores sugerem distúrbios do sono. 
 
 Os dados do frênico que vimos que não tinha dado significante, o professor pediu para analisar sobretudo aqueles da amplitude média.Aparecem os números em vermelho (com destaque em amarelo na tabela) e está demonstrando o diagnóstico se é SCA 2, SCA3 , Friedreich ou SCA 7. 
 
 Ele disse que essses que estão em vermelho, podem sugerir pior neuropatia do que aqueles com valores mais próximos da normalidade. Em outras palavras: será que os que aparecem em vermelho estão também com piores valores de CVF, Pi e PE e SNIP? 
 
 Coloquei as fórmulas de Pi e Pe máximas e a fórmula de SNIP ou sniff encontradas na população brasileira
 
 
SARA= 40 VALOR MÁXIMO DE ATAXIA

ICARS= 100  VALOR MÁXIMO DE ATAXIA



