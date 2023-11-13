shopt -s extglob
echo "--------------------make_Lehrerstundenpläne.sh---------------------------------------"
#
#num=94   # oder besser aus split einlesen? JA! s.u.
#
cat Lehrer1.CSV | iconv -f iso8859-15 -t utf8 > temp.csv
#
# aus SPM Lehrer.CSV -> " weg. ;->, , carriage returns -> latex \\, \n -> @ -> \newline, Zeilenenden bereinigen, Letzte Spalte weg
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Lehrer-latex.csv
#
# 
cat Lehrer-latex.csv | awk '/SPM++/ {gsub(/202[0-9],/, ""); gsub(/,,,/, ",");  print $9}; !/SPM++/ {print $0}' > temp && mv temp Lehrer-latex.csv
#
# csv Datei in einzelne Dateien Lehrer-latex-05.csv aufsplitten anhand Kopfzeile mit Mo,Di,Mi,Do,Fr
awk ''/^[A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß]t?,Mo,Di,Mi,Do,Fr$/' { out = sprintf("Lehrer-latex-%03d.csv", ++i); print > out } !'/^[A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß]t?,Mo,Di,Mi,Do,Fr$/' { out = sprintf("Lehrer-latex-%03d.csv", i); print > out }' Lehrer-latex.csv
#
# Anzahl aus split Dateien einlesen
num=$(ls -1 Lehrer-latex-*.csv | wc -l)
echo "$num Lehrerstundenpläne erstellen"
#
# Einzelne csv Dateien in LaTeX umwandeln
for ((i=1; i<=$num; i++)); do
#for i in 1 2 3 4 5 6 7 8 9 10; do
#       03 21                39 42 43 49 52 55 56 57 59    63 66    74 77 80 84 85 88
lehrer=$(cat Lehrer-latex-$(printf "%03d" $i).csv | awk '/^[A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß][A-ZÄÖÜa-zäöüß]t?,Mo,Di,Mi,Do,Fr$/ {gsub(/,.*$/, "");print $0}')
#
printf "%03d:_%s " $i $lehrer
#
# Leerzeilen weg
cat Lehrer-latex-$(printf "%03d" $i).csv | awk '!/^ *$/' > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i).csv
# 
cat Lehrer-latex-$(printf "%03d" $i).csv | iconv -f utf8 -t iso8859-15  > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i).csv
# csv2pdf erwartet iso8859-15
csv2pdf --in Lehrer-latex-$(printf "%03d" $i).csv --theme NYC5 --outputlatex > Lehrer-latex-$(printf "%03d" $i)_main.tex
# 
iconv -f iso8859-15 -t utf8 Lehrer-latex-$(printf "%03d" $i).tex > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i).tex
# 
# alle columns p{2cm}, letzte Zeile unten weg, Minipage für feste Zellenhöhen, p{2cm} -> p{3cm}, Farbe blau -> rot
cat Lehrer-latex-$(printf "%03d" $i).tex\
| sed -e 's/|l/|p{2cm}/g' \
| sed -e 's/|r/|p{2cm}/g' \
| sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}    \\\\.\\hline//g;p;}' \
| sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}    \\\\.\\hline//g;p;}' \
| sed 's/\\begin{longtable}{|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|}/\\begin{longtable}{ | >{\\noindent\\begin{minipage}[t][2.11cm]{1cm}}p{1.6cm}<{\\newline\\end{minipage}} | p{3cm} | p{3cm} | p{3cm} | p{3cm} | p{3cm} |}/g' \
| sed 's/78,130,190/144,12,12/g' > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i).tex
#
# Minipage einbauen, multiple Leerzeichen weg, hfill einbauen
# search for Fach(1-5) Lehrer(0-4) Raum(r0-4) Klasse(1-10) // Klassenlänge checken!!
sed 's/ [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\? \\newline [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?\\newline r\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?/ \\begin{minipage}[t]{1.9cm} & \\end{minipage}/g' Lehrer-latex-$(printf "%03d" $i).tex \
| sed 's/ \+/ /g' \
| sed 's/\\end{minipage} \\newline \\begin{minipage}/\\end{minipage} \\hfill \\begin{minipage}/g' \
> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i).tex
#| sed 's/\\end{minipage}/\\newline\\end{minipage}/g'\
#
# Formatierungen, Lehrername, Datum
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=21.9cm, paperheight=30.9cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/ {print $0 "\n\\thispagestyle{empty}\\fontsize{18pt}{12pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}MWG \\hfill Lehrer '''$lehrer''' \\hfill '''"`date +%d"."%m"."%Y`"'''\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{18pt}{20pt}\\fontspec{SourceSansPro-Semibold}";next} 1' Lehrer-latex-$(printf "%03d" $i)_main.tex \
> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i)_main.tex
# wenn anderes Datum
# | sed 's/11.09.2014/10.09.2014/g'
#
#
#
sed 's/\\usepackage{xcolor}/\\usepackage[usenames,dvipsnames]{xcolor}/g' Lehrer-latex-$(printf "%03d" $i)_main.tex > temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i)_main.tex
cat Lehrer-latex-$(printf "%03d" $i).tex \
| sed    's/{78,130,190}/{120,120,120}/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5[^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6[^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7[^&]*/\&\\cellcolor{violet!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8[^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9[^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10[^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 11[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5A[^&]*/\&\\cellcolor{Yellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5B[^&]*/\&\\cellcolor{Peach!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5C[^&]*/\&\\cellcolor{Bittersweet!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5D[^&]*/\&\\cellcolor{Goldenrod!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5E[^&]*/\&\\cellcolor{BrickRed!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 5F[^&]*/\&\\cellcolor{RedOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6A[^&]*/\&\\cellcolor{OrangeRed!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6B[^&]*/\&\\cellcolor{WildStrawberry!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6C[^&]*/\&\\cellcolor{RubineRed!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6D[^&]*/\&\\cellcolor{Mulberry!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6E[^&]*/\&\\cellcolor{Thistle!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 6F[^&]*/\&\\cellcolor{OrangeRed!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7A[^&]*/\&\\cellcolor{Violet!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7B[^&]*/\&\\cellcolor{RoyalPurple!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7C[^&]*/\&\\cellcolor{Periwinkle!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7D[^&]*/\&\\cellcolor{CadetBlue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7E[^&]*/\&\\cellcolor{Plum!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 7F[^&]*/\&\\cellcolor{BlueGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8A[^&]*/\&\\cellcolor{CornflowerBlue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8B[^&]*/\&\\cellcolor{MidnightBlue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8C[^&]*/\&\\cellcolor{RoyalBlue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8D[^&]*/\&\\cellcolor{Blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8E[^&]*/\&\\cellcolor{Cerulean!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 8F[^&]*/\&\\cellcolor{BlueGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9A[^&]*/\&\\cellcolor{Turquoise!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9B[^&]*/\&\\cellcolor{TealBlue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9C[^&]*/\&\\cellcolor{BlueGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9D[^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9E[^&]*/\&\\cellcolor{LimeGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 9F[^&]*/\&\\cellcolor{BrickRed!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10A[^&]*/\&\\cellcolor{Green!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10B[^&]*/\&\\cellcolor{ForestGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10C[^&]*/\&\\cellcolor{LimeGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10D[^&]*/\&\\cellcolor{GreenYellow!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10E[^&]*/\&\\cellcolor{OliveGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10F[^&]*/\&\\cellcolor{Cerulean!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10G[^&]*/\&\\cellcolor{Bittersweet!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline 10H[^&]*/\&\\cellcolor{Goldenrod!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline Q11[^&]*/\&\\cellcolor{RawSienna!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline Q12[^&]*/\&\\cellcolor{Tan!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline Q50[^&]*/\&\\cellcolor{Tan!25}&/g' \
| sed -e 's/&[^&][A-Za-z0-9]* \\newline Q11[^&]*/\&\\cellcolor{RawSienna!25}&/g' \
| sed -e 's/&[^&][A-Za-z0-9]* \\newline Q12[^&]*/\&\\cellcolor{Tan!25}&/g' \
| sed -e 's/&[^&][A-Za-z0-9]* \\newline Q50[^&]*/\&\\cellcolor{Tan!25}&/g' \
| sed -e 's/&[^&]Stuzi \\newline \\newline rStu[A-Za-z0-9]*[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]Kol[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline OSK[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]Dir[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]Team[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]Komp[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]heim[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&][A-Za-z0-9]* \\newline Cafe[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]Per[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&]Unipr[^&]*/\&\\cellcolor{orange!25}&/g' \
| sed -e 's/&[^&][A-Za-z0-9][A-Za-z0-9]\?Int[A-Za-z0-9][A-Za-z0-9]\?[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]LBgl[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]TecPur[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]MM[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Film[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Vol[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Bask[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Fußb[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Lit[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Umwelt[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Judo[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Sani[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]SpCo[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]CybM[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Swi[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]MPlus[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]blu[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]MChal[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]Tanz[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]SZ[^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]CoptMB[^&]*/\&\\cellcolor{BlueGreen!25}&/g' \
| sed -e 's/&[^&]FilmMB[^&]*/\&\\cellcolor{BlueGreen!25}&/g' \
| sed -e 's/&[^&]JuFo[^&]*/\&\\cellcolor{RubineRed!25}&/g' \
| sed -e 's/&[^&]Rob[^&]*/\&\\cellcolor{RoyalBlue!25}&/g' \
| sed 's/\\cellcolor{yellow!25}&/\\cellcolor{yellow!25}/g' \
| sed 's/\\cellcolor{red!25}&/\\cellcolor{red!25}/g' \
| sed 's/\\cellcolor{violet!25}&/\\cellcolor{violet!25}/g' \
| sed 's/\\cellcolor{blue!25}&/\\cellcolor{blue!25}/g' \
| sed 's/\\cellcolor{cyan!25}&/\\cellcolor{cyan!25}/g' \
| sed 's/\\cellcolor{green!25}&/\\cellcolor{green!25}/g' \
| sed 's/\\cellcolor{Yellow!25}&/\\cellcolor{Yellow!25}/g' \
| sed 's/\\cellcolor{Peach!25}&/\\cellcolor{Peach!25}/g' \
| sed 's/\\cellcolor{Bittersweet!25}&/\\cellcolor{Bittersweet!25}/g' \
| sed 's/\\cellcolor{Goldenrod!25}&/\\cellcolor{Goldenrod!25}/g' \
| sed 's/\\cellcolor{BrickRed!25}&/\\cellcolor{BrickRed!25}/g' \
| sed 's/\\cellcolor{RedOrange!25}&/\\cellcolor{RedOrange!25}/g' \
| sed 's/\\cellcolor{OrangeRed!25}&/\\cellcolor{OrangeRed!25}/g' \
| sed 's/\\cellcolor{WildStrawberry!25}&/\\cellcolor{WildStrawberry!25}/g' \
| sed 's/\\cellcolor{RubineRed!25}&/\\cellcolor{RubineRed!25}/g' \
| sed 's/\\cellcolor{Mulberry!25}&/\\cellcolor{Mulberry!25}/g' \
| sed 's/\\cellcolor{Thistle!25}&/\\cellcolor{Thistle!25}/g' \
| sed 's/\\cellcolor{Violet!25}&/\\cellcolor{Violet!25}/g' \
| sed 's/\\cellcolor{RoyalPurple!25}&/\\cellcolor{RoyalPurple!25}/g' \
| sed 's/\\cellcolor{Periwinkle!25}&/\\cellcolor{Periwinkle!25}/g' \
| sed 's/\\cellcolor{CadetBlue!25}&/\\cellcolor{CadetBlue!25}/g' \
| sed 's/\\cellcolor{Plum!25}&/\\cellcolor{Plum!25}/g' \
| sed 's/\\cellcolor{CornflowerBlue!25}&/\\cellcolor{CornflowerBlue!25}/g' \
| sed 's/\\cellcolor{MidnightBlue!25}&/\\cellcolor{MidnightBlue!25}/g' \
| sed 's/\\cellcolor{RoyalBlue!25}&/\\cellcolor{RoyalBlue!25}/g' \
| sed 's/\\cellcolor{Blue!25}&/\\cellcolor{Blue!25}/g' \
| sed 's/\\cellcolor{Cerulean!25}&/\\cellcolor{Cerulean!25}/g' \
| sed 's/\\cellcolor{Turquoise!25}&/\\cellcolor{Turquoise!25}/g' \
| sed 's/\\cellcolor{TealBlue!25}&/\\cellcolor{TealBlue!25}/g' \
| sed 's/\\cellcolor{BlueGreen!25}&/\\cellcolor{BlueGreen!25}/g' \
| sed 's/\\cellcolor{Emerald!25}&/\\cellcolor{Emerald!25}/g' \
| sed 's/\\cellcolor{Green!25}&/\\cellcolor{Green!25}/g' \
| sed 's/\\cellcolor{ForestGreen!25}&/\\cellcolor{ForestGreen!25}/g' \
| sed 's/\\cellcolor{LimeGreen!25}&/\\cellcolor{LimeGreen!25}/g' \
| sed 's/\\cellcolor{GreenYellow!25}&/\\cellcolor{GreenYellow!25}/g' \
| sed 's/\\cellcolor{OliveGreen!25}&/\\cellcolor{OliveGreen!25}/g' \
| sed 's/\\cellcolor{RawSienna!25}&/\\cellcolor{RawSienna!25}/g' \
| sed 's/\\cellcolor{Tan!25}&/\\cellcolor{Tan!25}/g' \
| sed 's/\\cellcolor{orange!25}&/\\cellcolor{orange!25}/g' \
| sed 's/\\cellcolor{Gray!25}&/\\cellcolor{Gray!25}/g' \
| sed -e 's/& /&/g' \
| sed -e 's/!25} /!25}/g' \
> temp-$(printf "%02d" $i) && mv temp-$(printf "%02d" $i) Lehrer-latex-$(printf "%03d" $i).tex
#
#
#
#
if (( $i == $num )); then
lualatex Lehrer-latex-$(printf "%03d" $i)_main.tex >> log
elif (( $i % 12 )); then 
lualatex Lehrer-latex-$(printf "%03d" $i)_main.tex >> log &
else 
lualatex Lehrer-latex-$(printf "%03d" $i)_main.tex >> log
fi;
done
#
for ((i=1; i<=$num; i++)); do
rm Lehrer-latex-$(printf "%03d" $i)_main.tex Lehrer-latex-$(printf "%03d" $i).tex
rm Lehrer-latex-$(printf "%03d" $i)_main.log Lehrer-latex-$(printf "%03d" $i)_main.aux Lehrer-latex-$(printf "%03d" $i).pdf
#rm Lehrer-latex-$(printf "%03d" $i).csv
mv Lehrer-latex-$(printf "%03d" $i)_main.pdf Lehrer_$(printf "%03d" $i).pdf
done
echo ""
#
pdftk Lehrer_[0-9][0-9][0-9].pdf cat output Lehrerstundenpläne.pdf
gs -o Lehrerstundenpläne_A4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Lehrerstundenpläne.pdf >> log 2>> log
cp -a Lehrerstundenpläne_A4.pdf Lehrerstundenpläne.pdf

typeset -i i
typeset -i j
typeset -i k
i=$num
j=$i/2
k=$j
# Komplettausdruck für alle Kollegen zentral
# pdftk Lehrerstundenpläne_A4.pdf cat $(\
# for ((o=1;o<=$k;o++))
#   do
#    echo -n "$o $((++j)) ";
#    if [ $o -eq $k ] && [ $j -lt $i ]
#      then echo $i
#    fi
#   done) output Lehrerstundenpläne_A4_temp.pdf
#
# Download für Kollegen zum selbst ausdrucken
pdftk Lehrerstundenpläne_A4.pdf cat $(\
for ((o=1;o<=$num;o++))
  do    
    echo -n "$o $o ";
  done) output Lehrerstundenpläne_A4_temp.pdf

pdfnup Lehrerstundenpläne_A4_temp.pdf >> log 2>> log

# test wegen PDFjam 2x1 va nup
if [ -a Lehrerstundenpläne_A4_temp-nup.pdf ] ; then mv Lehrerstundenpläne_A4_temp-nup.pdf Lehrerstundenpläne_A4_temp-2x1.pdf; fi
mv Lehrerstundenpläne_A4_temp-2x1.pdf Lehrerstundenpläne_2x-auf-A4.pdf
rm Lehrer_[0-9][0-9][0-9].pdf Lehrer-latex*.csv Lehrerstundenpläne_A4.pdf Lehrerstundenpläne_A4_temp.pdf temp.csv 
#
# alter A3 Drucker packt alle Seiten nicht auf einmal
# pdftk Lehrerstundenpläne_printA4.pdf cat  1-20  output Lehrerstundenpläne_printA4_01.pdf
# pdftk Lehrerstundenpläne_printA4.pdf cat 21-40  output Lehrerstundenpläne_printA4_02.pdf
# pdftk Lehrerstundenpläne_printA4.pdf cat 41-end output Lehrerstundenpläne_printA4_03.pdf

