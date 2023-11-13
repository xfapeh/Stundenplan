#
# aus Lehrer-latex.csv die ersten beiden Zeilen löschen!
# Umlaute auf shell
# newline aus latex weg
# 
cat Lehrer-latex.csv \
| iconv -f iso8859-15 -t utf8 \
| sed 's/\\newline//g' \
| awk 'BEGIN{FS=","; montag=0; dienstag=0; mittwoch=0; donnerstag=0; freitag=0; \
                     montagst[1]=0; dienstagst[1]=0; mittwochst[1]=0; donnerstagst[1]=0; freitagst[1]=0;}
       {#print "Mo"
         for (i = 2; i <= 13; i++) {
           j=i-1;
           if ($i !~ /Q11/   \
            && $i !~ /Q12/   \
            && $i !~ /OSK/   \
            && $i !~ /Ver/   \
            && $i !~ /Pr.s/  \
            && $i !~ /Stuzi/ \
            && $i !~ /heim/  \
            && $i !~ /Team/  \
            && $i !~ /Dir/   \
            && $i !~ /Per/   \
            && $i !~ /Kol/   \
            && $i !~ /Unipr/ \
            && $i !~ /1P2/) {
           if ($i !~ /^ *$/) {
             #print $i
             montag++
             montagst[j]++
             }
           }
         };
         #print montag;
       #print "Di"
         for (i = 14; i <= 25; i++) {
           j=i-13;
           if ($i !~ /Q11/   \
            && $i !~ /Q12/   \
            && $i !~ /OSK/   \
            && $i !~ /Ver/   \
            && $i !~ /Pr.s/  \
            && $i !~ /Stuzi/ \
            && $i !~ /heim/  \
            && $i !~ /Team/  \
            && $i !~ /Dir/   \
            && $i !~ /Per/   \
            && $i !~ /Kol/   \
            && $i !~ /Unipr/ \
            && $i !~ /1P2/) {
           if ($i !~ /^ *$/) {
             #print $i
             dienstag++
             dienstagst[j]++
             }
           }
         };
         #print dienstag
       #print "Mi"
         for (i = 26; i <= 37; i++) {
           j=i-25;
           if ($i !~ /Q11/   \
            && $i !~ /Q12/   \
            && $i !~ /OSK/   \
            && $i !~ /Ver/   \
            && $i !~ /Pr.s/  \
            && $i !~ /Stuzi/ \
            && $i !~ /heim/  \
            && $i !~ /Team/  \
            && $i !~ /Dir/   \
            && $i !~ /Per/   \
            && $i !~ /Kol/   \
            && $i !~ /Unipr/ \
            && $i !~ /1P2/) {
           if ($i !~ /^ *$/) {
             #print $i
             mittwoch++
             mittwochst[j]++
             }
           }
         };
         #print mittwoch
       #print "Do"
         for (i = 38; i <= 49; i++) {
           j=i-37;
           if ($i !~ /Q11/   \
            && $i !~ /Q12/   \
            && $i !~ /OSK/   \
            && $i !~ /Ver/   \
            && $i !~ /Pr.s/  \
            && $i !~ /Stuzi/ \
            && $i !~ /heim/  \
            && $i !~ /Team/  \
            && $i !~ /Dir/   \
            && $i !~ /Per/   \
            && $i !~ /Kol/   \
            && $i !~ /Unipr/ \
            && $i !~ /1P2/) {
           if ($i !~ /^ *$/) {
             #print $i
             donnerstag++
             donnerstagst[j]++
             }
           }
         };
         #print donnerstag
       #print "Fr"
         for (i = 50; i <= 61; i++) {
           j=i-49;
           if ($i !~ /Q11/   \
            && $i !~ /Q12/   \
            && $i !~ /OSK/   \
            && $i !~ /Ver/   \
            && $i !~ /Pr.s/  \
            && $i !~ /Stuzi/ \
            && $i !~ /heim/  \
            && $i !~ /Team/  \
            && $i !~ /Dir/   \
            && $i !~ /Per/   \
            && $i !~ /Kol/   \
            && $i !~ /Unipr/ \
            && $i !~ /1P2/) {
           if ($i !~ /^ *$/) {
             #print $i
             freitag++
             freitagst[j]++
             }
           }
         };
         #print freitag
       }
       END {print "Montag " montag, "Dienstag " dienstag, "Mittwoch " mittwoch, "Donnerstag " donnerstag, "Freitag " freitag;
            print montag+dienstag+mittwoch+donnerstag+freitag
            k=1;
            for (j=1; j<=12; j++) {
              #print "Mo" j, montagst[j];
              #print "Di" j, dienstagst[j];
              #print "Mi" j, mittwochst[j];
              #print "Do" j, donnerstagst[j];
              #print "Fr" j, freitagst[j];
           # Array
              printf "%2d %2d %2d %2d %2d\n", montagst[j], dienstagst[j], mittwochst[j], donnerstagst[j], freitagst[j]
           #gnuplot pm3d
              #printf "%d %d %d\n",   j, k,   montagst[j]
              #printf "%d %d %d\n",   j, k+1, dienstagst[j]
              #printf "%d %d %d\n",   j, k+2, mittwochst[j]
              #printf "%d %d %d\n",   j, k+3, donnerstagst[j]
              #printf "%d %d %d\n\n", j, k+4, freitagst[j]
           #gnuplot bar 3d
              #printf "%d %d %d\n",   j, k,   montagst[j]
              #printf "%d %d %d\n",   j, k+1, montagst[j]
              #printf "%d %d %d\n",   j, k+1, dienstagst[j]
              #printf "%d %d %d\n",   j, k+2, dienstagst[j]
              #printf "%d %d %d\n",   j, k+2, mittwochst[j]
              #printf "%d %d %d\n",   j, k+3, mittwochst[j]
              #printf "%d %d %d\n",   j, k+3, donnerstagst[j]
              #printf "%d %d %d\n",   j, k+4, donnerstagst[j]
              #printf "%d %d %d\n",   j, k+4, freitagst[j]
              #printf "%d %d %d\n\n", j, k+5, freitagst[j]
              ##             
              #printf "%d %d %d\n",   j+1, k,   montagst[j]
              #printf "%d %d %d\n",   j+1, k+1, montagst[j]
              #printf "%d %d %d\n",   j+1, k+1, dienstagst[j]
              #printf "%d %d %d\n",   j+1, k+2, dienstagst[j]
              #printf "%d %d %d\n",   j+1, k+2, mittwochst[j]
              #printf "%d %d %d\n",   j+1, k+3, mittwochst[j]
              #printf "%d %d %d\n",   j+1, k+3, donnerstagst[j]
              #printf "%d %d %d\n",   j+1, k+4, donnerstagst[j]
              #printf "%d %d %d\n",   j+1, k+4, freitagst[j]
              #printf "%d %d %d\n\n", j+1, k+5, freitagst[j]
            }
            }'

