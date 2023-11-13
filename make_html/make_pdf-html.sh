#!/bin/bash
echo "Lehrer Inst mit exportieren!"
echo "evtl. Lehrer Ausschlussliste in make_pdf-html.sh anpassen (2x!)"

mkdir Startseite

pdftk ../CSV_PDF/Klassenstundenpläne.pdf         burst output Klasse_%02d.pdf
pdftk ../CSV_PDF/Startseite/Klassenstundenpläne.pdf         burst output Startseite/Klasse_%02d.pdf
pdftk ../CSV_PDF/Lehrerstundenpläne.pdf          burst output Lehrer_%03d.pdf
pdftk ../CSV_PDF/Raumstundenpläne.pdf            burst output Raum_%02d.pdf
#
#
cat ../Klasse.spm | awk 'BEGIN{i=1}; /^[0-9]/ {printf "%02d %s \n", i++, $1}' > temp1
grep href links_1.htm | egrep -o k_[0-9]..?.htm | sed 's/.htm//g' > temp2
if [ "$(cat temp1 | wc -l)" -ne "$(cat temp2 | wc -l)" ];
  then echo "Klasseanzahl nicht gleich"; exit 1;
fi
paste temp1 temp2 | tr -d '\t' > Klasse-Liste
#
cat ../Lehrer.spm | iconv -f iso8859-15 -t utf8 | sed -r '/Che|Del|Reg|Epl|Hmm|Hub|Kie|Krs|Lod|Loz|Msl|Mos|Nie|Pör|Rft|Sco|Swz|Stu|Sza|Ueb|Wer/d' | awk 'BEGIN{i=1}; /^[A-Z]/ {printf "%03d %s \n", i++, $1}' | tr -d '.' | iconv -f utf8 -t iso8859-15 > temp1
cat links_0.htm | grep href=\"l_ | egrep -o l_[a-z_]\{3,5\} | sed -r '/che|del|reg|epl|hmm|hub|kie|krs|lod|loz|msl|mos|nie|po_r|rft|sco|swz|stu|sza|ueb|wer/d' > temp2
if [ "$(cat temp1 | wc -l)" -ne "$(cat temp2 | wc -l)" ];
  then echo "Fehler: Lehreranzahl nicht gleich"; exit 1;
fi
paste temp1 temp2 | tr -d '\t' > Lehrer-Liste
#
cat ../Raum.spm | sed -r '/rHeim|rStu/d' | awk '/^r/ {print $1}' | egrep -o 'r...?.?.?.?\.' | awk 'BEGIN{i=1}; /^r/ {printf "%02d %s \n", i++, $1}' | tr -d '.' > temp1
grep href links_2.htm | sed -r '/rheim|rstu/d' | egrep -o r_...?.?.?.?.htm | sed 's/.htm//g' > temp2
#i=1; for var in $(<temp); do printf "%02d" $i; echo " $var"; echo "$((i++))" >> /dev/null; done > Raum-Liste
if [ "$(cat temp1 | wc -l)" -ne "$(cat temp2 | wc -l)" ];
  then echo "Raumanzahl nicht gleich"; exit 1;
fi
paste temp1 temp2 | tr -d '\t' > Raum-Liste
#
klasse=$(cat Klasse-Liste | wc -l)
lehrer=$(cat Lehrer-Liste | wc -l)
raum=$(cat Raum-Liste   | wc -l)
# #
# for ((i=1;i<=$klasse;i++)); do $(grep ^$(printf %02d $i) Klasse-Liste | awk '{print "mv Klasse_" $1".pdf" , $3 ".pdf"}'); done
# #
# for ((i=1;i<=$lehrer;i++)); do $(grep ^$(printf %03d $i) Lehrer-Liste | awk '{print "mv Lehrer_" $1".pdf" , $3 ".pdf"}'); done
# #
# for ((i=1;i<=$raum;i++));   do $(grep ^$(printf %02d $i) Raum-Liste | awk '{print "mv Raum_" $1".pdf" , $3 ".pdf"}'); done
# mit Datum im Dateinamen
for ((i=1;i<=$klasse;i++)); do #echo $(grep ^$(printf %02d $i) Klasse-Liste | awk '{print "mv Klasse_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');
                                    $(grep ^$(printf %02d $i) Klasse-Liste | awk '{print "mv Klasse_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');done
for ((i=1;i<=$klasse;i++)); do #echo $(grep ^$(printf %02d $i) Klasse-Liste | awk '{print "mv Klasse_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');
                                    $(grep ^$(printf %02d $i) Klasse-Liste | awk '{print "mv Startseite/Klasse_" $1".pdf" , "Startseite/" $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');done
#
for ((i=1;i<=$lehrer;i++)); do #echo $(grep ^$(printf %03d $i) Lehrer-Liste | awk '{print "mv Lehrer_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');
                                    $(grep ^$(printf %03d $i) Lehrer-Liste | awk '{print "mv Lehrer_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}'); done
#
for ((i=1;i<=$raum;i++));   do #echo $(grep ^$(printf %02d $i) Raum-Liste | awk '{print "mv Raum_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');
                                    $(grep ^$(printf %02d $i) Raum-Liste | awk '{print "mv Raum_" $1".pdf" , $3 "_'''"`date +%Y-%m-%d`"'''" ".pdf"}');done
#
cp ../CSV_PDF/Klassenstundenpläne.pdf Klassenstundenplaene_`date +%Y-%m-%d`.pdf
cp ../CSV_PDF/Lehrerstundenpläne.pdf Lehrerstundenplaene_`date +%Y-%m-%d`.pdf
cp ../CSV_PDF/Raumstundenpläne.pdf Raumstundenplaene_`date +%Y-%m-%d`.pdf
#
rm temp1 temp2 doc_data.txt
#
tar xvzf ../index.htm.tar.gz
#
# cat links_0.htm | sed 's/.htm"/.pdf"/g' | sed 's/links_0.pdf/links_0.htm/g'| sed 's/links_1.pdf/links_1.htm/g' | sed 's/links_2.pdf/links_2.htm/g' > links_0-pdf.htm
# cat links_1.htm | sed 's/.htm"/.pdf"/g' | sed 's/links_0.pdf/links_0.htm/g'| sed 's/links_1.pdf/links_1.htm/g' | sed 's/links_2.pdf/links_2.htm/g' > links_1-pdf.htm
# cat links_2.htm | sed 's/.htm"/.pdf"/g' | sed 's/links_0.pdf/links_0.htm/g'| sed 's/links_1.pdf/links_1.htm/g' | sed 's/links_2.pdf/links_2.htm/g' > links_2-pdf.htm
# mit Datum im Dateinamen
# cat links_0.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' | sed 's/links_0_'''"`date +%Y-%m-%d`"'''.pdf/links_0.htm/g'| sed 's/links_1_'''"`date +%Y-%m-%d`"'''.pdf/links_1.htm/g' | sed 's/links_2_'''"`date +%Y-%m-%d`"'''.pdf/links_2.htm/g' > links_0-pdf.htm
# cat links_1.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' | sed 's/links_0_'''"`date +%Y-%m-%d`"'''.pdf/links_0.htm/g'| sed 's/links_1_'''"`date +%Y-%m-%d`"'''.pdf/links_1.htm/g' | sed 's/links_2_'''"`date +%Y-%m-%d`"'''.pdf/links_2.htm/g' > links_1-pdf.htm
# cat links_2.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' | sed 's/links_0_'''"`date +%Y-%m-%d`"'''.pdf/links_0.htm/g'| sed 's/links_1_'''"`date +%Y-%m-%d`"'''.pdf/links_1.htm/g' | sed 's/links_2_'''"`date +%Y-%m-%d`"'''.pdf/links_2.htm/g' > links_2-pdf.htm
# #
cat links_0.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' | sed 's/links_0_'''"`date +%Y-%m-%d`"'''.pdf/links_0_'''"`date +%Y-%m-%d`"'''.htm/g'| sed 's/links_1_'''"`date +%Y-%m-%d`"'''.pdf/links_1_'''"`date +%Y-%m-%d`"'''.htm/g' | sed 's/links_2_'''"`date +%Y-%m-%d`"'''.pdf/links_2_'''"`date +%Y-%m-%d`"'''.htm/g' > links_0-pdf.htm
cat links_1.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' | sed 's/links_0_'''"`date +%Y-%m-%d`"'''.pdf/links_0_'''"`date +%Y-%m-%d`"'''.htm/g'| sed 's/links_1_'''"`date +%Y-%m-%d`"'''.pdf/links_1_'''"`date +%Y-%m-%d`"'''.htm/g' | sed 's/links_2_'''"`date +%Y-%m-%d`"'''.pdf/links_2_'''"`date +%Y-%m-%d`"'''.htm/g' > links_1-pdf.htm
cat links_2.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' | sed 's/links_0_'''"`date +%Y-%m-%d`"'''.pdf/links_0_'''"`date +%Y-%m-%d`"'''.htm/g'| sed 's/links_1_'''"`date +%Y-%m-%d`"'''.pdf/links_1_'''"`date +%Y-%m-%d`"'''.htm/g' | sed 's/links_2_'''"`date +%Y-%m-%d`"'''.pdf/links_2_'''"`date +%Y-%m-%d`"'''.htm/g' > links_2-pdf.htm
#
mv links_0-pdf.htm links_0_`date +%Y-%m-%d`.htm
mv links_1-pdf.htm links_1_`date +%Y-%m-%d`.htm
mv links_2-pdf.htm links_2_`date +%Y-%m-%d`.htm
#
cat frames.htm | sed 's/links_0.htm/links_0_'''"`date +%Y-%m-%d`"'''.htm/g' > frames_`date +%Y-%m-%d`.htm
cp frames_`date +%Y-%m-%d`.htm frames.htm
#
for num in 5 6 7 8 9 10; 
do cat k_${num}.htm | sed 's/.htm"/_'''"`date +%Y-%m-%d`"'''.pdf"/g' > temp
mv temp k_${num}.htm
done
#
# htm files löschen Lehrer Klassen (außer k_5.htm ...) Räume
rm l_*.htm k_?[a-z].htm k_??[a-z].htm k_q1*.htm r_*.htm
rm frames.htm index.htm links_0.htm links_1.htm links_2.htm
#
# #awk '/Overfull/ {getline; print $2}' log | sort | uniq -d | tr -d '|' | sed 's/$/\\\\/g' > /home/Achim/Documents/Work/Schule/Stundenplan/XYZ/make_pdf/too-long.tex
