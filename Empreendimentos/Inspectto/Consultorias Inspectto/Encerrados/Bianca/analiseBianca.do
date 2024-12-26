import excel "Dados_bianca.xlsx", sheet(bdBianca) firstrow clear

replace  TAXADEFERTILIZAÇÃO = TAXADEFERTILIZAÇÃO  *100 if TAXADEFERTILIZAÇÃO <1

replace TAXADEFERTILIZAÇÃO = 100 if TAXADEFERTILIZAÇÃO>100

swilk IDADE DURAÇÃODOCICLODIAS  DOSEhMGmenotropina DOSEFSHralfafolitropina DOSEFSHrbetafolitropina FOLÍCULOSPUNCIONADOS OÓCITOSRECUPERADOS OÓCITOSMII OÓCITOSMI OÓCITOSVG OÓCITOSROTOS OÓCITOSDEGENERADOS NÚMERODEOÓCITOSFERTILIZADOS2 TAXADEFERTILIZAÇÃO NÚMERODEBLASTOCISTOS TAXADEBLASTOCISTOS EMBRIÕESTOPQUALITYBL1BL2 D5 D6 D7

swilk  IDADE IMC TEMPODEINFERTILIDADE INFERTILIDADEPRIMÁRIA CFA HAM


*Table  1
table1_mc, by(PROTOCOLO) vars(IDADE conts \  IMC conts  \ TEMPODEINFERTILIDADE_ANOS conts \   INFERTILIDADEPRIMÁRIA cate \   CFA conts \   HAM  conts \  )  onecol format(%2,1f) percf (%2,1f) saving(tabela1.xlsx, replace) 


**Converterndo os valores zerados para as medianas amostrais
swilk DOSEhMGmenotropina DOSEFSHralfafolitropina
su DOSEhMGmenotropina, d
replace  DOSEhMGmenotropina  =  r(p50) if DOSEhMGmenotropina ==0
su DOSEhMGmenotropina 

su DOSEFSHralfafolitropina, d
replace  DOSEFSHralfafolitropina  =  r(p50) if DOSEFSHralfafolitropina ==0
su DOSEFSHralfafolitropina 

swilk DOSEhMGmenotropina DOSEFSHralfafolitropina

swilk FOLÍCULOSPUNCIONADOS OÓCITOSRECUPERADOS OÓCITOSMII OÓCITOSMI OÓCITOSVG TAXADEFERTILIZAÇÃO TAXADEBLASTOCISTOS

su FOLÍCULOSPUNCIONADOS OÓCITOSRECUPERADOS OÓCITOSMII OÓCITOSMI OÓCITOSVG TAXADEFERTILIZAÇÃO TAXADEBLASTOCISTOS

*Table 2
table1_mc, by(PROTOCOLO) vars(DOSEhMGmenotropina conts \  DOSEFSHralfafolitropina conts  \   FOLÍCULOSPUNCIONADOS conts  \ OÓCITOSRECUPERADOS conts  \  OÓCITOSMII conts  \  OÓCITOSMI conts  \  OÓCITOSVG conts  \  TAXADEFERTILIZAÇÃO conts  \  TAXADEBLASTOCISTOS   conts  \ DURAÇÃODOCICLODIAS conts)  onecol format(%2,1f) percf (%2,1f) saving(tabela2.xlsx, replace) 
i

*Table 3 
table1_mc, by(PROTOCOLO) vars(EMBRIÕESTOPQUALITYBL1BL2 conts \ D5 conts \ D6 conts \ D7 conts \ )   onecol format(%2,1f) percf (%2,1f) saving(tabela3.xlsx, replace) 

encode PROTOCOLO, gen(protocolo)
qreg EMBRIÕESTOPQUALITYBL1BL2 protocolo  

qreg EMBRIÕESTOPQUALITYBL1BL2 protocolo CFA

global variaveis EMBRIÕESTOPQUALITYBL1BL2 D5 D6 D7
foreach i in $variaveis {
*qreg `i' protocolo  `
	su `i' 
	qreg `i'  protocolo  

}





i



table1_mc, vars(PROTOCOLO cat\ IDADE conts\  DURAÇÃODOCICLODIAS conts \ DOSEhMGmenotropina conts\ DOSEFSHralfafolitropina conts\ DOSEFSHrbetafolitropina conts\  FOLÍCULOSPUNCIONADOS conts\ OÓCITOSRECUPERADOS conts\ OÓCITOSMII conts\ OÓCITOSMI conts\ OÓCITOSVG conts\ OÓCITOSROTOS conts\ OÓCITOSDEGENERADOS conts\ NÚMERODEOÓCITOSFERTILIZADOS2 conts\ TAXADEFERTILIZAÇÃO conts\ NÚMERODEBLASTOCISTOS conts\ TAXADEBLASTOCISTOS  conts\ EMBRIÕESTOPQUALITYBL1BL2 conts\ D5 conts\ D6 conts\ D7 conts\ ) onecol format(%2,1f) percf (%2,1f) saving(tabela1.xlsx, replace) 

table1_mc, vars(PROTOCOLO cat\ IDADE contn\  DURAÇÃODOCICLODIAS contn \ DOSEhMGmenotropina contn\ DOSEFSHralfafolitropina contn\ DOSEFSHrbetafolitropina contn\  FOLÍCULOSPUNCIONADOS contn\ OÓCITOSRECUPERADOS contn\ OÓCITOSMII contn\ OÓCITOSMI contn\ OÓCITOSVG contn\ OÓCITOSROTOS contn\ OÓCITOSDEGENERADOS contn\ NÚMERODEOÓCITOSFERTILIZADOS2 contn\ TAXADEFERTILIZAÇÃO contn\ NÚMERODEBLASTOCISTOS contn\ TAXADEBLASTOCISTOS  contn\ EMBRIÕESTOPQUALITYBL1BL2 contn\ D5 contn\ D6 contn\ D7 contn\ ) onecol format(%2,1f) percf (%2,1f) saving(tabela1.1.xlsx, replace) 


table1_mc, by(PROTOCOLO) vars(IDADE conts\  DURAÇÃODOCICLODIAS conts \ DOSEhMGmenotropina conts\ DOSEFSHralfafolitropina conts\ DOSEFSHrbetafolitropina conts\  FOLÍCULOSPUNCIONADOS conts\ OÓCITOSRECUPERADOS conts\ OÓCITOSMII conts\ OÓCITOSMI conts\ OÓCITOSVG conts\ OÓCITOSROTOS conts\ OÓCITOSDEGENERADOS conts\ NÚMERODEOÓCITOSFERTILIZADOS2 conts\ TAXADEFERTILIZAÇÃO conts\ NÚMERODEBLASTOCISTOS conts\ TAXADEBLASTOCISTOS  conts\ EMBRIÕESTOPQUALITYBL1BL2 conts\ D5 conts\ D6 conts\ D7 conts\ ) gurmeet onecol format(%2,1f) percf (%2,1f) saving(tabela2.xlsx, replace) 

table1_mc, by(PROTOCOLO) vars(IDADE contn\  DURAÇÃODOCICLODIAS contn \ DOSEhMGmenotropina contn\ DOSEFSHralfafolitropina contn\ DOSEFSHrbetafolitropina contn\  FOLÍCULOSPUNCIONADOS contn\ OÓCITOSRECUPERADOS contn\ OÓCITOSMII contn\ OÓCITOSMI contn\ OÓCITOSVG contn\ OÓCITOSROTOS contn\ OÓCITOSDEGENERADOS contn\ NÚMERODEOÓCITOSFERTILIZADOS2 contn\ TAXADEFERTILIZAÇÃO contn\ NÚMERODEBLASTOCISTOS contn\ TAXADEBLASTOCISTOS  contn\ EMBRIÕESTOPQUALITYBL1BL2 contn\ D5 contn\ D6 contn\ D7 contn\ ) gurmeet onecol format(%2,1f) percf (%2,1f) saving(tabela2.1.xlsx, replace) 
