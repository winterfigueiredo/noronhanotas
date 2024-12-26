set more off
use "C:\bancos\ano19.dta", replace
//Características sociodemográficas
drop ANO_CMPT
drop if SEXO=="0"
drop if MUNIC_RES==""
encode SEXO, gen(sex)
lab define sexo 1"Masculino" 3"Feminino"
tab sex
i

rename MES_CMPT mês

//Variáveis do indivíduo
global quali sexo
global quanti 
//Variáveis da internação
rename UTI_MES_TO dias_uti_mês
rename UTI_INT_TO diarias_unidade_intermediaria
rename PROC_REA procedimento
destring QT_PROC, gen(num_procedimentos)

gen dataAtend = date(DT_ATEND, "DMY")
format  %tdDD/NN/CCYY dataAtend

gen dataSaida = date(DT_SAIDA, "DMY")
format  %tdDD/NN/CCYY dataSaida


//Variáveis do serviço
gen gastrectomia_videolaparoscopica = regex(procedimento, "0407010157")
//e66.9 - Oclusão e estenose

gen caProstata  = regex(DIAG_PRINC, "C61")
destring DIAS_PERM, gen(diaspermanencia)
tab procedimento if caProstata==1, sort
