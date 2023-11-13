i=7300;
for var in $*;
do 
cat Lehrer.spm | iconv -f iso8859-1 -t utf8 | grep $var | awk '{print "P00" '''$i''' "A    " $1  "       Stuzi  rStuB 2   s9.          // #(rStuB)"}' #| iconv -f iso8859-1 -t utf8
i=$((i+2));
done
