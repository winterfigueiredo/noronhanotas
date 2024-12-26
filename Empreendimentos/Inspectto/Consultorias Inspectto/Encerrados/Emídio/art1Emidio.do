// import delimited "bdEmidio.csv", delimiter(";") encoding(utf8) clear
// //
// //
// // // COMPORTAMENTOS DE RISCO RELACIONADOS
// // // A BEBIDAS ALCOÓLICAS E OUTRAS SUBSTÂNCIAS
// //
// //
// // // // 204a. Após ter bebido a ponto de ficar embriagado/a, ou após ter usado alguma outra droga
// // // // (como, por exemplo, maconha, cocaína ou solventes), você alguma vez teve relação sexual com
// // // // parceira(o) nova(o), recente, ou desconhecida(o)? q1 Não; q2 Sim.
// // // replace q204a = "" if q204a=="777"
// // // replace q204a = "" if q204a=="999"
// // // tab q204a
// // // // 204b. Se sim, foi:
// // // // q Sem uso de preservativo; q Com uso de preservativo
// // // replace q204b1 = "" if q204b1=="777"
// // // replace q204b1 = "" if q204b1=="999"
// // // tab q204b1
// // // // 228. Quando você tem (ou teve) relação sexual com parceiro(a) novo(a) (primeiros contatos),
// // // // você usa preservativo?
// // // // q1 Nunca; q2 Às vezes; q3 Sim, sempre.
// // // replace q228 = "" if q228=="777"
// // // replace q228 = "" if q228=="999"
// // // tab q228
// // // // 229. Quando você tem (ou teve) relação sexual com parceiro(a) fixo, você usa preservativo?
// // // // q1 Nunca; q2 Às vezes; q3 Sim, sempre.
// // // replace q229 = "" if q229=="777"
// // // replace q229 = "" if q229=="999"
// // // tab q229
// // *q2
// // global variaveis q1  q3grup1 q204a q204b1 q228  areacursonossa q8ax q7grup3 q9axgrup1  campusgrup2 q12 q13agrup2 escoreabepmãeagrupado2 q19a q39um q44a q49a q55a  q84a q120a q128a q148 q164 q165
// //
// // tab1 $variaveis
// // foreach i in $variaveis {
// // 	replace `i' = "" if `i' =="777"
// // 	replace `i' = "" if `i' =="999"
// // }
// //
// // replace q1 = "" if q1=="3"
// // tab1 $variaveis
// //
// // encode q3grup1, gen (q3)
// // tab q3, nolab
// // recode q3 1 = .
// // drop q3grup1
// //
// // encode q165, gen (q165ok)
// // tab q165ok, nolab
// // recode q165ok 1 = .
// //
// //
// // encode escoreabepmãeagrupado2, gen (escoreabep)
// // tab escoreabep, nolab
// // recode escoreabep 1 = .
// //
// //
// //
// // recode q2 999 = .
// //
// // global modificar q7grup3 q9axgrup1  campusgrup2 q12  q13agrup2
// //
// // foreach i in $modificar{
// // 	encode `i' , gen(`i'cod)
// // 	tab `i'cod, nolab
// // 	recode `i'cod 1 = .
// // }
// //
// // tab1 $modificar
// //
//
// // Qualidade de vida: 58, 59, 83
// // Religião/espiritualidade: 108a, 109a, 110a
// // Sono: 136, 137
// // Pensamentos suicidas: 141a, 142a
// // Comportamento de autolesao: 148, 
// // Visão e valores de mundo: 206, 207*
// //
//
// global qualidadedevida escorewhoqoldomfísico escorewhoqoldompsicológico escorewhoqoldomsocial escorewhoqoldomambiental
//
//
//  global selecionados  q1 q2 q3grup1 q204a q204b1 q228  areacursonossa q8ax  q85a1prov   q7grup3 q9axgrup1 campusgrup2 q12 q13agrup2  escoreabepmãeagrupado2 q19a q39um q44a q49a q55a  q84a q120a q128a q148 q164 q165 q231agrup1 q108a1 q108a2 q108a3 q108a4 q108a5 q109a  q110a  q136 q137grup q137 q141a q142a q148 q206grup1 q207agrup2 q207bgrup2 q207cgrup2 q207dgrup2 q207egrup2 q207fgrup2 q207ggrup2 $qualidadedevida
//
//
//
// //
//  tab1 $selecionados
//
// //
//  keep $selecionados
// export excel using "bdEmidio.xlsx", firstrow(variables)

// save  "bdErmidio.dta", replace
//

import excel "bdEmidio.xlsx", firstrow clear
*keep q1 q2 q3grup1
*Descrever o perfil de acadêmicos que apresentam comportamento sexual de risco após uso de álcool/drogas;
 encode q1, gen(sexo)
drop q1
rename q2 idade
rename  q7grup3 estado_civil

encode   q8ax, gen( moradia)
drop q8ax
renam q12 filho_adotivo

encode  q120a , gen( atividade_fisica)
drop q120a
encode q128a , gen( prob_mental)
drop q128a
rename q13agrup2  moradia_compart
// gen morar_só = 0 if moradia_compart!=.
// replace morar_só = 1 if moradia_compart==4 


encode q148 , gen( autolesão )
drop q148
encode q164 , gen( tipo_relacionamento)
drop q164
rename q165 tipo_relacionamento_preferido

encode q19 , gen( possui_carro)
drop q19
encode q204a , gen( rel_sexual_pos_bebida)
drop q204a
encode q204b1, gen(uso_preserv_pos204a)
drop q204b1
encode q228 , gen(uso_pres_parc_novo)
drop q228
encode  q39um , gen(uso_medicamento_estudar)
drop q39um
encode q44a, gen( trabalha)
drop q44a
encode q49a , gen(bolsista)
drop  q49a
encode  q55a, gen( apoio_na_faculdade)
drop q55a
encode q84a , gen(violencia_grave)
drop q84a
rename q9axgrup1 relac_pais
encode q231agrup1, gen(orientSexual)
drop q231agrup1

*Removendo os missings das variáveis quantitativas
global quanti idade escorewhoqoldomfísico escorewhoqoldompsicológico escorewhoqoldomsocial escorewhoqoldomambiental

foreach i in $quanti{
recode  `i' 999=.
}
 
*Qualidade de vida


global qv escorewhoqoldomfísico escorewhoqoldompsicológico escorewhoqoldomsocial escorewhoqoldomambiental

su $qv


*Comportamento de risco
recode uso_preserv_pos204a 1 = 2
recode uso_pres_parc_novo 1 = 2
gen risco = 999 if uso_preserv_pos204a==2 | uso_pres_parc_novo==2
replace risco = 0 if uso_preserv_pos204a==4 | uso_pres_parc_novo==4
replace risco = 1  if uso_preserv_pos204a==3 | uso_pres_parc_novo==3  | uso_pres_parc_novo==5
lab define risco  0"Não" 1"Sim"
lab val risco risco 
tab risco


gen faixaetaria = 0 if idade<20
replace faixaetaria = 1 if idade>=20 & idade<.
lab define faixaetaria 0"Até 20" 1"20+"
lab val faixaetaria faixaetaria


*drop if risco==.


// variaveis sobre quem são, depois sobre como vivem e pensam, depois sobre como sofrem.


su idade if idade<70,d
tab sexo if sexo>2

****ARTIGO 1
*quem são
table1_mc,  vars( sexo cat\ orientSexual cat\estado_civil  cat\ escoreabep cat\ filho_adotivo cat\atividade_fisica cat\ faixaetaria cat\ areacursonossa cat\ risco cat\)  format(%2,1f) percf(%2,1f) onecol saving(a1tab1.xlsx, replace)


 *depois sobre como vivem e pensam
 table1_mc,  vars(campusgrup2  cat\ moradia_compart cat\possui_carro cat\ trabalha cat\ bolsista cat\ apoio_na_faculdade cat\ tipo_relacionamento cat\ tipo_relacionamento_preferido cat \ uso_preserv_pos204a cat\ uso_pres_parc_novo cat\ risco cat\ escorewhoqoldomfísico contn \ escorewhoqoldompsicológico  contn \ escorewhoqoldomsocial  contn \  escorewhoqoldomambiental  contn \ )format(%2,1f) percf(%2,1f) onecol saving(a1tab2.xlsx, replace)
 
 *religião
 foreach i in q108a1 q108a2 q108a3 q108a4 q108a5 q109a q110a q137grup q136  q206grup1 q207agrup2 q207bgrup2 q207cgrup2 q207dgrup2 q207egrup2 q207fgrup2 q207ggrup2{
	replace `i' = "" if `i'== "777"
	replace `i' = "" if `i'== "999"
	replace `i' = "" if `i'== " "
 }
 table1_mc,  vars( q108a1 cat\  q108a2 cat\  q108a3 cat\  q108a4 cat\  q108a5 cat\  q109a cat\  q110a cat\  q136 cat\ q137grup cat\ q206grup1  cat\ q207agrup2  cat\ q207bgrup2  cat\ q207cgrup2  cat\ q207dgrup2  cat\ q207egrup2  cat\ q207fgrup2  cat\ q207ggrup2  cat\ )format(%2,1f) percf(%2,1f) onecol saving(visão.xlsx, replace)
 
 
 *como sofrem
//  table1_mc,  vars( escorewhoqoldomfísico escorewhoqoldompsicológico escorewhoqoldomsocial escorewhoqoldomambiental \)format(%2,1f) percf(%2,1f) onecol saving(a1tab2.xlsx, replace)
 
 *Qualidade de vida, religião e espiritualidade, sono, pensamento suicida.
//  Com a nova classificação de risco incluindo os missings, atualizar as tabelas de acordo
// com o artigo de referência
 
 *Perfil dos que apresentam CSR
keep if risco==1
table1_mc,  vars( sexo cat\ orientSexual cat\estado_civil  cat\ escoreabep cat\ filho_adotivo cat\atividade_fisica cat\ faixaetaria cat\ areacursonossa cat\ risco cat\)  format(%2,1f) percf(%2,1f) onecol saving(a1tab1risco.xlsx, replace)

 table1_mc,  vars(campusgrup2  cat\ moradia_compart cat\possui_carro cat\ trabalha cat\ bolsista cat\ apoio_na_faculdade cat\ tipo_relacionamento cat\ tipo_relacionamento_preferido cat \ uso_preserv_pos204a cat\ uso_pres_parc_novo cat\ risco cat\)format(%2,1f) percf(%2,1f) onecol saving(a1tab2risco.xlsx, replace)

 *depois sobre como vivem e pensam
 table1_mc,  vars(campusgrup2  cat\ moradia_compart cat\possui_carro cat\ trabalha cat\ bolsista cat\ apoio_na_faculdade cat\ tipo_relacionamento cat\ tipo_relacionamento_preferido cat \ uso_preserv_pos204a cat\ uso_pres_parc_novo cat\ risco cat\)format(%2,1f) percf(%2,1f) onecol saving(a1tab2.xlsx, replace)
 
 *Crenças, valores sociais e visão de mundo 
  table1_mc,  vars( q108a1 cat\  q108a2 cat\  q108a3 cat\  q108a4 cat\  q108a5 cat\  q109a cat\  q110a cat\  q136 cat\ q137grup cat\ q206grup1  cat\ q207agrup2  cat\ q207bgrup2  cat\ q207cgrup2  cat\ q207dgrup2  cat\ q207egrup2  cat\ q207fgrup2  cat\ q207ggrup2  cat\ )format(%2,1f) percf(%2,1f) onecol saving(visão2.xlsx, replace)
 
 su $qv
i
 
 
**Fatores associados
table1_mc,  by(risco) vars( sexo cat\ orientSexual cat\estado_civil  cat\ escoreabep cat\ filho_adotivo cat\atividade_fisica cat\ faixaetaria cat\ areacursonossa cat\ risco cat\)  format(%2,1f) percf(%2,1f) onecol saving(a1tab1.xlsx, replace)


tab1 $exposição
tab1 $desfecho
tab risco



foreach i in $exposição{
	tab  `i' risco, row exact
}


global socio sexo relac_pais estado_civil autolesão prob_mental trabalha
global univers morar_só campusgrup2cod tipo_relacionamento_preferido   apoio_na_faculdade  uso_medicamento_estudar 

sw, pe(0.05) pr(0.2): logistic risco $socio idade
sw, pe(0.05) pr(0.2): logistic risco $univers
sw, pe(0.05) pr(0.2): logistic risco $exposição


**ARTIGO 2
// Comportamento sexual de risco está associado a estupro, violência grave ou doenças mentais?


global desfecho2  prob_mental  autolesão violencia_grave

foreach i in $desfecho2 {
tab risco `i' , row exact
logistic risco `i' 

}



 
 