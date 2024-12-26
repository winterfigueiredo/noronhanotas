import excel "bdFiorettiOk.xlsx", firstrow clear
// encode sexo, gen (Sex)
// Precisa corrigir:
// Sexo tem um G
// Limitando se pcr <=10
drop if PCR>10
lab define sexo 0"Masculino" 1"Feminino"
lab val sexo sexo

lab define sn 0"Não" 1"Sim"
lab val has dm tab dislip sn



lab define usg 0"Normal" 1"Doença Carotídea"
lab val USG usg 

lab define estenose 0"Ausência" 1"Espessamento" 2"Estenose <50%" 3"Estenose 50-69%" 4"Estesone >70%" 5"Sub-oclusão"
lab val Estenose estenose

swilk idade glic trig TyG PCR HDL PCRHDL
// Criando número de fatores de risco
egen nfr = rowtotal(tab  dislip   has    dm)


// dtable idade i.sexo i.has i.dm i.tab i.dislip i.USG i.Estenose , export(table1.docx, 			replace)  define(meansd = mean sd, delimiter(" ± ")) 			define(myiqr = p25 p75, delimiter("-")) 	 continuous(idade glic 	trig TyG PCR HDL PCRHDL , stat(meansd))	nformat(%6.1f 	mean sd) sformat("%s"sd)
//
//
// dtable i.has i.dm i.tab i.dislip i.USG i.Estenose , by(sexo, test) export(table2.docx, replace)  define(meansd = mean sd, delimiter(" ± ")) 			define(myiqr = p25 p75, delimiter("-")) 	 continuous(idade glic 	trig TyG PCR HDL PCRHDL , stat(meansd))	nformat(%6.1f 	mean sd) sformat("%s"sd) replace
//
// // Observar relação do TyG com doença carotídea (USG)
// swilk TyG
// ranksum TyG, by(USG)
// // Verificar o valor de 2,49 para o TyG do grupo Doença Carotídea
// // graph box TyG, over(USG) note("Mann-Whitney, p<0,01")
// // graph export "tyg_doenca_carotidea.png"
//
// // Observar a relação do índice de HDL/PCR com doença carotídea
// swilk  PCRHDL
// ranksum PCRHDL, by(USG)
// // Verificar se é normal pcrhdl acima de 200 nos dois grupos 
// // graph box PCRHDL, over(USG) note("Mann-Whitney, p=0,02")
// // graph export "pcrhdl_gravidade.png"
//
// // Determinar sensibilidade e especificidade do TyG para diagnóstico de doença carotídea
// //
gen tyg = round(TyG, 0.1)
// roctab  USG TyG, sum detail
roctab  USG tyg, sum  detail

// roctab USG tyg, d g  caption("AUC = 0,62 (IC 95% 0,60; 0,64)") note("")

// // 5,76 tem melhores lr+ e lr- , ambos iguais a 1
//
// roctab  USG tyg, g note("AUC 0,61 (IC 95% 0,59 a 0,62)")
// graph export roctYg.png, replace
// // Variáveis segundo doença
// dtable i.sexo i.has i.dm i.tab i.dislip i.Estenose , by(USG, test) export(table3.docx, replace)  define(meansd = mean sd, delimiter(" ± ")) 			define(myiqr = p25 p75, delimiter("-")) 	 continuous(idade glic 	trig TyG PCR HDL PCRHDL , stat(meansd))	nformat(%6.1f 	mean sd) sformat("%s"sd)
//
// // #Determinar a gravidade da doença com TyG
qreg tyg i.Estenose
margins Estenose
marginsplot , ytitle("TyG mediana (IC 95%)") xlabel( 0"Ausência" 1"Espessamento" 2"Estenose<50%" 3"Estenose 50-69%" 4"Estenose >70%" 5"Sub-oclusão") caption("Kruskal-Wallis, p<0,01")
// graph export "tyg_gravidade.png", replace

//
//
// bysort Estenose: centile tyg
// kwallis tyg, by(Estenose)
//
// // Determinar se associação de um ou mais fatores de risco com TyG é capaz de prever a USG
global quali sexo has dm tab dislip 
global quanti idade glic trig PCR HDL PCRHDL
// foreach i in $quali{
// 	desc `i'
// 	ranksum tyg, by(`i')
// }
// foreach i in $quanti{
// 	desc `i'
// 	spearman tyg `i'
// }
//
// qreg tyg $quali $quanti
// predict tygAdj
//
// sw, pr(0.2) pe(0.05): qreg tyg $quali $quanti
//
// qreg tyg idade trig HDL glic PCR
// predict tygAdj2
//
// qreg tyg idade  HDL  PCR
// predict tygAdj3
// format tygAdj3 %2.1g
// recast double tygAdj3
//
// gen tyg3adj = round(tygAdj3, 0.1)
//
// // roctab USG tyg, detail
// // roctab USG tyg3adj, detail
// // roccomp USG tyg tyg3adj, graph   summary legend(on)
// // rocgold USG tyg tyg3adj, sidak graph summary caption("TyG: AUC = 0,62 (IC 95% 0,60; 0,65)""TyG ajustada por idade, PCR e HDL: AUC = 0,68 (IC 95% 0,66; 0,70)""Bonferroni-adjusted p-value <0,01") 
// // graph export "roc_comp_tyg_tygaj.png", replace

gen tygcat = tyg> 4.6 if tyg!=.
logistic USG  i.tygcat
logistic USG  i.tygcat i.nfr  sexo idade 

// // 4.	Determinar sensibilidade e especificidade do HDL/PCR para diagnóstico de doença carotídea.
gen pcrhdl = round(PCRHDL, 0.1)
replace  pcrhdl = . if pcrhdl>272
// // roctab USG pcrhdl, d g  caption("AUC = 0,53 (IC 95% 0,50; 0,55)") note("")
// graph export rocPcrHdl.png, replace
//
// roctab USG pcrhdl, d

//
//
// // Relação da Gravidade da doença com pcrhdl
// qreg pcrhdl i.Estenose  nfr
// kwallis pcrhdl , by(Estenose)
// // margins Estenose
// // marginsplot , ytitle("PCR/HDL mediana (IC 95%)") xlabel( 0"Ausência" 1"Espessamento" 2"Estenose<50%" 3"Estenose 50-69%" 4"Estenose >70%" 5"Sub-oclusão") caption("Kruskal-Wallis, p=0,09")
//
//
//
global quali2 sexo has dm tab dislip 
global quanti2 idade glic trig 
sw, pr(0.2) pe(0.05): qreg pcrhdl $quali2 $quanti2
predict pcrhdladj
gen pcrhdladjs = round(pcrhdladj, 0.1)
qreg  pcrhdl sexo has glic trig dislip

// roctab USG pcrhdladj
// roctab USG pcrhdl


 rocgold USG pcrhdl pcrhdladjs, sidak graph summary caption("PCR/HDL: AUC = 0,61 (IC 95% 0,58; 0,63)""PCR/HDL ajustada por idade, sexo e número de fatores de risco: AUC = 0,53 (IC 95% 0,50; 0,55)""Bonferroni-adjusted p-value <0,01") 
 graph export fig6.png, replace
k
gen pcrhdl_cat = pcrhdl>2 if pcrhdl!=.
tab pcrhdl_cat
sw, pr(0.2) pe(0.05): logistic USG pcrhdl_cat $quali2 $quanti2
// logistic USG pcrhdl_cat $quali2 $quanti2
logistic USG pcrhdl_cat idade sexo

gen pcrhdl_cat2 = pcrhdl>4.1 if pcrhdl!=.
logistic USG pcrhdl_cat2 i.nfr idade i.sexo
// sw, pr(0.2) pe(0.05): logistic USG pcrhdl_cat2 $quali2 $quanti2
tabodds   USG pcrhdl_cat2
tabodds   USG nfr
tabodds   USG sexo

tab  pcrhdl_cat2 Estenose , row exact

tab  tygcat Estenose , row exact
