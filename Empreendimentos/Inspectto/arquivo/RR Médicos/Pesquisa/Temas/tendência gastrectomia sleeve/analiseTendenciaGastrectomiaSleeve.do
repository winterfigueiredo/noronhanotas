import excel "C:\Users\Winter\Google Drive\Empreendimentos\Inspectto\RR Médicos\Pesquisa\Temas\tendência gastrectomia sleeve\bancoRRDatasus.xlsx", sheet("Plan1") firstrow clear
global desfecho Nordeste Sudeste Sul CentroOeste Brasil
swilk $desfecho

ktau Brasil ano
