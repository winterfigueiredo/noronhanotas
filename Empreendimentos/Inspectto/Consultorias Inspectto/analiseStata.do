swilk $mq 
foreach i in $mq  {
	  swilk `i'
	  if  `r(p)'>=0.05 {
		asdoc, text(\n `i')
		asdoc, text(\n ANOVA)
		asdoc tabstat `i', stat(mean sd) by(grupo) row append  tzok dec(2) 
		asdoc oneway `i' grupo, append
		*global pv =  Ftail(`e(df_m)', `e(df_r)', `e(F)')
		*asdoc, text(ANOVA, p=  $pv), append
		*asdoc, row(Variables `r(N)') append dec(3)
			
		
		}
	else {
		 asdoc, text(\n `i')
		 asdoc, text(\n Kruskal-Wallis)
		 asdoc tabstat `i', stat(mean sd) by(grupo)  append tzok dec(2) 
		 asdoc kwallis  `i', by(grupo), append
		
		}
	}
