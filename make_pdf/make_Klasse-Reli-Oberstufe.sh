#!/bin/bash
echo "--------------------make_Klasse-Reli-Oberstufe.sh------------------------------------"
echo "Klassenplan, Reliplan und Oberstufenplan"
height=158
# reliheight=75.1
oberstufeheight=40
cat Klasse.CSV \
| awk 'BEGIN {flag=1} 
       /^..Mo./ {flag=1};
       /^.SPM./ {flag=1};
       /OSK/ {flag=1};
       /Q11/ {flag=1};
       /Q12/ {flag=1};
      /;\r$/ {if(flag==1){print $0};flag=0;};
          {if(flag==1){print $0} }' \
 > oberstufe.csv
# OSK, Q11, Q12, Ver, Stuz weg
cat Klasse.CSV \
| awk 'BEGIN {flag=0} 
       /OSK/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
       /Q11/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
       /Q12/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
       /Ver/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
       /Cafe/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
| awk 'BEGIN {flag=0} 
       /Stuz/ {flag=1}; 
          {if(flag==0){print $0} } 
      /;\r$/ {flag=0;};' \
 > temp.csv
# cat Klasse.CSV | sed '3,11d' > temp.csv
# aus SPM Klasse.CSV -> " weg. ;->, , carriage returns -> latex \\, \n -> @ -> \newline, Zeilenenden bereinigen, Letzte Spalte weg
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Klasse-latex.csv
cat oberstufe.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Oberstufe-latex.csv
#
#echo "csv2pdf --in Klasse-latex.csv"
csv2pdf --in Klasse-latex.csv --theme NYC5 --outputlatex > Klasse-latex_main.tex
#echo "csv2pdf --in Oberstufe-latex.csv"
csv2pdf --in Oberstufe-latex.csv --theme NYC5 --outputlatex > Oberstufe-latex_main.tex
#
iconv -f iso8859-15 -t utf8 Klasse-latex.tex > temp && mv temp Klasse-latex.tex
iconv -f iso8859-15 -t utf8 Oberstufe-latex.tex > temp && mv temp Oberstufe-latex.tex
# alle columns p{1cm}, letzte Zeile unten weg
# hfuzz wegen Speicherzugriffsfehler -> hfuzz in jeder Tabellenzeile auf 200pt
cat Klasse-latex.tex | sed -e 's/|l/|p{1cm}/g' | sed -e 's/|r/|p{1cm}/g' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}      \\\\.\\hline//g;p;}' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}      \\\\.\\hline//g;p;}' | \
sed -e 's/|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/g' | \
sed -e 's/\\rowcolor{latextbl!10}/\\rowcolor{latextbl!10}\\setlength{\\hfuzz}{200pt}/g'  | \
sed -e 's/\\rowcolor{latextbl!01}/\\rowcolor{latextbl!01}\\setlength{\\hfuzz}{200pt}/g' \
> temp && mv temp Klasse-latex.tex
# alle columns p{1cm}, letzte Zeile unten weg
# Farbe anpassen
# hfuzz wegen Speicherzugriffsfehler -> hfuzz in jeder Tabellenzeile auf 200pt
cat Oberstufe-latex.tex | sed -e 's/|l/|p{1cm}/g' | sed -e 's/|r/|p{1cm}/g' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!10}      \\\\.\\hline//g;p;}' | \
sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}      \\\\.\\hline//g;p;}' | \
sed -e 's/|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}||p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|/g' | \
sed    's/{78,130,190}/{120,120,120}/g' | \
sed -e 's/\\rowcolor{latextbl!10}/\\rowcolor{latextbl!10}\\setlength{\\hfuzz}{200pt}/g'  | \
sed -e 's/\\rowcolor{latextbl!01}/\\rowcolor{latextbl!01}\\setlength{\\hfuzz}{200pt}/g' \
> temp && mv temp Oberstufe-latex.tex
#
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=91.8cm, paperheight='''$height'''cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/  {print $0 "\n\\thispagestyle{empty}\\fontsize{14pt}{10pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}Markgräfin Wilhelmine Gymnasium \\hfill Klassenstundenplan \\hfill Stand: '''"`date +%A", "%d". "%B" "%Y`"'''{ }\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{14pt}{15pt}\\fontspec{SourceSansPro-Semibold}\\setlength{\\hfuzz}{200pt}";next} 1' Klasse-latex_main.tex \
> temp 2>> log && mv temp Klasse-latex_main.tex
# wenn anderes Datum --date="20140910 12:30"
# '''"`date +%A", "%d". "%B" "%Y"\ \ "%H":"%M`"'''
sed 's/\\usepackage{xcolor}/\\usepackage[usenames,dvipsnames]{xcolor}/g' Klasse-latex_main.tex > temp && mv temp Klasse-latex_main.tex
# Oberstufenplan
cat Klasse-latex_main.tex \
| sed 's/Klassenstundenplan/Oberstufenplan/g' \
| sed 's/Klasse-latex.tex/Oberstufe-latex.tex/g' \
| sed 's/'''$height'''/'''$oberstufeheight'''/g' \
> Oberstufe-latex_main.tex
#
cat Klasse-latex.tex \
| sed    's/{78,130,190}/{120,120,120}/g' \
| sed -e 's/&[^&]M [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]MIF [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]MInt [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]D [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]DInt [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]DIF [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]L [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]LInt [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]LIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]F [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]FInt [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]FIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]Fs [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]Sp [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]SpIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]Sps [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]E [^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]EInt [^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]EIF [^&]*/\&\\cellcolor{green!25}&/g' \
| sed -e 's/&[^&]Mu [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]3Mus [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]Ku [^&]*/\&\\cellcolor{yellow!25}&/g' \
| sed -e 's/&[^&]Eth [^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]K [^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]Ev [^&]*/\&\\cellcolor{cyan!25}&/g' \
| sed -e 's/&[^&]Ph [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]PhIF [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]Inf [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]NuT [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]Exp [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]B [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]C [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]G [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]Sk [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]PuG [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]Geo [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]WR [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]Smw [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]Sm [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]Sw [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]Peso [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]Spr [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]Coach [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]Digi [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]BO [^&]*/\&\\cellcolor{Gray!25}&/g' \
| sed -e 's/&[^&]ILV [^&]*/\&\\cellcolor{Gray!25}ILV /g' \
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
> temp && mv temp Klasse-latex.tex
#
echo ">> Erstelle Klassenplan"
lualatex Klasse-latex_main.tex >> log
#echo ">> Erstelle Reliplan"
#lualatex Reli-latex_main.tex >> log 
echo ">> Erstelle Oberstufenplan"
lualatex Oberstufe-latex_main.tex >> log
#
#
rm Klasse-latex.* Klasse-latex_main.aux Klasse-latex_main.log Klasse-latex_main.tex \
   Oberstufe-latex.* Oberstufe-latex_main.aux Oberstufe-latex_main.log Oberstufe-latex_main.tex oberstufe.csv temp.csv
#
#
#mv Klasse-latex_main.pdf Klasse.pdf
#mv Reli-latex_main.pdf Reli.pdf
#mv Oberstufe-latex_main.pdf Oberstufe.pdf 
#pdftk Klasse-latex_main.pdf Reli-latex_main.pdf Oberstufe-latex_main.pdf cat output Klasse.pdf
pdftk Klasse-latex_main.pdf Oberstufe-latex_main.pdf cat output Klasse.pdf
#rm Klasse-latex_main.pdf Reli-latex_main.pdf Oberstufe-latex_main.pdf
#
#okular Klasse.pdf
