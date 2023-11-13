# Für neuen Plan:
# index.htm.tar.gz -> links_0.htm (für Lehrer)
# im neuen export html Ordner: make_klassen_local.sh
# index.htm.tar.gz wieder verpacken, kopieren

rm -f stundenplaene.html datenframe.html kopf.html
rm -f collapse.gif expand.gif
cat links_0.htm | sed 's!align! align!g' > temp
mv temp links_0.htm
cat links_1.htm | sed 's!align! align!g' > temp
mv temp links_1.htm
cat links_2.htm | sed 's!align! align!g' > temp
mv temp links_2.htm

mkdir color;
for file in *.htm; do make_style.sh $file > color/${file%.htm}_color.htm; done
rm color/frames_color.htm;
cd color; for file in *; do mv $file ../${file%_color.htm}.htm; done; cd ..
rmdir color;

for num in 5 6 7 8 9 10; 
do echo '<center>' > k_${num}.htm ;
  for file in k_$num?.htm; 
  do echo '<iframe src="'Startseite/$file'" width="90%" height="500" border="0" frameborder="0" name="SELFHTML_in_a_box"> 
           <p>Ihr Browser kann leider keine eingebetteten Frames anzeigen: Sie können die eingebettete Seite über den folgenden Verweis aufrufen:
           <a     href="'Startseite/$file'">SELFHTML</a></p>
           </iframe>'; 
  done >> k_${num}.htm ; 
  echo '</center>' >> k_${num}.htm ;
done

cat rechts.htm | sed 's!      <b><font size="8">S P M + +</font></b>!      <p>\&nbsp;</p>\n      <h2>In der linken Spalte zuerst "Lehrer", "Klassen" oder "R\&auml;ume" ausw\&auml;hlen und dann auf den gew\&uuml;nschten Plan klicken.</h2>!g' > temp
mv temp rechts.htm

cat oben.htm | sed 's!<b><font size="6">!<h1>!g' | sed 's!</font></b></font>!</h1>!g' > temp
mv temp oben.htm

cp links_0.htm links_0.htm-edit
cp links_1.htm links_1.htm-edit
cp links_2.htm links_2.htm-edit

tar xvzf ../index.htm.tar.gz

for file in *.htm; do awk '/<head>/ {print $0"\n<meta http-Equiv=\"Cache-Control\" Content=\"no-cache, no-store, must-revalidate\" />\n<meta http-Equiv=\"Pragma\" Content=\"no-cache\" />\n<meta http-Equiv=\"Expires\" Content=\"-1\" />"}; !/<head>/ {print $0}' $file > temp; mv temp $file; done

for file in *.htm; do awk '/<head>/ {print $0"\n<script type=\"text/javascript\">\n document.getElementById(oben).contentDocument.location.reload(true);\n document.getElementById(links).contentDocument.location.reload(true);\n document.getElementById(rechts).contentDocument.location.reload(true);\n </script>"}; !/<head>/ {print $0}' $file > temp; mv temp $file; done

# Sonder (robust):
# frames.htm
# oben.htm
# raum.htm
# rechts.htm
# Sonder (fragil):
# index.htm
# links_0.htm links_1.htm links_2.htm
