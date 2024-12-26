import excel "bdCeanny.xlsx", firstrow clear

drop if A==.
// destring Gasto, gen(gasto_)
// drop Gasto
// rename gasto_ Gasto

gen gasto = Gasto>0 & Gasto<.
tab gasto

// swilk Gasto
// reg Gasto 
//
//
// global vari Idade Sexo HAS DIA DoençasRespiratório Câncer SMental AVC DoençaCardíaca Infarto Hansen
// tab1 $vari
//
// recode Salár 6=0
// recode RenFam 6=0
// 
// reg Gasto Salár
// reg Gasto RenFam
//
// reg Gasto i.Estacivil
// qreg Gasto i.Estacivil
// replace Gasto = . if Gasto>4000
// Gráfico que faz muitas correlações ao mesmo tempo
// mrunning Gasto $vari
lab define GastoRemédiopatologia 1"Diabetes" 2"HAS" 3"DIA e HAS" 4"Depressão" 5"Câncer"
lab val GastoRemédiopatologia GastoRemédiopatologia

lab define Gastoconsultaespecialidade 1"Cardiologia" 3"Endocrinologia" 4"Psiquiatria" 5"Fisioterapia" 6"Neurologia" 7"Oftalmologia" 8"Reumatologia"
lab val Gastoconsultaespecialidade Gastoconsultaespecialidade

replace GastoRemédiopatologia = . if GastoRemédiopatologia ==0
replace Gastoconsultaespecialidade = . if Gastoconsultaespecialidade ==0
tab1 GastoRemédiopatologia Gastoconsultaespecialidade
//
graph bar (percent), over(GastoRemédiopatologia) ytitle("Percentual %") blabel(bar, format (%9,0f))ylabel(0(10)100) title("Percentual de patologias com gastos fora de cobertura")
graph export gasto_patologia.png, replace
 graph save grafico1, replace


recode Gastoconsultaespecialidade 10 =.
graph bar (percent), over(Gastoconsultaespecialidade) ytitle("Percentual %") blabel(bar, format (%9,0f))ylabel(0(10)100) hor title("Percentual de especialidades com gastos fora de cobertura")
graph export gasto_especialidade.png, replace
graph save grafico2, replace

 graph combine grafico1.gph grafico2.gph, replace
i


swilk Gasto
global desfechos DIA HAS DoençasRespiratório Câncer SMental AVC DoençaCardíaca Infarto Hansen
foreach i in $desfechos{
	reg Gasto `i'
	
}