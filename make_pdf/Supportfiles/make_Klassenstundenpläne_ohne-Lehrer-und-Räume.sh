cat Klasse1.CSV > temp.csv
cat temp.csv | tr '\n' '@' | tr -d '"' | tr ';' ',' | sed -e 's/\r/\\\\/g' | sed -e 's/@/\\newline /g' | sed -e 's/\\\\\\newline/\n/g' | sed -e 's/,$//g'  > Klasse-latex.csv
cat Klasse-latex.csv | awk '/SPM++/ {gsub(/2014,/, ""); gsub(/,,r...?.?,/, ",");  print $9}; !/SPM++/ {print $0}' > temp && mv temp Klasse-latex.csv
awk ''/^[0-9][0-9]?[A-E],Mo,Di,Mi,Do,Fr$/' { out = sprintf("Klasse-latex-%02d.csv", ++i); print > out } !'/^[0-9][0-9]?[A-E],Mo,Di,Mi,Do,Fr$/' { out = sprintf("Klasse-latex-%02d.csv", i); print > out }' Klasse-latex.csv
for ((i=1; i<=29; i++)); do
#for i in 1 2 5 8 9 16 17 18 19 20 22 23 25; do
klasse=$(cat Klasse-latex-$(printf "%02d" $i).csv | awk '/^[0-9][0-9]?[A-E],Mo,Di,Mi,Do,Fr$/ {gsub(/,.*$/, "");print $0}')
cat Klasse-latex-$(printf "%02d" $i).csv | awk '!/^ *$/' > temp && mv temp Klasse-latex-$(printf "%02d" $i).csv
csv2pdf --in Klasse-latex-$(printf "%02d" $i).csv --theme NYC5 --outputlatex > Klasse-latex-$(printf "%02d" $i)_main.tex
iconv -f iso8859-15 -t utf8 Klasse-latex-$(printf "%02d" $i).tex > temp && mv temp Klasse-latex-$(printf "%02d" $i).tex
cat Klasse-latex-$(printf "%02d" $i).tex | sed -e 's/|l/|p{2cm}/g' | sed -e 's/|r/|p{2cm}/g' | sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!25}    \\\\.\\hline//g;p;}' | sed -n '1h;1!H;${g;s/\\rowcolor{latextbl!01}    \\\\.\\hline//g;p;}' | sed 's/\\begin{longtable}{|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|p{2cm}|}/\\begin{longtable}{ | >{\\noindent\\begin{minipage}[t][2.43cm]{1cm}}p{1cm}<{\\newline\\end{minipage}} | p{6cm} | p{6cm} | p{6cm} | p{6cm} | p{6cm} |}/g' | sed 's/78,130,190/144,12,12/g' > temp && mv temp Klasse-latex-$(printf "%02d" $i).tex
sed 's/ [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\? \\newline [a-zA-Z]\?[a-zA-Z]\?[a-zA-Z]\?[a-zA-Z]\?\\newline r\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?\\newline [0-9a-zA-Z][0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?[0-9a-zA-Z]\?/ \\begin{minipage}[t]{1.9cm} & \\end{minipage}/g' Klasse-latex-$(printf "%02d" $i).tex | sed 's/ \+/ /g' | sed 's/\\end{minipage} \\newline \\begin{minipage}/\\end{minipage} \\hfill \\begin{minipage}/g' | sed 's/\\end{minipage}/\\newline\\end{minipage}/g'> temp && mv temp Klasse-latex-$(printf "%02d" $i).tex
awk '/\usepackage{helvet}/ {print "\n\\usepackage[paperwidth=35.9cm, paperheight=50.7cm,margin=1cm]{geometry}\n\\usepackage{fontspec}";next}; /begin{document}/ {print $0 "\n\\thispagestyle{empty}\\fontsize{14pt}{10pt}\\fontspec{SourceSansPro-Semibold}\\noindent{}\\hspace*{.2cm}MWG \\hfill Klasse '''$klasse''' \\hfill '''"`date +%d"."%m"."%Y`"'''\\hspace*{.2cm}\\\\[-.8cm] \\fontsize{14pt}{15pt}\\fontspec{SourceSansPro-Semibold}";next} 1' Klasse-latex-$(printf "%02d" $i)_main.tex > temp && mv temp Klasse-latex-$(printf "%02d" $i)_main.tex
sed 's/\\usepackage{xcolor}/\\usepackage[usenames,dvipsnames]{xcolor}/g' Klasse-latex-$(printf "%02d" $i)_main.tex > temp && mv temp Klasse-latex-$(printf "%02d" $i)_main.tex
cat Klasse-latex-$(printf "%02d" $i).tex \
| sed    's/{78,130,190}/{120,120,120}/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]M [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]MIF [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]MInt [^&]*/\&\\cellcolor{blue!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]D [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]DInt [^&]*/\&\\cellcolor{red!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]L [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]LInt [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]LIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]F [^&]*/\&\\cellcolor{magenta!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]FIF [^&]*/\&\\cellcolor{magenta!25}&/g' \
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
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Ph [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]PhIF [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Inf [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]NuT [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Exp [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]B [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]C [^&]*/\&\\cellcolor{Emerald!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]G [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sk [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Geo [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]WR [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Smw [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sm [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Sw [^&]*/\&\\cellcolor{JungleGreen!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Peso [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed -e 's/&[^&]\\begin{minipage}\[t\]{1.9cm}[^&]Spr [^&]*/\&\\cellcolor{YellowOrange!25}&/g' \
| sed 's/\\cellcolor{blue!25}&/\\cellcolor{blue!25}/g' \
| sed 's/\\cellcolor{red!25}&/\\cellcolor{red!25}/g' \
| sed 's/\\cellcolor{magenta!25}&/\\cellcolor{magenta!25}/g' \
| sed 's/\\cellcolor{green!25}&/\\cellcolor{green!25}/g' \
| sed 's/\\cellcolor{yellow!25}&/\\cellcolor{yellow!25}/g' \
| sed 's/\\cellcolor{cyan!25}&/\\cellcolor{cyan!25}/g' \
| sed 's/\\cellcolor{Emerald!25}&/\\cellcolor{Emerald!25}/g' \
| sed 's/\\cellcolor{YellowOrange!25}&/\\cellcolor{YellowOrange!25}/g' \
| sed 's/\\cellcolor{JungleGreen!25}&/\\cellcolor{JungleGreen!25}/g' \
| sed -e 's/& /&/g' \
| sed -e 's/!25} /!25}/g' \
> temp && mv temp Klasse-latex-$(printf "%02d" $i).tex
lualatex Klasse-latex-$(printf "%02d" $i)_main.tex
rm Klasse-latex-$(printf "%02d" $i)_main.tex Klasse-latex-$(printf "%02d" $i).tex
rm Klasse-latex-$(printf "%02d" $i)_main.log Klasse-latex-$(printf "%02d" $i)_main.aux Klasse-latex-$(printf "%02d" $i).pdf
#rm Klasse-latex-$(printf "%02d" $i).csv
mv Klasse-latex-$(printf "%02d" $i)_main.pdf Klasse_$(printf "%02d" $i).pdf
done
pdftk Klasse_[0-9][0-9].pdf cat output Klassenstundenpläne.pdf
gs -o Klassenstundenpläne_printA4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Klassenstundenpläne.pdf
rm Klasse_[0-9][0-9].pdf Klasse-latex*.csv temp.csv Klassenstundenpläne.pdf

