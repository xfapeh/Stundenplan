mv unter.spm Unter.spm
cp -av Unter.spm Unter.old
cat Unter.spm | iconv -f iso8859-15 -t utf8  | tr -d '\r' | \
awk '{if ($3=="Mu" || 
          $3=="1mu" || $3=="1mu1" || $3=="1mu2" || $3=="1mu3" || $3=="1mu4" || $3=="1mu5" || $3=="1mub" || 
          $3=="2mu" || $3=="2mu1" || $3=="2mu2" || $3=="2mu3" || $3=="2mu4" || $3=="2mu5" || $3=="2mub") 
        {print $1, $2, $3, $4, $5, "rMusgr", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 "// #(rMusgr)"}
      else 
        {print $0}}' |\
awk '{if ($3=="Ku" || 
          $3=="1ku" || $3=="1ku1" || $3=="1ku2" || $3=="1ku3" || $3=="1ku4" || $3=="1ku5" || $3=="1kub" || 
          $3=="2ku" || $3=="2ku1" || $3=="2ku2" || $3=="2ku3" || $3=="2ku4" || $3=="2ku5" || $3=="2kub" || 
          $3=="5ku" || $3=="5ku1" || $3=="5ku2" || $3=="5kub" || $3=="5kub1" || $3=="5kub2") 
        {print $1, $2, $3, $4, $5, "rKu", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 "// #(rKu)"}
      else 
        {print $0}}' |\
awk '{if ($3=="PhIF" || 
          $3=="PhInt" || 
          $3=="Ph" ||  
          $3=="JuFo" || 
          $3=="1ph" || $3=="1ph1" || $3=="1ph2" || $3=="1ph3" || 
          $3=="2ph" || $3=="2ph1" || $3=="2ph2" || $3=="2ph3" ||
          $3=="Exp" || 
          ($3=="NuT" && ($2=="7a" || $2=="7b" || $2=="7c" || $2=="7d" || $2=="7e" || $2=="7f" || $2=="7m")) )
        {print $1, $2, $3, $4, $5, "rPh", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 "// #(rPh)"}
      else 
        {print $0}}' |\
awk '{if (($3=="NuT" && ($2=="5a" || $2=="5b" || $2=="5c" || $2=="5d" || $2=="5e" || $2=="5f" || $2=="5m")) ||
          ($3=="NuT" && ($2=="6a" || $2=="6b" || $2=="6c" || $2=="6d" || $2=="6e" || $2=="6f" || $2=="6m")) ||
           $3=="B" ||
           $3=="1b" || $3=="1b1" || $3=="1b2" || $3=="1b3" || $3=="1b4" || $3=="1b5" || 
           $3=="2b" || $3=="2b1" || $3=="2b2" || $3=="2b3" || $3=="2b4" || $3=="2b5" )
        {print $1, $2, $3, $4, $5, "rBC", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 "// #(rBC)"}
      else 
        {print $0}}' |\
awk '{if ($3=="CIF" ||
          $3=="C" || 
          $3=="1c" || $3=="1c1" || $3=="1c2" || $3=="1c3" || $3=="1c4" || $3=="1c5" || 
          $3=="2c" || $3=="2c1" || $3=="2c2" || $3=="2c3" || $3=="2c4" || $3=="2c5")
        {print $1, $2, $3, $4, $5, "rCh", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 "// #(rCh)"}
      else 
        {print $0}}' |\
awk '{if ($3=="Home" || 
          $3=="Inf" || $3=="SpInf" || 
          $3=="1inf" || $3=="1inf1" || $3=="1inf2" || $3=="1inf3" || 
          $3=="2inf" || $3=="2inf1" || $3=="2inf2" || $3=="2inf3" || $3=="5inf" || 
          $3=="TV" )
        {print $1, $2, $3, $4, $5, "rMMR", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 "// #(rMMR)"}
      else 
        {print $0}}' |\
iconv -f utf8 -t iso8859-15 > Unter.tmp
#mv Unter.tmp Unter.spm

# bei Ph -> raus, gleich in Excel einf�gen!!!
#          $3=="Exp" ||
#          $3=="NuT" || 
