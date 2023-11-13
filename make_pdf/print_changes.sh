cat ../Stdp2014-10-11/html/Lehrer-Liste | iconv -f iso8859-15 -t utf8 > Lehrer-temp
pdftk CSV_PDF/Lehrerstundenpläne.pdf cat \
$(for lehrer in $(cat CHANGES-Lehrer.spm | tr -d '\r' | iconv -f iso8859-15 -t utf8 | sort | uniq); do grep "$lehrer" Lehrer-temp; done | awk '{printf "%s ", $1}') \
output CSV_PDF/Lehrerstundenpläne-changes.pdf
rm Lehrer-temp

#Für Klassen klappts nicht so ...
pdftk CSV_PDF/Klassenstundenpläne.pdf cat \
$(for klassen in $(cat CHANGES-Klassen.spm | tr -d '\r' | iconv -f iso8859-15 -t utf8 | sort | uniq); do grep "$klassen" ../Stdp2014-10-11/html/Klassen-Liste; done | awk '{printf "%s ", $1}') \
output CSV_PDF/Klassenstundenpläne-changes.pdf