import excel "bdCeliana.xlsx", sheet("bdCelianaof") firstrow clear
tab grupo

//
// egen pares = concat(grupo idade)
// tab pares
// sort idade

twoway lowess pimaxsup idade if grupo ==  "Controle" , mean || lowess  pemax idade if grupo ==  "Controle"  , mean    || lowess  pimaxsup idade if grupo ==  "AF"  , mean || lowess  pemax idade if grupo ==  "AF"  , mean 

regress pimaxsup idade
predict pim
twoway kdensity pimaxsup idade if grupo ==  "Controle"  || kdensity  pemax idade if grupo ==  "Controle"       || kdensity  pimaxsup idade if grupo ==  "AF"  || kdensity  pemax idade if grupo ==  "AF" 
twoway fpfit pimaxsup idade if grupo ==  "Controle"  || fpfit  pemax idade if grupo ==  "Controle"     



  || fpfit  pimaxsup idade if grupo ==  "AF"  || fpfit  pemax idade if grupo ==  "AF" 