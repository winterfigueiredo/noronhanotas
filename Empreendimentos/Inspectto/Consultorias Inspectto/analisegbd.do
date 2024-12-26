import excel "bdmiomas.xlsx", sheet("Planilha1") firstrow clear 

* Suponha que a variável original seja chamada "var_str"
* Removendo vírgulas
gen var_clean = subinstr(Value, ",", "", .)
* Convertendo a string limpa para um número
destring var_clean, gen(valor) 
drop var_clean Value Upper Lower

// Descrevendo o dado para o Brasil

// Prevalência
// Número de casos
list Year valor if Measure=="Prevalence" & Metric=="Number" & Age=="Age-standardized"

// Prevalência
bysort Location:   list Year valor if Measure=="Prevalence" & Metric=="Rate"  & Age=="Age-standardized" 
bysort Location:  su valor if Measure=="Prevalence" & Metric=="Rate"  & Age=="Age-standardized" 

bysort Location:   regress valor Year  if Measure=="Prevalence" & Metric=="Rate"  & Age=="Age-standardized" 

i
//Percentual em relação a todas as causas
list Year valor if Measure=="Prevalence" & Metric=="Percent"  & Age=="Age-standardized"

#Calcular o APC
#Calcular o AAPC