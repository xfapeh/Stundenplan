echo "--------------------make_Raumstundenpläne.sh-----------------------------------------"
#
#num=54 <- aus split einlesen s.u.
#
cat Raum1.CSV | iconv -f iso8859-15 -t utf8 > temp.csv
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Raum-latex.csv
cat Raum-latex.csv | awk '/SPM++/ {gsub(/ ?SPM++.*,r/, "r"); gsub(/,+/, ",");}; !/SPM++/ {print $0}' > temp && mv temp Raum-latex.csv
awk ''/^r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?[A-Za-z0-9]?,?[A-Za-z0-9]?[A-Za-z0-9]?[A-Za-z0-9]?,Mo,Di,Mi,Do,Fr$/' { out = sprintf("Raum-latex-%02d.csv", ++i); print > out } !'/^r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?[A-Za-z0-9]?,?[A-Za-z0-9]?[A-Za-z0-9]?[A-Za-z0-9]?,Mo,Di,Mi,Do,Fr$/' { out = sprintf("Raum-latex-%02d.csv", i); print > out }' Raum-latex.csv
#
# Anzahl aus split Dateien einlesen
num=$(ls -1 Raum-latex-*.csv | wc -l)
echo "$num Raumstundenpläne erstellen"
#
for ((i=1; i<=$num; i++)); do
#for i in 3 21 44; do
cat Raum-latex-$(printf "%02d" $i).csv | awk '!/^ *$/' | sed 's/^r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]\?[A-Za-z0-9]\?,/&ß/g' | sed 's/,ß/ /g' | sed 's/ Mo,/ ,Mo,/g'> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Raum-latex-$(printf "%02d" $i).csv
raum="$(cat Raum-latex-$(printf "%02d" $i).csv | awk '/^r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?[A-Za-z0-9]? ?[A-Za-z0-9]?[A-Za-z0-9]?[A-Za-z0-9]?,Mo,Di,Mi,Do,Fr$/ {gsub(/ .*$/, "");print $0}')"
klasse="$(cat Raum-latex-$(printf "%02d" $i).csv | awk '/^r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?[A-Za-z0-9]? ?[A-Za-z0-9]?[A-Za-z0-9]?[A-Za-z0-9]?,Mo,Di,Mi,Do,Fr$/ {gsub(/,.*$/, "");gsub(/^r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?[A-Za-z0-9]? /, "");print $0}')"
#
printf "%02d:_%s " $i $raum
#
if [ "$klasse" = "" ]; then klasse="\\\\hspace*{2.2cm}"; else klasse="(Kl. \\ $klasse )"; fi
cat Raum-latex-$(printf "%02d" $i).csv | awk '{gsub(/r[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?[A-Za-z0-9]? ?[A-Za-z0-9]?[A-Za-z0-9]?[A-Za-z0-9]?,/, " ,");print $0}' > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Raum-latex-$(printf "%02d" $i).csv
cat Raum-latex-$(printf "%02d" $i).csv | iconv -f utf8 -t iso8859-15  > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Raum-latex-$(printf "%02d" $i).csv
csv2pdf --in Raum-latex-$(printf "%02d" $i).csv --theme NYC5 --outputlatex > Raum-latex-$(printf "%02d" $i)_main.tex
iconv -f iso8859-15 -t utf8 Raum-latex-$(printf "%02d" $i).tex > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Raum-latex-$(printf "%02d" $i).tex
cat Raum-latex-$(printf "%02d" $i).tex | sed -e 's/|l/|p{2cm}/g' | sed -e 's/|r/|p{2cm}/g' | sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}    \\\\.\\hline//g;p;}' | sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}    \\\\.\\hline//g;p;}' | sed 's/\\begin{longtable}{|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|}/\\begin{longtable}{ | >{\\noindent\\begin{minipage}[t][2.43cm]{1cm}}p{1.6cm}<{\\newline\\end{minipage}} | p{3cm} | p{3cm} | p{3cm} | p{3cm} | p{3cm} |}/g' | sed 's/78,130,190/144,12,12/g' > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Raum-latex-$(printf "%02d" $i).tex
sed 's/ [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\? \\newline [a-zA-Z][a-zA-Z]\?[a-zA-Z]\?[a-zA-Z]\?\\newline r[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?\\newline [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?/ \\begin{minipage}[t]{1.9cm} & \\end{minipage}/g' Raum-latex-$(printf "%02d" $i).tex | sed 's/ \+/ /g' | sed 's/\\end{minipage} \\newline \\begin{minipage}/\\end{minipage} \\hfill \\begin{minipage}/g' | sed 's/\\end{minipage}/\\newline\\end{minipage}/g'> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Raum-latex-$(printf "%02d" $i).tex
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=21.9cm, paperheight=36.3cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/ {print $0 "\n\\thispagestyle{empty}\\fontsize{20pt}{12pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}MWG \\hfill Raum \\ \\ \\ \\ \\ \\fontsize{36pt}{12pt}\\selectfont '''$raum'''\\fontsize{20pt}{12pt}\\selectfont \\ \\ \\ \\ \\ '''"$klasse"'''\\hfill '''"`date +%d"."%m"."%Y`"'''\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{20pt}{24pt}\\fontspec{SourceSansPro-Semibold}";next} 1' Raum-latex-$(printf "%02d" $i)_main.tex \
> temp 2>> log && mv temp Raum-latex-$(printf "%02d" $i)_main.tex
# wenn anderes Datum
# | sed 's/11.09.2014/10.09.2014/g'
if (( $i == $num )); then
lualatex Raum-latex-$(printf "%02d" $i)_main.tex >> log
elif (( $i % 12 )); then 
lualatex Raum-latex-$(printf "%02d" $i)_main.tex >> log &
else 
lualatex Raum-latex-$(printf "%02d" $i)_main.tex >> log 
fi;
done
for ((i=1; i<=$num; i++)); do
rm Raum-latex-$(printf "%02d" $i)_main.tex Raum-latex-$(printf "%02d" $i).tex
rm Raum-latex-$(printf "%02d" $i)_main.log Raum-latex-$(printf "%02d" $i)_main.aux Raum-latex-$(printf "%02d" $i).pdf
#rm Raum-latex-$(printf "%02d" $i).csv
mv Raum-latex-$(printf "%02d" $i)_main.pdf Raum_$(printf "%02d" $i).pdf
done
echo ""
#
pdftk Raum_[0-9][0-9].pdf cat output Raumstundenpläne.pdf
gs -o Raumstundenpläne_printA4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Raumstundenpläne.pdf >> log 2>> log
mv Raumstundenpläne_printA4.pdf Raumstundenpläne.pdf
rm Raum_[0-9][0-9].pdf Raum-latex*.csv temp.csv

