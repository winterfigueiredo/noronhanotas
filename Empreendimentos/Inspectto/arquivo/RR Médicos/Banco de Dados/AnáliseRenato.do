set more off
capture log close
use  "C:\Users\Winter\Google Drive\Empreendimentos\Inspectto\RR Médicos\Banco de Dados\bancoRenato.dta", replace

drop NATUREZA ANO_CMPT COD_IDADE NASC
destring IDADE, gen(idade)
drop IDADE
destring DIAS_PERM, gen(diaspermanencia)
drop DIAS_PERM

destring UTI_INT_TO, gen(tempouti)
drop UTI_INT_TO

destring  QT_PROC, gen(qtProcedimento)
drop QT_PROC

encode MORTE, gen(obito)

lab define grupo 0"Sleeve" 1"Videolap"
lab val grupo grupo
tab grupo
tab grupo obito, row chi2

gen uti  = 0 if tempouti==0
replace uti=1 if tempouti>0 & tempouti<.
lab val uti sn

encode SEXO, gen(sexo)
tab sexo


lab define sn 0"Não" 1"Sim"


//MODALIDADE
i


*COBRANCA

*REGIÃO - CRIADA A PARTIR DO MUN. DE RESIDÊNCIA
encode  MUNIC_RES, gen(munic)
tab munic, nolab
gen região = 0 if munic<=11
replace região=1 if munic>11 & munic<.
lab define região 0"Sudeste"1"Sul"
lab val região região
tab região

//Desfechos
	*Idade
	 swilk idade
	 bysort grupo: centile idade
	 ranksum idade, by(grupo)
	*Sexo
	tab sexo grupo, row chi2
	*região
	tab região grupo, row chi
	* tempo de internação
	 bysort grupo: centile diaspermanencia
	 ranksum diaspermanencia, by(grupo)
	*taxa de utilização da uti
	tab grupo uti, row chi2
	* dias na uti
	 bysort grupo: centile tempouti if tempouti>0
		 ranksum tempouti, by(grupo)
	*qt de procedimentos
	
	*Gestão
	tab grupo GESTAO, row chi2
	
	//CIDS:
	/*
	E66-OBESIDADE
	F668 - F668 Outros transtornos do desenvolvimento psicossexual 
	N736 -aderências pelviperitonais femininas
	R100 - abdome agudo
	Z008 -outros exames gerais
*/
encode  DIAG_PRINC, gen(diag)
tab diag
gen causa = 0 if diag<=4
replace causa =1 if diag>4 & diag<.
lab define causa 0"Obesidade" 1"Outros"
lab val causa causa 

tab grupo causa, row chi2

gen custo = 4095 * qtProcedimento if grupo==0
replace custo = 6145 * qtProcedimento  if grupo==1

bysort  MES_CMPT: su custo
encode MES_CMPT, gen(mes)
swilk custo
