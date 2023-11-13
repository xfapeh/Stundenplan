#!/bin/bash

echo $LANG
export LANG=de_DE.ISO-8859-15
echo $LANG

vergleich="/home/Achim/Documents/Work/Schule/Stundenplan/22-23/SPM/Stdp2023-03-03Vers01/Zuordnungsvergleich_02-17_03-03.spm"
pathold="/home/Achim/Documents/Work/Schule/Stundenplan/22-23/SPM/Stdp2023-02-17Vers01/CSV_PDF"
pathnew="/home/Achim/Documents/Work/Schule/Stundenplan/22-23/SPM/Stdp2023-03-03Vers01/CSV_PDF"

# für letzte Optionszeile auskommentieren
#export LANG=de_DE.UTF-8
echo 1
# old one
#awk '{print $2}' $vergleich | iconv -f iso8859-1 -t utf8 | sort | uniq | awk '/^[A-Za-zÄÖÜäöü][a-zÄÖÜäöüß][A-Za-zÄÖÜäöüß]$/' > Lehrer.changes
# hat bei 2020-09-25 vs 2020-09-18 funktioniert (?) Zuordnungsvergleich_Umplanung_Wei_18-25.spm (vielleicht ISO-8859-15 ?)
cat $vergleich |                              awk '{print $2}' | sort | uniq | awk '/^[A-Za-zÄÖÜäöü][a-zÄÖÜäöüß][A-Za-zÄÖÜäöüß]$/' | iconv -f iso8859-1 -t utf8 > Lehrer.changes
export LANG=de_DE.UTF-8
cat Lehrer.changes | sort > Lehrer.changes.tmp
mv Lehrer.changes.tmp Lehrer.changes 
export LANG=de_DE.ISO-8859-15
# hat bei 2020-10-01 vs 2020-09-25 funktioniert (?) Zuordnungsvergleich_Umplanung_Hor_25-01.spm (vielleicht UTF8 ?)
# cat $vergleich | iconv -f utf8 -t iso8859-1 | awk '{print $2}' | sort | uniq | awk '/^[A-Za-zÄÖÜäöü][a-zÄÖÜäöüß][A-Za-zÄÖÜäöüß]$/' | iconv -f iso8859-1 -t utf8 > Lehrer.changes
echo 2
 
cat $pathold/Lehrer1.CSV | iconv -f iso8859-1 -t utf8 | awk '/Lehrer/' | awk '{print NR, $0}' > Lehrer.liste.old
echo 2-5
cat $pathnew/Lehrer1.CSV | iconv -f iso8859-1 -t utf8 | awk '/Lehrer/' | awk '{print NR, $0}' > Lehrer.liste.new

echo 3
export LANG=de_DE.UTF-8

# for lehrer in $(<Lehrer.changes); do grep $lehrer Lehrer.liste.old | awk '{print $1}' ; done | tr '\n' ' '; echo ""
# # 3 4 8 11 15 18 20 22 27 29 31 35 37 38 40 42 43 45 46 48 49 52 53 55 56 57 60 61 63 66 69 72 77 80 81 83 84 91 
# for lehrer in $(<Lehrer.changes); do grep $lehrer Lehrer.liste.new | awk '{print $1}' ; done | tr '\n' ' '; echo ""
# # 3 4 7 8 11 15 18 20 22 23 28 30 32 34 37 39 40 41 42 43 45 46 48 49 52 53 55 56 57 58 61 62 64 67 70 72 74 75 80 83 84 86 87 93 95 

echo 4
for lehrer in $(<Lehrer.changes); do grep $lehrer Lehrer.liste.old | awk '{print $4 " " $1}' ; done | tr -d ',' > Lehrer.liste.ch.old
for lehrer in $(<Lehrer.changes); do grep $lehrer Lehrer.liste.new | awk '{print $4 " " $1}' ; done | tr -d ',' > Lehrer.liste.ch.new

echo 5
join Lehrer.liste.ch.[on][le][dw] | awk '{print "pdftk A='''$pathold'''/Lehrerstundenpläne.pdf B='''$pathnew'''/Lehrerstundenpläne.pdf cat A" $3 " B" $2 " output "$1".pdf"}' | iconv -f ISO_8859-1 -t utf8 | while read var ; do $var; done

convmv -f utf8 -t iso8859-1 ???.pdf   --notest
convmv -f utf8 -t iso8859-1 ????.pdf  --notest
convmv -f utf8 -t iso8859-1 ?????.pdf --notest

echo -n "pdftk " > temp.sh; for file in ???.pdf; do echo -n "$file " >> temp.sh; done ; echo "cat output Lehrer.changes.pdf" >> temp.sh

chmod +x temp.sh
./temp.sh
rm temp.sh
rm ???.pdf

# # -> pdftk Att.pdf Bee.pdf BoK.pdf Buc.pdf Gat.pdf Gha.pdf Goß.pdf Grü.pdf Her.pdf Hol.pdf Hut.pdf Kln.pdf Kon.pdf Kop.pdf Kün.pdf Lab.pdf Lei.pdf Lin.pdf Man.pdf Mot.pdf Msc.pdf Nag.pdf Nen.pdf Ols.pdf Pfl.pdf Rap.pdf Rod.pdf Rut.pdf Sch.pdf Sdt.pdf Smm.pdf Stb.pdf Sut.pdf Wäl.pdf Web.pdf Wer.pdf Wes.pdf Zin.pdf cat output Lehrer.changes.pdf 

awk '{print $1}' Lehrer.liste.ch.old > Lehrer.liste.ch.old.1
awk '{print $1}' Lehrer.liste.ch.new > Lehrer.liste.ch.new.1
comm Lehrer.liste.ch.old.1 Lehrer.liste.ch.new.1 -1 | awk '/^[A-Za-z0-9].*/' | awk '{print $1}' > Lehrer.liste.add

for file in $(<Lehrer.liste.add); do grep $file Lehrer.liste.ch.new; done | awk '{print "pdftk A='''$pathold'''/Lehrerstundenpläne.pdf B='''$pathnew'''/Lehrerstundenpläne.pdf cat B" $2 " output "$1".pdf"}' | iconv -f ISO_8859-1 -t utf8 | while read var ; do $var; done

convmv -f utf8 -t iso8859-1 ???.pdf   --notest
convmv -f utf8 -t iso8859-1 ????.pdf  --notest
convmv -f utf8 -t iso8859-1 ?????.pdf --notest

echo -n "pdftk " > temp.sh; for file in $(<Lehrer.liste.add); do echo -n "$file.pdf " >> temp.sh; done ; echo "cat output Lehrer.add.pdf" >> temp.sh

chmod +x temp.sh
./temp.sh
rm temp.sh
rm ???.pdf

if [ -e "Lehrer.add.pdf" ]
then pdftk Lehrer.changes.pdf Lehrer.add.pdf cat output Lehrer.changes-add.pdf
else cp Lehrer.changes.pdf Lehrer.changes-add.pdf
fi

gs -o Lehrer.changes_A4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Lehrer.changes-add.pdf >> log 2>> log

pdfnup Lehrer.changes_A4.pdf

mv Lehrer.changes_A4-2x1.pdf Lehrer.changes.pdf

rm ???.pdf Lehrer.changes Lehrer.liste.* Lehrer.changes-add.pdf Lehrer.add.pdf Lehrer.changes_A4.pdf 
