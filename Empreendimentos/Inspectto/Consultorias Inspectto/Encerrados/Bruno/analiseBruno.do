import excel "bdmetanalise.xlsx", sheet("meta2") firstrow clear
//
// cii prop
//
// gen p = sob5y/100
// gen stderr = sqrt(p*(1-p)/N)
// meta set sob5y  stderr, studysize(N)   random() studylabel(study) eslabel("Survival rate") 
//  meta forest ,  random(hedges) cibind(parentheses)  esrefline   subgroup(Intervention) nometashow

meta esize vivos5y Sample,  studylabel(study) esize(proportion) eslabel("5-year survival") 
meta forest _id  Sample _plot _esci _weight, esrefline  subgroup(Intervention)  random(reml) se() cibind() 

graph export "groups5ySurvival.tif",replace
i

 meta esize vivos3y Sample,  studylabel(study) esize(proportion) eslabel("3-year survival") 
meta forest _id  Sample _plot _esci _weight, esrefline  subgroup(Intervention)  random(reml) se() cibind() 
graph export "groups3ySurvival.tif",replace


 meta esize recurrence Sample,  studylabel(study) esize(proportion) eslabel("Recurrence  ") 
meta forest _id  Sample _plot _esci _weight, esrefline  subgroup(Intervention)  random(reml) se() cibind() 
graph export "groupsRecurrence.tif",replace
 
 
 // 
// import excel "bdmetanalise.xlsx", sheet("total") firstrow clear
//
// rename A study
// rename N Sample
// gen ndeaths = Sample - deaths
// gen nmorbidity = Sample - morbidity
//
//
// metan deaths nodeaths 
// j
// gen seClassic = sqrt(pClassic*(1-pClassic)/nclassic)

// //
// //
// //
// // #Metanálise da recorrência
// meta esize recurrence Sample,  studylabel(study)
// meta update, esize(proportion)
// meta forest _id recurrence Sample _plot _esci _weight, esrefline   subgroup(desenho) 
// graph export "recurrence.tif",replace
//
// meta funnelplot
// graph export "recurrence_bias.tif", replace
// i

// //
// //
// // // Mortalidade
// // meta esize deaths Sample,  studylabel(study)
// // meta update, esize(proportion)
// // meta forest _id deaths Sample _plot _esci _weight, esrefline   subgroup(desenho) 
// // graph export "mortality.tif",replace
// //
// // meta funnelplot
// // i
//
// graph export "mortality_bias.tif", replace
// // Como colocar os valores em escala na metanálise?
// i
// //  meta forestplot, random(reml) proportion cibind()  scale(100)	
// // //  meta funnelplot
//
// // Morbidade
// meta esize morbidity N, studylabel(study)
//
// // Mortalidade
// meta esize deaths N, studylabel(study)
// meta update, esize(proportion)
// meta forest _id _data _plot _esci _weight, proportion esrefline  subgroup(desenho) 
// i
// // Coletar o tempo de seguimento de cada estudo para curva de sobrevida
// // Analisar os objetivos para propor as metanalises
// 
// //  Analisando a sobrevida global
//  stset followup_meses, failure(deaths)
//  sts graph
// 
// // 
// // Estatística Q calcula probabilidade de heterogeneidade entre os estudos (heterogeneidade se p>=0,05)
// //  Incosistência nos efeitos das intervenções foram avaliadas pelo teste de I²;
// //  Efeitos aleatórios foram usados quando I²>50 (presença de heterogeneidade)
// //  efeitos fixos quando I²<=50 (ausência de heterogeneidade)
// // I²: até 25% - baixa; 50% moderada e 75% alta
//
// // Uso da g de Hedges ajustada para calcular proporção do efeito de cada estudo
// 	a magnitude segundo a convenção de Cohen é pequena(0,2), média(0,5) ou extensa(0,8)
//
// //  Funnel plot para avaliação do viés de publicação
//



// Análise comparando as técnicas
// import excel "bdmetanalise.xlsx", sheet("novaMet") firstrow clear
//

// gen pClassic = sob5yclassic/100
// gen seClassic = sqrt(pClassic*(1-pClassic)/nclassic)
// gen sdClassic = seClassic * sqrt(nclassic)
//
//
//
// gen pReverse = sob5yreverse/100
// gen seReverse = sqrt(pReverse*(1-pReverse)/nreverse)
// gen sdReverse = seReverse * sqrt(nreverse)
//
// gen pCombined = sob5ycombined/100
// gen seCombined = sqrt(pCombined*(1-pCombined)/ncombined)
// gen sdCombined = seCombined * sqrt(ncombined)
//
// meta set sob5yclassic  seClassic,  random() studylabel(study) eslabel("Survival rate") studysize(nclassic)
//  meta forestplot, random(hedges) cibind(parentheses)  esrefline
//  k
// // Comparando sobrevida das técnicas Classic versus Reverse
//  meta esize nclassic sob5yclassic sdClassic nreverse sob5yreverse sdReverse, esize(hedgesg, exact) studylabel(study)
//  meta forestplot, random(hedges) cibind(parentheses)
//  i
// 
//
// meta esize recurrence sample,  studylabel(study)
// meta update, esize(proportion)
// meta forest _id recurrence sample _plot _esci _weight, esrefline   subgroup(grupo) 


// // Usando o ipdmetan
// import excel "bdmetanalise.xlsx", sheet("Planilha1") firstrow clear
// // stset followup_meses, failure(deaths) scale(1)
// gen mortos = sample - vivos
//
// meta esize   vivos  sample, esize(proportion) studylabel(Study) eslabel("Survival rate")
//
// meta forestplot _id year  sample _plot _esci _weight, random(reml) se() cibind() subgroup(grupo) esrefline 
// graph export "sobrevida5y_forest.tif", replace
//
// meta bias if grupo=="Classic", egger random(reml)
//
// meta funnelplot if grupo =="Classic"
// graph export "sobrevida5y_funnel.tif", replace
//
// gen norecurrence = sample - recurrence
//
//  meta esize recurrence sample, esize(proportion) studylabel(Study) eslabel("Recurrence") 
//
//
// meta forestplot _id year  sample _plot _esci _weight, random(reml) subgroup(grupo) proportion cibind(parentheses) esrefline 
// graph export "recurrence_forest.tif", replace
// meta bias if grupo =="Classic", egger random(reml)
// meta funnelplot if grupo =="Classic"
// graph export "recurrence_funnel.tif", replace
//
// // Análise de sensibilidade excluindo os estudos pequenos
// drop if regex(Study,"Tanaka et al.")
// drop if regex(Study,"Van der Pool et al.")
//
// meta forestplot _id year  sample _plot _esci _weight, random(reml) se() cibind() subgroup(grupo) esrefline 
// graph export "sens_sobrevida5y_forest.tif", replace
//
// meta bias if grupo=="Classic", egger random(reml)
//
// meta funnelplot if grupo =="Classic"
// graph export "sens_sobrevida5y_funnel.tif", replace
//
// gen norecurrence = sample - recurrence
//
//  meta esize recurrence sample, esize(proportion) studylabel(Study) eslabel("Recurrence") 
//
//
// meta forestplot _id year  sample _plot _esci _weight, random(reml) subgroup(grupo) proportion cibind(parentheses) esrefline 
// graph export "sens_recurrence_forest.tif", replace
// meta bias if grupo =="Classic", egger random(reml)
// meta funnelplot if grupo =="Classic"
// graph export "sens_recurrence_funnel.tif", replace

import excel "bdmetanalise.xlsx", sheet("total") firstrow clear

// 1y-survival 
 meta esize sob1y N, esize(proportion) random(hedges) studylabel(Study) eslabel(1-year Survival probability) nometashow 
 
meta forestplot _id  Year N N _plot _esci _weight, random(reml) se() cibind()  esrefline
graph export "survival_1y_forest.tif", replace

meta bias , egger random(reml)

meta funnelplot , caption("Egger test, p<0.01")
graph export "survival_1y_funnel.tif", replace


// 3y-survival 
 meta esize sob3y N, esize(proportion) random(hedges) studylabel(Study) eslabel(3-year Survival probability) nometashow 
 
meta forestplot _id  Year  N _plot _esci _weight, random(reml) se() cibind()  esrefline
graph export "survival_3y_forest.tif", replace
graph export "survival_3y_forest.svg", replace

meta bias , egger random(reml)
meta funnelplot , caption("Egger test, p=0.18")
graph export "survival_3y_funnel.tif", replace
graph export "survival_3y_funnel.svg", replace





// 5y-survival 
 meta esize sob5y N, esize(proportion) random(hedges) studylabel(Study) eslabel(5-year Survival probability) nometashow 
 
meta forestplot _id Year N _plot _esci _weight, random(reml) se() cibind()  esrefline
graph export "survival_5y_forest.tif", replace
graph export "survival_5y_forest.svg", replace

meta bias , egger random(reml)
meta funnelplot , caption("Egger test, p=0.42")
graph export "survival_5y_funnel.tif", replace
graph export "survival_5y_funnel.svg", replace


//  Recurrence
 meta esize recurrence N, esize(proportion) random(hedges) studylabel(Study) eslabel(R ecurrence probability ) nometashow 
 
meta forestplot _id  Year  N _plot _esci _weight, random(reml) se() cibind()  esrefline
graph export "recurrence_forest.tif", replace
graph export "recurrence_forest.svg", replace

meta bias , egger random(reml)
meta funnelplot , caption("Egger test, p=0.45") 
graph export "recurrence_funnel.tif", replace
graph export "recurrence_funnel.svg", replace






