cd CSV_PDF
make_Klasse-Reli-Oberstufe.sh
make_Lehrer.sh
make_Raum.sh
print_Klasse.sh
print_Lehrer.sh
print_Raum.sh
make_Klassenstundenpläne.sh
# make_Klassenstundenpläne_Startseite.sh
make_Lehrerstundenpläne.sh
make_Raumstundenpläne.sh
# make_Stuzi.sh
# print_Fachschaften.sh

pdftk Klasse.pdf Lehrer.pdf Raum.pdf cat output Stundenplan.pdf
#pdftk Klasse_printA4.pdf Lehrer_printA4.pdf Raum_printA4.pdf cat output Stundenplan_printA4.pdf
#pdftk Klasse_printA3.pdf Lehrer_printA3.pdf Raum_printA3.pdf cat output Stundenplan_printA3.pdf
pdftk Klasse_print.pdf Lehrer_print.pdf Raum_print.pdf cat output Stundenplan_print.pdf
print_Kopierer.sh

rm Klasse.pdf Lehrer.pdf Raum.pdf 
#rm Klasse_printA4.pdf Lehrer_printA4.pdf Raum_printA4.pdf Klasse_printA3.pdf Lehrer_printA3.pdf Raum_printA3.pdf 
rm Klasse_print.pdf Lehrer_print.pdf Raum_print.pdf
cd ..

# html vorbereiten:
# Lehrer Ausschlussliste in make_pdf-html.sh anpassen (2x!)
# nach erstem händischen (wird sonst gelöscht) Durchlauf die Dateien links_X.htm aussortieren:
# OSK, Stuzi, Präs, ... in der Navi Leiste löschen
# dann als index.htm.tag.gz im unteren Verzeichnis reinstellen
#cd html
#make_klassen_local.sh
#make_pdf-html.sh
##make_upload.sh
#cd ..

