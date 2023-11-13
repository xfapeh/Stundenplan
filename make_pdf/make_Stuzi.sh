#!/bin/bash
echo "--------------------make_Stuzi.sh----------------------------------------------------"
echo "Stuziplan"
height=20.9
cat Raum.CSV \
| awk 'BEGIN {flag=0} 
     /;"Mo";/  {flag=1}; 
          {if(flag==1){print $0} } 
      /;\r$/ {flag=0;};' \
 > temp.csv
cat Raum.CSV \
| awk 'BEGIN {flag=0} 
     /"SPM..";/  {flag=1}; 
          {if(flag==1){print $0} } 
      /;\r$/ {flag=0;};' \
 >> temp.csv
cat Raum.CSV \
| awk 'BEGIN {flag=0} 
     /rStu/  {flag=1}; 
          {if(flag==1){print $0} } 
      /;\r$/ {flag=0;};' \
 >> temp.csv
# aus SPM Raum.CSV -> " weg. ;->, , carriage returns -> latex \\, \n -> @ -> \newline, Zeilenenden bereinigen, Letzte Spalte weg
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Raum-latex.csv
#
csv2pdf --in Raum-latex.csv --theme NYC5 --outputlatex > Raum-latex_main.tex
#
iconv -f iso8859-15 -t utf8 Raum-latex.tex > temp && mv temp Raum-latex.tex
# alle columns p{1cm}, letzte Zeile unten weg
#                      Raum: 1 Leerzeichen mehr!
cat Raum-latex.tex | sed -e 's/|l/|p{1cm}/g' | sed -e 's/|r/|p{1cm}/g' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}          \\\\.\\hline//g;p;}' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}          \\\\.\\hline//g;p;}' | \
sed -e 's/|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/|p{2cm}||p{0.6cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{0.6cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{0.6cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{0.6cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{0.6cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{0cm}|p{1cm}|p{1cm}|p{0cm}|p{0cm}|p{0cm}|/g' | \
sed -e 's/\\rowcolor{latextbl!10}/\\rowcolor{latextbl!10}\\setlength{\\hfuzz}{200pt}/g'  | \
sed -e 's/\\rowcolor{latextbl!01}/\\rowcolor{latextbl!01}\\setlength{\\hfuzz}{200pt}/g' \
> temp && mv temp Raum-latex.tex
#
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=65.5cm, paperheight='''$height'''cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/ {print $0 "\n\\setlength{\\hfuzz}{200pt}\\thispagestyle{empty}\\fontsize{11pt}{10pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}Markgräfin Wilhelmine Gymnasium \\hfill Stuziplan \\hfill Stand: '''"`date +%A", "%d". "%B" "%Y`"'''{ }\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{11pt}{11.9pt}\\fontspec{SourceSansPro-Semibold}\\setlength{\\hfuzz}{200pt}";next} 1' Raum-latex_main.tex \
> temp 2>> log && mv temp Raum-latex_main.tex
# '''"`date +%A", "%d". "%B" "%Y"\ \ "%H":"%M`"'''{ } <- Klammer! sonst 12957 Speicherzugriffsfehler
# wenn anderes Datum --date="20140910 12:30" 
# '''"`date +%A", "%d". "%B" "%Y"\ \ "%H":"%M`"'''
echo ">> Erstelle Stuziplan"
lualatex Raum-latex_main.tex >> log
#
#okular Raum-latex_main.pdf
#
rm Raum-latex.* Raum-latex_main.aux Raum-latex_main.log Raum-latex_main.tex temp.csv
#
mv Raum-latex_main.pdf Stuzi.pdf
