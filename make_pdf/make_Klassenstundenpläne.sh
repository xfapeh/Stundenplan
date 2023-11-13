echo "--------------------make_Klassenstundenpläne.sh--------------------------------------"
#
#num=32 <- aus split einlesen s.u.
#
height=48.5
cat Klasse1.CSV | iconv -f iso8859-15 -t utf8 > temp.csv
#
# aus SPM Klasse.CSV -> " weg. ;->, , carriage returns -> latex \\, \n -> @ -> \newline, Zeilenenden bereinigen, Letzte Spalte weg
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Klasse-latex.csv
#
#
cat Klasse-latex.csv | awk '/SPM++/ {gsub(/202[0-9],/, ""); gsub(/,,r...?.?,/, ",");  print $9}; !/SPM++/ {print $0}' > temp && mv temp Klasse-latex.csv
#
# csv Datei in einzelne Dateien Lehrer-latex-05.csv aufsplitten anhand Kopfzeile mit Mo,Di,Mi,Do,Fr
awk ''/^[0-9][0-9]?[a-h],Mo,Di,Mi,Do,Fr$/' { out = sprintf("Klasse-latex-%02d.csv", ++i); print > out } !'/^[0-9][0-9]?[a-h],Mo,Di,Mi,Do,Fr$/' { out = sprintf("Klasse-latex-%02d.csv", i); print > out }' Klasse-latex.csv
#
# Anzahl aus split Dateien einlesen
num=$(ls -1 Klasse-latex-*.csv | wc -l)
echo "$num Klassenstundenpläne erstellen"
#
# Einzelne csv Dateien in LaTeX umwandeln
for ((i=1; i<=$num; i++)); do
#for i in 10 11 29; do
klasse=$(cat Klasse-latex-$(printf "%02d" $i).csv | awk '/^[0-9][0-9]?[a-h],Mo,Di,Mi,Do,Fr$/ {gsub(/,.*$/, "");print $0}')
#
printf "%02d:_%s " $i $klasse
#
# Leerzeilen weg
cat Klasse-latex-$(printf "%02d" $i).csv | awk '!/^ *$/' > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i).csv
#
cat Klasse-latex-$(printf "%02d" $i).csv | iconv -f utf8 -t iso8859-15  > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i).csv
# csv2pdf erwartet iso8859-15
csv2pdf --in Klasse-latex-$(printf "%02d" $i).csv --theme NYC5 --outputlatex > Klasse-latex-$(printf "%02d" $i)_main.tex
#
iconv -f iso8859-15 -t utf8 Klasse-latex-$(printf "%02d" $i).tex > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i).tex
#
# alle columns p{2cm}, letzte Zeile unten weg, Minipage für feste Zellenhöhen, p{2cm} -> p{6cm}, Farbe blau -> rot
cat Klasse-latex-$(printf "%02d" $i).tex \
| sed -e 's/|l/|p{2cm}/g' \
| sed -e 's/|r/|p{2cm}/g' \
| sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}    \\\\.\\hline//g;p;}' \
| sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}    \\\\.\\hline//g;p;}' \
| sed 's/\\begin{longtable}{|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|}/\\begin{longtable}{ | >{\\noindent\\begin{minipage}[t][2.43cm]{1cm}}p{1cm}<{\\newline\\end{minipage}} | p{6cm} | p{6cm} | p{6cm} | p{6cm} | p{6cm} |}/g' \
| sed 's/78,130,190/144,12,12/g' > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i).tex
#
# Minipage einbauen, multiple Leerzeichen weg, hfill einbauen
# search for Fach(1-5) Lehrer(0-5) Raum(r0-4) Klasse(1-10) // Klassenlänge checken!!
sed 's/ [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\? \\newline [a-zA-Z]\?[a-zA-Z]\?[a-zA-Z]\?[a-zA-Z]\?[a-zA-Z0-9]\?\\newline r\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?\\newline [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?/ \\begin{minipage}[t]{1.9cm} & \\end{minipage}/g' Klasse-latex-$(printf "%02d" $i).tex \
| sed 's/ \+/ /g' \
| sed 's/\\end{minipage} \\newline \\begin{minipage}/\\end{minipage} \\hfill \\begin{minipage}/g' \
| sed 's/\\end{minipage}/\\newline\\end{minipage}/g'> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i).tex
#
# Formatierungen, Klassenbezeichnung, Datum
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=35.9cm, paperheight='''$height'''cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/ {print $0 "\n\\thispagestyle{empty}\\fontsize{14pt}{10pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}MWG \\hfill Klasse '''$klasse''' \\hfill '''"`date +%d"."%m"."%Y`"'''\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{14pt}{15pt}\\fontspec{SourceSansPro-Semibold}";next} 1' Klasse-latex-$(printf "%02d" $i)_main.tex \
> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i)_main.tex
# wenn anderes Datum
# | sed 's/11.09.2014/10.09.2014/g'
#
#
#
sed 's/\\usepackage{xcolor}/\\usepackage[usenames,dvipsnames]{xcolor}/g' Klasse-latex-$(printf "%02d" $i)_main.tex > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i)_main.tex
cat Klasse-latex-$(printf "%02d" $i).tex \
| sed    's/{78,130,190}/{120,120,120}/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]M [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]MIF [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]MInt [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]D [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]DInt [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]DIF [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]L [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]LInt [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]LIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]F [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]FInt [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]FIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Fs [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sp [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]SpIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sps [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]E [^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]EInt [^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]EIF [^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Mu [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]3Mus [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Ku [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Ev [^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Eth [^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]K [^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Ph [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]PhIF [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Inf [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]SpInf [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]NuT [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Exp [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]B [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]C [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]G [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sk [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]PuG [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Geo [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]WR [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Smw [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sm [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sw [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Peso [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Spr [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Coach [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]BO [^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]ILV [^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]LeF [^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]PSem [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]frei [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed 's/\\cellcolor{blue!25}&/\\cellcolor{blue!25}/g' \
| sed 's/\\cellcolor{red!25}&/\\cellcolor{red!25}/g' \
| sed 's/\\cellcolor{magenta!25}&/\\cellcolor{magenta!25}/g' \
| sed 's/\\cellcolor{green!25}&/\\cellcolor{green!25}/g' \
| sed 's/\\cellcolor{yellow!25}&/\\cellcolor{yellow!25}/g' \
| sed 's/\\cellcolor{cyan!25}&/\\cellcolor{cyan!25}/g' \
| sed 's/\\cellcolor{Emerald!25}&/\\cellcolor{Emerald!25}/g' \
| sed 's/\\cellcolor{YellowOrange!25}&/\\cellcolor{YellowOrange!25}/g' \
| sed 's/\\cellcolor{Gray!25}&/\\cellcolor{Gray!25}/g' \
| sed 's/\\cellcolor{JungleGreen!25}&/\\cellcolor{JungleGreen!25}/g' \
| sed -e 's/& /&/g' \
| sed -e 's/!25} /!25}/g' \
> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Klasse-latex-$(printf "%02d" $i).tex
if (( $i == $num )); then
lualatex Klasse-latex-$(printf "%02d" $i)_main.tex >> log	
elif (( $i % 12 )); then
lualatex Klasse-latex-$(printf "%02d" $i)_main.tex >> log &
else 
lualatex Klasse-latex-$(printf "%02d" $i)_main.tex >> log 
fi;
done
for ((i=1; i<=$num; i++)); do

rm Klasse-latex-$(printf "%02d" $i)_main.tex Klasse-latex-$(printf "%02d" $i).tex
rm Klasse-latex-$(printf "%02d" $i)_main.log Klasse-latex-$(printf "%02d" $i)_main.aux Klasse-latex-$(printf "%02d" $i).pdf
#rm Klasse-latex-$(printf "%02d" $i).csv
mv Klasse-latex-$(printf "%02d" $i)_main.pdf Klasse_$(printf "%02d" $i).pdf
done
echo ""
#
pdftk Klasse_[0-9][0-9].pdf cat output Klassenstundenpläne.pdf
gs -o Klassenstundenpläne_printA4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Klassenstundenpläne.pdf >> log 2>> log
mv Klassenstundenpläne_printA4.pdf Klassenstundenpläne.pdf
rm Klasse_[0-9][0-9].pdf Klasse-latex*.csv temp.csv #Klassenstundenpläne.pdf

