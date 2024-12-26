set more off
capture log close
use "C:\Users\Winter\Google Drive\Empreendimentos\Inspectto\RR Médicos\Artigos\Giovanna\bdGiovanna.dta", replace
drop SEXO


 *2,264,804 registros
 * 995,478  homens excluídos
 *290,023 menores de 18 anos
  *6,309  internadas com diagnóstico de C53 ou C54
  *4785 sem histerectomia
  *1522 com histerectomia
  
*Serviço de transferência de arquivos
*Dados da RD- AIH Reduzidas
*Dados de todos os estados
*Selecionar população de estudo e controle
*Definir variáveis elegíveis
*Analisar os dados

/*
1 - 04.09.06.010-0 - HISTERECTOMIA (POR VIA VAGINAL)	
2 - 04.09.06.011-9 - HISTERECTOMIA C/ ANEXECTOMIA (UNI / BILATERAL)	
3 - 04.09.06.012-7 - HISTERECTOMIA SUBTOTAL	
4 - 04.09.06.013-5 - HISTERECTOMIA TOTAL	
5 - 04.09.06.014-3 - HISTERECTOMIA TOTAL AMPLIADA (WERTHEIN-MEIGS)	
6 -04.09.06.015-1 - HISTERECTOMIA VIDEOLAPAROSCOPICA	
7 - 04.09.06.029-1 - HISTERECTOMIA C/ ANEXECTOMIA BILATERAL E COLPECTOMIA SOB PROCESSO TRANSEXUALIZADOR	
8 - 0411020030 - HISTERECTOMIA PUERPERAL	
9 - 0416060056 - HISTERECTOMIA COM RESSECÇÃO DE ÓRGÃOS CONTÍGUOS EM ONCOLOGIA
10 - 0416060064 - HISTERECTOMIA TOTAL AMPLIADA EM ONCOLOGIA	
11 - 0416060110 - HISTERECTOMIA COM OU SEM ANEXECTOMIA (UNI / BILATERAL) EM ONCOLOGIA
*/



/*gen histerectomia = 0 
 replace histerectomia = 1 if regex(PROC_REA,"0409060100")
replace histerectomia =  2 if regex(PROC_REA,"0409060119")
replace histerectomia =  3 if regex(PROC_REA,"0409060127")
replace histerectomia =  4 if regex(PROC_REA,"0409060135")
replace histerectomia =  5 if regex(PROC_REA,"0409060143")
replace histerectomia =  6 if regex(PROC_REA,"0409060151")
replace histerectomia =  7 if regex(PROC_REA,"0409060291")
replace histerectomia =  8 if regex(PROC_REA,"0411020030")
replace histerectomia =  9 if regex(PROC_REA,"0416060056")
replace histerectomia =  10 if regex(PROC_REA,"0416060064")
replace histerectomia =  11 if regex(PROC_REA,"0416060110")

tab histerectomia

lab define histerectomia 0"Controle" 1"Via Vaginal" 2"C/ ANEXECTOMIA (UNI / BILATERAL" 3"SUBTOTAL" 4"TOTAL" 5"TOTAL AMPLIADA (WERTHEIN-MEIGS)	" 6"VIDEOLAPAROSCOPICA	" 7"C/ ANEXECTOMIA BILATERAL E COLPECTOMIA SOB PROCESSO TRANSEXUALIZADOR" 8"
lab val  histerectomia histerectomia


gen histerectomiacat = 0 
replace histerectomiacat = 1 if histerectomia>0 & histerectomia<.
tab histerectomiacat
tab histerectomiacat MORTE, row chi2
swilk 
 */
 *Criar faixa etária
 gen mesmoproc = PROC_SOLIC==PROC_REA
 tab mesmoproc
  
 rename CAR_INT caraterinternação
 
 
 *Definindo labels
 
 lab define sn 0"Não" 1"Sim"
  gen idosa = IDADE>60
 tab idosa
 lab val idosa sn
 
 *Raça_Cor
 encode RACA_COR, gen(raca)
 recode raca 6=.
 gen cor_branca =1 if raca !=1 & raca<.
 replace cor_branca =0 if raca==1
 lab define cor_branca 0"Branca" 1"Não branca"
 lab val cor_branca cor_branca
 tab cor_branca
 
 encode NACIONAL, gen (nacional)
 gen nacionalidade = 0 if nacional==1
 replace nacionalidade =1 if nacional!=1
 lab define nacionalidade 0"BR" 1"Estrangeira"
 lab val nacionalidade nacionalidade
 tab nacionalidade
 
 encode caraterinternação, gen (tipoint)
 gen tipointernação = 0 if tipoint==1
 replace tipointernação =1 if tipoint ==2
 lab define tipointernação 0"Eletivo" 1"Urgência"
 lab val tipointernação tipointernação

rename MORTE obito
lab val obito sn
 
 encode DIAG_PRINC, gen(tipca)
 gen tipocancer = 0 if tipca<=5
 replace tipocancer =1 if tipca>5 & tipca <.
 lab define tipocancer 0"C53" 1"C54"
 lab val tipocancer tipocancer
 
 gen histerectomiaoncologica = 0 if histerectomiacat==1
 replace histerectomiaoncologica =1 if histerectomia==9 | histerectomia==10 | histerectomia==11
 lab val  histerectomiaoncologica sn
 
 tab histerectomiaoncologica
global perfilquali idosa    cor_branca  nacionalidade obito tipocancer tipointernação  DIAG_PRINC histerectomiacat  histerectomiaoncologica
global perfilquanti  IDADE DIAS_PERM UTI_MES_TO
global custos VAL_SH VAL_SP VAL_TOT VAL_UTI
global internaçãoquanti   DIAR_ACOM QT_DIARIAS   IDADE

asdoc tab1 $perfilquali, replace
asdoc tab histerectomia if histerectomiacat==1, append
asdoc tabstat $perfilquanti, stat(p50 iqr) append
tabstat UTI_MES_TO if UTI_MES_TO>0, stat(p50 iqr)


asdoc tab idosa histerectomiacat, row chi2 append
asdoc tab cor_branca histerectomiacat, row chi2 append
asdoc tab nacionalidade histerectomiacat, row chi2 append
asdoc tab tipocancer histerectomiacat, row chi2 append
asdoc tab tipointernação histerectomiacat, row chi2 append


swilk $perfilquanti

foreach i in $perfilquanti {
	bysort histerectomiacat: centile `i'
	ranksum `i', by(histerectomiacat)
}

bysort histerectomiacat: centile UTI_MES_TO if UTI_MES_TO>0
ranksum  UTI_MES_TO if UTI_MES_TO>0, by(histerectomiacat)
rename cor_branca não_ser_branca
gen uti = UTI_MES_TO>0 & UTI_MES_TO<.
lab val uti sn
tab uti

*Fatores associados a mortalidade
asdoc tab idosa obito, row chi2 replace
asdoc tab não_ser_branca obito, row chi2 append
asdoc tab nacionalidade obito, row chi2 append
asdoc tab tipocancer obito, row chi2 append
asdoc tab tipointernação obito, row chi2 append
asdoc tab uti obito, row chi2 append
asdoc tab histerectomiacat obito, row chi2 append
asdoc tab histerectomiaoncologica obito, row chi2 append
 
global quali idosa não_ser_branca   tipocancer tipointernação histerectomiacat 


bysort obito: centile IDADE
ranksum  IDADE, by(obito)

bysort obito: centile DIAS_PERM
ranksum  DIAS_PERM, by(obito)

bysort histerectomiacat: centile UTI_MES_TO if UTI_MES_TO>0
ranksum  UTI_MES_TO if UTI_MES_TO>0, by(histerectomiacat)



poisson obito histerectomiacat, irr r
poisson obito $quali, irr r
logistic  obito histerectomiacat   não_ser_branca tipointernação IDADE  UTI_MES_TO DIAS_PERM


*Análise de sobrevida
	 stset DIAS_PERM, failure(obito==1)
	 sts graph,  survival ci  tmax(30) ytitle(Sobrevida Global) ylabel(, nogrid) scheme(sj)
	 *Descrição da sobrevida
	 stdescribe
	 *Lista de sobrevida
	 sts list, survival
	sts test histerectomiacat
	*Exponential regression coefficients and hazard rates
	streg histerectomiacat   não_ser_branca tipointernação IDADE  UTI_MES_TO DIAS_PERM, dist(exponential)
	*stcox histerectomiacat   não_ser_branca tipointernação IDADE  UTI_MES_TO DIAS_PERM
	i
	sts graph, by(histerectomiacat) ci tmax(30)
	sts graph, by(histerectomiacat) ci risktable tmax(30) ytitle(Sobrevida Global) ylabel(, nogrid) scheme(sj)
	sts test histerectomiacat

 *Sobrevida após histerectomias por causas não oncológicas em mulheres com câncer de colo e de corpo de útero tratadas no serviço público brasileiro em São Paulo
 encode  MES_CMPT, gen(mes)
 
 i

tab RACA_COR histerectomiacat ,row chi2
tab NACIONAL histerectomiacat ,row chi2

	swilk $custos
	foreach i in $custos{
	bysort histerectomiacat: centile `i'
	ranksum `i', by(histerectomiacat)
	}
//Desfechos

	* tempo de internação
	*taxa de utilização da uti
	* dias na uti
	*qt de procedimentos
	*Região
	*idade
	*Mortalidade
	
	
	stset diaspermanencia, failure(obito)
	
i

tab histerectomia MORTE, row chi2
 
 *ciplot diaspermanencia, by(histerectomia)
