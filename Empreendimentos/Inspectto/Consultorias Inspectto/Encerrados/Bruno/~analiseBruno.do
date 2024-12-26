import excel "bdmetanalise.xlsx", sheet("total") firstrow clear

rename A study
// #Metanálise da recorrência
// meta esize(proportion) recurrence N,  studylabel(study)

// #Estimando o risco relativo
meta esize recurrence N,  studylabel(study) 
meta update, esize(proportion)
meta forest _id _data _plot _esci _weight, esrefline 
// Como colocar os valores em escala na metanálise?

//  meta forestplot, random(reml) proportion cibind()  scale(100)	
// //  meta funnelplot

// Morbidade
meta esize morbidity N, studylabel(study)

// Mortalidade
meta esize deaths N, studylabel(study)
meta update, esize(proportion)
meta forest _id _data _plot _esci _weight, proportion esrefline 

// Coletar o tempo de seguimento de cada estudo para curva de sobrevida
// Analisar os objetivos para propor as metanalises
 
//  Analisando a sobrevida global
 stset followup_meses, failure(deaths)
 sts graph