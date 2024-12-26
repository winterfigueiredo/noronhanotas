import excel "bdCeliana.xlsx", sheet("bdCeliana") firstrow clear



tab diagnóstico
// excluindo pct com SCA 7
drop if diagnóstico=="SCA7"

 gen imc = peso / (altura^2)
su imc

 // drop if idade<18
tab diagnóstico
drop if cvf==.
tab diagnóstico

// Checando critérios de elegibilidade
su idade
// 11 pacientes acima de 80 anos excluídos
// drop if idade>80
tab diagnóstico
su idade
// drop if idade<18
tab diagnóstico
drop if cvf ==.
tab diagnóstico
su idade if diagnóstico=="SCA2"

// 14 pacientes excluídos sem função respiratória
su idade
 

tab diagnóstico

// Calcular pimax, lipimax pela fórmula do excel
lab define sexo 0"Feminino"1"Masculino"
lab val sexo sexo 

// Se feminino
gen pimax = ((-0.49*idade)+110.5) if sexo==0
gen lipimax = pimax  - 14.92 if sexo==0
// gen pemax = ((-0.62*idade)+115.7) if sexo==0
gen lipemax = pemax  - 18.36 if sexo==0

// Se masculino
replace pimax = ((-0.80*idade+0.48*peso)+119.7) if sexo==1
replace lipimax = pimax  - 27.38 if sexo==1
// replace pemax = ((-0.81*idade)+165.3) if sexo==1
replace lipemax = pemax  - 25.58 if sexo==1
sort idade

// Organizar o banco de dados com a tabela pacientes estudados
rename diagnóstico grupo
tab grupo


 
// Definindo variáveis globais
// ########Verificar se  o IMC de 35 do grupo controle é normal
global sociodemograficos  idade peso altura imc  
global demograficos idade tempodoença 
global antropometricos peso altura imc circcervicalcm circabdomcm
global funpul cvf vef1 vef1cvf pfe spo2 fr fc pimsup pimsent pemax snif    pft     
global resp cvf vef1 vef1cvf pfe   pimax lipimax pimsent pimsup sara icars berlim borg 
global frenico amplfrenicomax amplfrenicomed ampltrapmv munixtrap alfa
global desfecho  sara icars
global antro peso altura imc circabdomcm circcervicalcm

//
// // #Resumo congresso
// spearman $demograficos $resp if grupo=="AF", stats(rho p)  pw star(.05)
// spearman $antro $resp if grupo=="AF", stats(rho p) pw star(.05)
// spearman $desfecho $resp if grupo=="AF", stats(rho p) pw star(.05)

// Avaliar função pulmonar

swilk $funpul

**# AF #1
// ##AF
// // Comparação das características sociodemográficas entre os grupos
dtable i.sexo  $sociodemograficos if grupo=="AF" | grupo=="Controle", by(grupo, tests ) continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(pearson)) title("Tabela 1. Comparação das características entre os grupos.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(af_tab1f.docx, replace) 

// Comparação das características pulmonares
//
// dtable $funpul if grupo=="AF" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(af_tab2.docx, replace)
dtable $funpul if grupo=="AF" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis)) nformat(%9.2f)    export(af_tab2f.docx, replace)

// Comparação dos dados do Frênico
//
// dtable $frenico if grupo=="AF" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(af_tab3.docx, replace)
dtable $frenico if grupo=="AF" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis))  nformat(%9.2f)  export(af_tab3f.docx, replace)



// Relação de CVF,VEF1, vef1cvf e PFE  com as escalas SARA e ICARS


spearman idade tempodoença $resp  if grupo=="AF", stats(rho p) pw star(.05)
spearman peso altura imc $resp  if grupo=="AF", stats(rho p) pw star(.05)
spearman circcervicalcm circabdomcm $resp  if grupo=="AF", stats(rho p) pw star(.05)
spearman sara icars $resp  if grupo=="AF", stats(rho p) pw star(.05)

spearman sara icars if grupo=="AF", stats(rho p)
scatter sara icars if grupo=="AF", ytitle("SARA") ylabel(0(10)100, nogrid) xlabel(0(10)100, nogrid)  xtitle("ICARS") note("Spearman: rho = 0,90; p<0,01")
graph export  "saraicarsaf.png", replace






**# SCA2 #2

// Comparação das características sociodemográficas entre os grupos
dtable i.sexo  $sociodemograficos if grupo=="SCA2" | grupo=="Controle", by(grupo, tests ) continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(pearson)) title("Tabela 1. Comparação das características entre o grupo controle e SCA2.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(sca2_tab1f.docx, replace) 

// Comparação das características pulmonares
//
dtable $funpul if grupo=="SCA2" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis)) nformat(%9.2f)    export(sca2_tab2f.docx, replace)

// Comparação dos dados do Frênico
dtable $frenico if grupo=="SCA2" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis))  nformat(%9.2f)  export(sca2_tab3f.docx, replace)


// #Correlações
spearman idade tempodoença $resp  if grupo=="SCA2", stats(rho p) pw star(.05)
spearman peso altura imc $resp  if grupo=="SCA2", stats(rho p) pw star(.05)
spearman circcervicalcm circabdomcm $resp  if grupo=="SCA2", stats(rho p) pw star(.05)
spearman sara icars $resp  if grupo=="SCA2", stats(rho p) pw star(.05)

replace sara = . if sara==0
spearman sara icars if grupo=="SCA2", stats(rho p)
scatter sara icars if grupo=="SCA2" & sara > 0, ytitle("SARA") ylabel(0(10)100, nogrid) xlabel(0(10)100, nogrid)  xtitle("ICARS") note("Spearman: rho = 0,86; p<0,01")
graph export  "saraicarssca2.png", replace




**# SCA3 #2

// Comparação das características sociodemográficas entre os grupos
dtable i.sexo  $sociodemograficos if grupo=="SCA3" | grupo=="Controle", by(grupo, tests ) continuous(,test(kwallis)) nformat(%9.2f)  factor(,test(pearson)) title("Tabela 1. Comparação das características entre o grupo controle e SCA3.") note("Teste de Mann-Whitney para variáveis quantitativas") note(Teste de Qui-quadrado para variáveis qualitativas) sample(, place(seplabels)) export(SCA3_tab1f.docx, replace) 

// Comparação das características pulmonares
//
dtable $funpul if grupo=="SCA3" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis)) nformat(%9.2f)    export(SCA3_tab2f.docx, replace)

// Comparação dos dados do Frênico
dtable $frenico if grupo=="SCA3" | grupo=="Controle", by(grupo, tests )continuous(,test(kwallis))  nformat(%9.2f)  export(sca3_tab3f.docx, replace)


// #Correlações
spearman idade tempodoença $resp  if grupo=="SCA3", stats(rho p) pw star(.05)
spearman peso altura imc $resp  if grupo=="SCA3", stats(rho p) pw star(.05)
spearman circcervicalcm circabdomcm $resp  if grupo=="SCA3", stats(rho p) pw star(.05)
spearman sara icars $resp  if grupo=="SCA3", stats(rho p) pw star(.05)
spearman sara icars if grupo=="SCA3", stats(rho p)
scatter sara icars if grupo=="SCA3" , ytitle("SARA") ylabel(0(10)100, nogrid) xlabel(0(10)100, nogrid)  xtitle("ICARS") note("Spearman: rho = 0,96; p<0,01") 
graph export  "saraicarssca3.png", replace






i
// #Resumo congresso
spearman $demograficos $resp if grupo=="SCA2", stats(rho p)  pw star(.05)
spearman $antro $resp if grupo=="SCA2", stats(rho p) pw star(.05)

spearman $desfecho $resp if grupo=="SCA2", stats(rho p) pw star(.05)


// Comparação das características pulmonares

dtable $funpul if grupo=="SCA2" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(sca2_tab2.docx, replace)


i
// Relação de CVF,VEF1, vef1cvf e PFE  com as escalas SARA e ICARS

spearman sara icars  $resp if grupo=="SCA2", stats(rho p)
spearman sara icars  $frenico if grupo=="SCA2", stats(rho p)


// Comparação dos dados do Frênico

dtable $frenico if grupo=="SCA2" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(sca2_tab3.docx, replace)


spearman sara icars if grupo=="SCA2", stats(rho p)
scatter sara icars if grupo=="SCA2", ytitle("SARA") ylabel(0(10)100, nogrid) xlabel(0(10)100, nogrid)  xtitle("ICARS") note("Spearman: rho = 0,84; p<0,01")
graph export  "saraicarssca2.png", replace


**# SCA3 #3

// Comparação das características sociodemográficas entre os grupos
dtable  i.sexo $sociodemograficos if grupo=="SCA3" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(sca3_tab1.docx, replace)

// Comparação das características pulmonares

dtable $funpul if grupo=="SCA3" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(sca3_tab2.docx, replace)


// Comparação dos dados do Frênico

dtable $frenico if grupo=="SCA3" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f)  export(sca3_tab3.docx, replace)


// Relação de CVF,VEF1, vef1cvf e PFE  com as escalas SARA e ICARS

spearman sara icars  $resp if grupo=="SCA3", stats(rho p)
spearman sara icars  $frenico if grupo=="SCA3", stats(rho p)
 

spearman sara icars if grupo=="SCA3", stats(rho p)
// scatter sara icars if grupo=="SCA3", ytitle("SARA") ylabel(0(10)100, nogrid) xlabel(0(10)100, nogrid)  xtitle("ICARS") note("Spearman: rho = 0,96; p<0,01")
// graph export  "saraicarssca3.png", replace

// #Resumo congresso
spearman $demograficos $resp if grupo=="SCA3", stats(rho p)  pw star(.05)
spearman $antro $resp if grupo=="SCA3", stats(rho p) pw star(.05)
spearman $desfecho $resp if grupo=="SCA3", stats(rho p) pw star(.05)

i

spearman $funpul $demograficos, stats(rho p)
spearman $funpul $antropometricos, stats(rho p)

// Quero que você verifique se a CVF,VEF1 e PFE têm relação com as escalas SARA e ICARS.
global funpul2 cvf vef1 vef1cvf pfe pimax lipimax pimsent pimsup tempodoença
 bysort grupo:  spearman  sara icars $funpul2, stats(rho p )

 spearman  sara icars cvf vef1 vef1cvf pfe pimax lipimax pimsent pimsup tempodoença if grupo=="Controle", stats(rho p )
 
 spearman sara icars  $frenico if grupo=="SCA2", stats(rho p)

// Trabalhar com as 4 (cvf, vf1, tiffenou, pfe) variáveis, a normalidade, o predito, o percentual do predito

i


// A Pi e o tempo de doença também imagino que se correlacionem com as escalas de ataxia. 
// A SARA e a ICARS são as mais indicadas para analisar a ataxia, isso é visto na maioria dos estudos

i


i

swilk $funpul
dtable $funpul if grupo=="AF" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f) 
dtable $funpul if grupo=="SCA2" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f) 
dtable $funpul if grupo=="SCA3" | grupo=="Controle", by(grupo, tests ) nformat(%9.2f) 

4.1.	Principais:
•	Avaliar a função pulmonar dos indivíduos com diagnóstico de ataxias espinocerebelares (SCA) 2,3 e ataxia de Friedreich através de testes de função respiratória e condução de nervo frênico.



•	Identificar quais pacientes apresentam maior risco de desenvolverem insuficiência ventilatória.


4.2.	Secundários:
•	Correlacionar os dados da avaliação respiratória com dados demográficos (idade, idade de início, tempo de duração da doença), dados antropométricos (peso, altura, IMC, circunferência cervical e abdominal) e os dados das escalas SARA (Anexo 2) e ICARS (Anexo 3)


 