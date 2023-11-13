
# 1-6	DIN A3 Klasse		6	OK 	(wird bald per Kopierer farbig gedruckt)
# 7-8	DIN A3 Reli		2	Anpassung notwendig, vielleicht an Klassenplan unten ran?
# 9-10	DIN A3 Oberstufe	2	unnötig für Druck
# 11-22	DIN A4 Klasse		12	bald überflüssig
# 23-26	DIN A3 Lehrer		4	OK
# 27-28	DIN A3 Raum		2	OK
#				28

#gs -o Stundenplan_printA4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Stundenplan_print.pdf
gs -o Stundenplan_printA3.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a3 -dAutoRotatePages=/None -dPDFFitPage -f Stundenplan_print.pdf
mv Stundenplan_printA3.pdf Stundenplan_print.pdf
gs -o Klasse_Notfallkoffer_A3.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a3 -dAutoRotatePages=/None -dPDFFitPage -f Klasse_Notfallkoffer.pdf
mv Klasse_Notfallkoffer_A3.pdf Klasse_Notfallkoffer.pdf
