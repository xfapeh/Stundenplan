# Lehrer
awk '{print $2}' $1 | iconv -f iso8859-1 -t utf8 | sort | uniq | awk '/^[A-Za-zÄÖÜäöü][A-Za-zÄÖÜäöü][A-Za-zÄÖÜäöü]$/' > Lehrer.changes
cat CSV_PDF/Lehrer1.CSV | iconv -f iso8859-1 -t utf8 | awk '/Lehrer/' | awk '{print NR, $0}' > Lehrer.liste
for lehrer in $(<Lehrer.changes); do grep $lehrer Lehrer.liste | awk '{print $1}' ; done | tr '\n' ' '; echo ""
# Klassen
awk '{print $2}' $1 | iconv -f iso8859-1 -t utf8 | sort | uniq | awk '/^[0-9]/' | sort -n > Klasse.changes
cat CSV_PDF/Klasse1.CSV | iconv -f iso8859-1 -t utf8 | awk '/Klasse/' | awk '{print NR, $0}' > Klasse.liste
for klasse in $(<Klasse.changes); do grep $klasse Klasse.liste | awk '{print $1}' ; done | tr '\n' ' '; echo ""
