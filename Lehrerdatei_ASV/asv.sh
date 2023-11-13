#name=ListePflDruck_Markgräfin-Wilhelmine-Gymnasium_040917.csv
name=$1

cat $name \
| sort -n \
| awk '/^[0-9][0-9]?[A-Z]/ {print " ", $0}' \
| sed 's/;/ ; /g' \
| column -s ';' -t \
| awk 'BEGIN{vor="HALLO";}; 
    {if(vor ~ $1)
           {print $0}
     else  {print "\n" $0}; 
     vor=$1;}' > ListePflDruck_ASV.spm
     
awk '{if ($2!="K" && $2!="Ev_1" && $2!="Ev_2" && $2!="Eth" && $2!="Smw" && $2!="Sm" && $2!="Sw" && $2!="Sw_1" && $2!="Sw_2"){print $0}}' ListePflDruck_ASV.spm > ListePflDruck_ASV-ohne_Reli_Sport.spm

awk '{if ($5!="I" && $6!="I"){print $0}}' ListePflDruck_ASV-ohne_Reli_Sport.spm | sed 's/NuT_2/Inf/g' | sed 's/_[1-9] //g' > ListePflDruck_ASV-ohne_Reli_Sport_Int.spm

# nach Fachnummer aus Excel Tabelle sortieren
echo "
K
Ev
Eth
D
Dint
L
Lint
E
Eint
F
Fint
Fs
Sp
Sps
M
Ph
C
NuT
Inf
B
Exp
G
Geo
Sk
WR
Ku
Mu
Sm
Sw
Smw
Peso" | nl | awk '{print $2 "," $1}' | sort > order-number-sort

# split bei Leerzeilen (= neue Klasse)
csplit -s -f splitted -n 3 ListePflDruck_ASV-ohne_Reli_Sport_Int.spm /^$/ {*}
# Mittels Reihenfolge aus "order-number-sort" sortieren, Whitespace -> "," wegen csv
for file in splitted0*; do cat $file  | sort -k2,2 | sed -e 's/\ \+/,/g' | sed -e 's/^,//g' | sed -e 's/,$//g' | join -t, -11 -22 order-number-sort - | sort -t, -k2n | column -t -s, > ${file}.sort; done
# wieder zusammenfügen: Klasse Fach Lehrer Stunden Koppel                                          (letztes p weg)
rm -f new-order.spm; for file in splitted0*.sort; do cat $file | awk '{print $3, $1, $4, $5, $6}' | sed 's/ p$//g' >> new-order.spm && echo -e "" >> new-order.spm; done
rm splitted*
# Als ganzes als Tabelle, Leerzeilen wieder einfügen (macht column weg)
cat new-order.spm | column -t -s" " | sed 's/^/ /g' \
| awk 'BEGIN{vor="HALLO";}; 
    {if(vor ~ $1)
           {print $0}
     else  {print "\n" $0}; 
     vor=$1;}'> temp; mv temp new-order.spm
mv new-order.spm ListePflDruck_ASV-ohne_Reli_Sport_Int-ordered.spm

# finde Unterrichte ohne Lehrer
cat $name | awk 'BEGIN{FS=";"}; {if($3 ~/^$/){print $0}}' | awk '/^[0-9][0-9]?[A-Z]/ {print " ", $0}' | sed 's/;/ ; /g' | column -s ';' -t  > ListePflDruck_ASV-ohne_Lehrer.spm

cat $name | awk 'BEGIN{FS=";"}; {if($5 !~/^$/){print $0}}' | awk '/^[0-9][0-9]?[A-Z]/ {print " ", $0}' | sed 's/;/ ; /g' | column -s ';' -t > ListePflDruck_ASV-Koppelklasse.spm

cat $name | awk 'BEGIN{FS=";"}; {if($5 !~/^$/){print $0}}' | awk '/^[0-9][0-9]?[A-Z]/ {print " ", $0}' | sed 's/;/ ; /g' | sort -t ';' -k 5,5 | column -s ';' -t > temp
cat temp | grep "^  5" >  ListePflDruck_ASV-Koppelkoppel.spm
cat temp | grep "^  6" >> ListePflDruck_ASV-Koppelkoppel.spm
cat temp | grep "^  7" >> ListePflDruck_ASV-Koppelkoppel.spm
cat temp | grep "^  8" >> ListePflDruck_ASV-Koppelkoppel.spm
cat temp | grep "^  9" >> ListePflDruck_ASV-Koppelkoppel.spm
cat temp | grep "^  10" >> ListePflDruck_ASV-Koppelkoppel.spm

cat ListePflDruck_ASV-Koppelkoppel.spm\
| awk 'BEGIN{vor="HALLO";}; 
    {if(vor ~ $5)
           {print $0}
     else  {print "\n" $0}; 
     vor=$5;}' > temp
mv temp ListePflDruck_ASV-Koppelkoppel.spm
# sortieren
csplit -s -f splitted -n 3 ListePflDruck_ASV-Koppelkoppel.spm /^$/ {*}
for file in splitted0*; do cat $file  | sort -k 2,2 -k 3,3 > ${file}.sort; done
rm -f new-order.spm; for file in splitted0*.sort; do cat $file >> new-order.spm; done
mv new-order.spm ListePflDruck_ASV-Koppelkoppel.spm

awk '{if ($5=="I" || $6=="I"){print $0}}' ListePflDruck_ASV-ohne_Reli_Sport.spm > ListePflDruck_ASV-Intensivierung.spm

awk '{if ($2=="K"   || $2=="Ev_1" || $2=="Eth"){print $0}}' ListePflDruck_ASV.spm > ListePflDruck_ASV-Reli.spm
for i in $(seq 5 10); do awk '/^ *'''$i'''/' ListePflDruck_ASV-Reli.spm | sort -k 2; echo " "; done > ListePflDruck_ASV-Reli_sort.spm

awk '{if ($2=="Smw" || $2=="Sm" || $2=="Sw" || $2=="Sw_1" || $2=="Sw_2"){print $0}}' ListePflDruck_ASV.spm > ListePflDruck_ASV-Sport.spm
for i in $(seq 5 10); do awk '/^ *'''$i'''/' ListePflDruck_ASV-Sport.spm | sort -k 2; echo " "; done > ListePflDruck_ASV-Sport_sort.spm

awk '{print $3}' ListePflDruck_ASV.spm | iconv -f iso8859-15 -t utf8  | sort | uniq | awk '{if ($1=="1" || $1=="Lehr" || $1=="kraft"){} else {print $0}}' | iconv -f utf8 -t iso8859-15 > Lehrer

# unwichtige weg (evtl. anpassen!)
rm ListePflDruck_ASV-Koppelklasse.spm ListePflDruck_ASV-ohne_Lehrer.spm ListePflDruck_ASV-Reli.spm ListePflDruck_ASV-Sport.spm ListePflDruck_ASV-ohne_Reli_Sport.spm
rm order-number-sort splitted* # new-order.spm

# cp export.csv export00.csv
# cat export00.csv | tr '\t' ';' > export01.csv
# cat export01.csv | iconv -f iso8859-1 -t utf8 | sort -t ';' -k 2,2 -k1,1 | column -s ';' -t > export02-column.csv
