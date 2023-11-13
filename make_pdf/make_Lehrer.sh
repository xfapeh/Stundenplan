#!/bin/bash
echo "--------------------make_Lehrer.sh---------------------------------------------------"
echo "Lehrerplan"
height=138.0
# Inst weg & Co weg
iconv -f iso8859-15 -t utf8 Lehrer.CSV > temp 
cat temp \
| awk 'BEGIN {flag=0} 
      /Inst.?;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Msl;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Del;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Reg;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Stu;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Hmm;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Che;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Ifl;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Loz;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
      /Wen;/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
 > temp.csv
iconv -f utf8 -t iso8859-15 temp.csv > temp && mv temp temp.csv
# aus SPM Lehrer.CSV -> " weg. ;->, , carriage returns -> latex \\, \n -> @ -> \newline, Zeilenenden bereinigen, Letzte Spalte weg
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Lehrer-latex.csv
#
csv2pdf --in Lehrer-latex.csv --theme NYC5 --outputlatex > Lehrer-latex_main.tex
#
iconv -f iso8859-15 -t utf8 Lehrer-latex.tex > temp && mv temp Lehrer-latex.tex
# alle columns p{1cm}, letzte Zeile unten weg
cat Lehrer-latex.tex | sed -e 's/|l/|p{1cm}/g' | sed -e 's/|r/|p{1cm}/g' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}      \\\\.\\hline//g;p;}' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}      \\\\.\\hline//g;p;}' | \
sed -e 's/|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/g'  | \
sed -e 's/\\rowcolor{latextbl!10}/\\rowcolor{latextbl!10}\\setlength{\\hfuzz}{200pt}/g'  | \
sed -e 's/\\rowcolor{latextbl!01}/\\rowcolor{latextbl!01}\\setlength{\\hfuzz}{200pt}/g' \
> temp && mv temp Lehrer-latex.tex
# zu lange Klassen -> kleinere Schriftart
echo -n "cat Lehrer-latex.tex | " > temp.sh
for long in 10ABCEL 10ABEFs 10CDEF1 10CDEF2 5CDEKu1 5CDEKu2 7CDEMu1 7CDEMu2 8BCDSw1 8BCDSw2 10CEsSp1 10CEsSp2 9ABCmKu1 9ABCmKu2 10ABESps1 10ABESps2 10DInt1 10DInt2; 
do echo -n "sed 's/$long\\\\newline /\\\\fontsize{9pt}{10pt}\\\\selectfont$long\\\\fontsize{12pt}{10pt}\\\\selectfont\\\\rule{0cm}{11pt}\\\\newline\\\\rule{0cm}{11pt}/g' | "; done >> temp.sh
echo -n "sed 's/Blindtext/Blindtext/g' > temp && mv temp Lehrer-latex.tex" >> temp.sh
chmod +x temp.sh
./temp.sh && rm temp.sh
#
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=91.8cm, paperheight='''$height'''cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/ {print $0 "\n\\thispagestyle{empty}\\fontsize{12pt}{10pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}Markgräfin Wilhelmine Gymnasium \\hfill Lehrerstundenplan \\hfill Stand: '''"`date +%A", "%d". "%B" "%Y`"'''{ }\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{12pt}{13pt}\\fontspec{SourceSansPro-Semibold}\\setlength{\\hfuzz}{200pt}";next} 1' Lehrer-latex_main.tex \
> temp 2>> log && mv temp Lehrer-latex_main.tex
# wenn anderes Datum --date="20140910 12:30" 
# '''"`date +%A", "%d". "%B" "%Y"\ \ "%H":"%M`"'''{ }
#
echo ">> Erstelle Lehrerplan"
lualatex Lehrer-latex_main.tex >> log
#
#okular Lehrer-latex_main.pdf
#
rm Lehrer-latex.* Lehrer-latex_main.aux Lehrer-latex_main.log Lehrer-latex_main.tex temp.csv
#
mv Lehrer-latex_main.pdf Lehrer.pdf
