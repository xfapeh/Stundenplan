# Ausgabe von make_Lehrerstundenpläne.sh:
echo "$(\
shopt -s extglob
cat Lehrer1.CSV | iconv -f iso8859-15 -t utf8 > temp.csv
# "
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Lehrer-latex.csv
cat Lehrer-latex.csv | awk '/SPM++/ {gsub(/202[0-9],/, ""); gsub(/,,,/, ",");  print $9}; !/SPM++/ {print $0}' > temp && mv temp Lehrer-latex.csv
awk ''/^[A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß]t?,Mo,Di,Mi,Do,Fr$/' { out = sprintf("Lehrer-latex-%02d.csv", ++i); print > out } !'/^[A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß]t?,Mo,Di,Mi,Do,Fr$/' { out = sprintf("Lehrer-latex-%02d.csv", i); print > out }' Lehrer-latex.csv
num=$(ls -1 Lehrer-latex-*.csv | wc -l)
for ((i=1; i<=$num; i++)); do
lehrer=$(cat Lehrer-latex-$(printf "%02d" $i).csv | awk '/^[A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß]t?,Mo,Di,Mi,Do,Fr$/ {gsub(/,.*$/, "");print $0}')
printf "%02d:_%s " $i $lehrer
done)" \
| tr ' ' '\n' > lehrer
rm Lehrer-latex*.csv temp.csv

# echo "
# 01:_Alb 02:_Arz 03:_Att 04:_Bau 05:_Bee 06:_Bet 07:_Böh 08:_Bos 09:_BoK 10:_Bra 11:_Brn 12:_Brö 13:_Buc 14:_Buz 15:_Con 16:_Dör 17:_Drö 18:_Ebe 19:_Ges 20:_Ger 21:_Göb 22:_Goß 23:_Göt 24:_Gro 25:_Hah 26:_Ham 27:_Har 28:_Här 29:_Hei 30:_Her 31:_Höc 32:_Hol 33:_Hor 34:_Jak 35:_Kas 36:_Kae 37:_Käs 38:_Kel 39:_Kle 40:_Kne 41:_Kon 42:_Kop 43:_Kös 44:_Kre 45:_Lab 46:_Lau 47:_Lei 48:_Ley 49:_Man 50:_May 51:_Msc 52:_Mot 53:_Mün 54:_Nag 55:_Nen 56:_OlH 57:_Ols 58:_Pfl 59:_Rap 60:_Ren 61:_Rit 62:_Rod 63:_Rum 64:_Rut 65:_Sac 66:_Scn 67:_Sle 68:_SmB 69:_Sdt 70:_Smz 71:_Scu 72:_Smm 73:_Sus 74:_Som 75:_Stb 76:_Stä 77:_Stl 78:_Stg 79:_Sti 80:_Stk 81:_Sto 82:_Sth 83:_Str 84:_Sut 85:_Ull 86:_Wäl 87:_WlM 88:_Web 89:_Wse 90:_Wei 91:_Wir 92:_Wit 93:_Zap 94:_Zei 95:_Zez 96:_Zim 97:_Zin
# " | tr ' ' '\n' > lehrer

echo "\
Att
Bee
Brn
Buc
Dud
Kel
Lei
Sut
Web
" | while read teacher; do grep $teacher lehrer; done | sed 's/:_.*//g' | tr '\n' ' ' > temp

pdftk Lehrerstundenpläne.pdf cat $(<temp) output Physik.pdf

echo "\
Gro
Heu
Hor
Man
Msc
Scb
Wes
Wse
" | while read teacher; do grep $teacher lehrer; done | sed 's/:_.*//g' | tr '\n' ' ' > temp

pdftk Lehrerstundenpläne.pdf cat $(<temp) output Chemie.pdf

echo "\
Drö
Göt
Man
Msl
Nen
Rut
" | while read teacher; do grep $teacher lehrer; done | sed 's/:_.*//g' | tr '\n' ' ' > temp

pdftk Lehrerstundenpläne.pdf cat $(<temp) output Personalrat.pdf

echo "\
Ger
Kne
Men
Mün
OlH
Ols
WlM
Wir
Zei
Zez
" | while read teacher; do grep $teacher lehrer; done | sed 's/:_.*//g' | tr '\n' ' ' > temp

pdftk Lehrerstundenpläne.pdf cat $(<temp) output Internat.pdf



pdfnup --nup 5x2 Physik.pdf
pdfcrop --margins 10 Physik-5x2.pdf
mv Physik-5x2-crop.pdf Physik.pdf

pdfnup --nup 4x2 Chemie.pdf
pdfcrop --margins 10 Chemie-4x2.pdf
mv Chemie-4x2-crop.pdf Chemie.pdf

pdfnup --nup 3x2 Personalrat.pdf
pdfcrop --margins 10 Personalrat-3x2.pdf
mv Personalrat-3x2-crop.pdf Personalrat.pdf

pdfnup --nup 5x2 Internat.pdf
pdfcrop --margins 10 Internat-5x2.pdf
mv Internat-5x2-crop.pdf Internat.pdf

rm temp lehrer Physik-5x2.pdf Chemie-4x2.pdf Personalrat-3x2.pdf Internat-5x2.pdf

for file in Chemie Internat Personalrat Physik; do gs -o ${file}_A3.pdf  -sDEVICE=pdfwrite -sPAPERSIZE=a3 -dAutoRotatePages=/None -dPDFFitPage -f ${file}.pdf; mv ${file}_A3.pdf ${file}.pdf; done
