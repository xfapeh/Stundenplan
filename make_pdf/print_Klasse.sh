echo "--------------------print_Klasse.sh--------------------------------------------------"
echo "Klassenplan, Reliplan und Oberstufenplan druckfertig machen"

#xsize=2605
#ysize=4030
xsize=2605
ysize=4598
#reliysize=2342
oberstufeysize=1888
dx=100
dy=200

# # # 2014/15
# # 2x2 DIN-A4 Hochformat
# echo -n ">> Klassenplan:    2x2 DIN-A4 Hochformat                              "
# width=$(($xsize/2+$dx/2))
# height=$(($ysize/2+$dy/2))
# 
# echo -n "1 "
# gs -o gs-poster1.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# echo -n "2 "
# gs -o gs-poster2.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# echo -n "3 "
# gs -o gs-poster3.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# echo    "4 "
# gs -o gs-poster4.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx)) -$(($height-$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# 
# #echo -n "1 "
# #gs -o gs-poster1.pdf -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [    0     0]>> setpagedevice" -f Klasse-latex_main.pdf
# #echo -n "2 "
# #gs -o gs-poster2.pdf -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [-1280     0]>> setpagedevice" -f Klasse-latex_main.pdf
# #echo -n "3 "
# #gs -o gs-poster3.pdf -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [    0 -2000]>> setpagedevice" -f Klasse-latex_main.pdf
# #echo    "4 "
# #gs -o gs-poster4.pdf -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [-1280 -2000]>> setpagedevice" -f Klasse-latex_main.pdf
# 
# pdftk gs-poster3.pdf gs-poster4.pdf gs-poster1.pdf gs-poster2.pdf cat output Klasse_hoch.pdf
# #rm gs-poster3.pdf gs-poster4.pdf gs-poster1.pdf gs-poster2.pdf
# 
# # 2x4 DIN-A4 (statt) DIN-A3 Querformat (Farbdruck)
# echo -n ">> Klassenplan:    2x4 DIN-A4 (statt) DIN-A3 Querformat (Farbdruck)   "
# tempwidth=$width
# tempheight=$height
# 
# width=$tempwidth
# height=$(($tempheight/2+$dx/2))
# 
# echo -n "1 "
# gs -o gs-poster31.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster3.pdf >> log
# echo -n "2 "
# gs -o gs-poster32.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy))]>> setpagedevice" -f gs-poster3.pdf >> log
# echo -n "3 "
# gs -o gs-poster41.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster4.pdf >> log
# echo -n "4 "
# gs -o gs-poster42.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy))]>> setpagedevice" -f gs-poster4.pdf >> log
# echo -n "5 "
# gs -o gs-poster11.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster1.pdf >> log
# echo -n "6 "
# gs -o gs-poster12.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy))]>> setpagedevice" -f gs-poster1.pdf >> log
# echo -n "7 "
# gs -o gs-poster21.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster2.pdf >> log
# echo    "8"
# gs -o gs-poster22.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy))]>> setpagedevice" -f gs-poster2.pdf >> log
# 
# pdftk gs-poster32.pdf gs-poster31.pdf gs-poster12.pdf gs-poster11.pdf gs-poster42.pdf gs-poster41.pdf gs-poster22.pdf gs-poster21.pdf cat output Klasse_print_color.pdf
# rm gs-poster3.pdf gs-poster4.pdf gs-poster1.pdf gs-poster2.pdf gs-poster31.pdf gs-poster32.pdf gs-poster41.pdf gs-poster42.pdf gs-poster11.pdf gs-poster12.pdf gs-poster21.pdf gs-poster22.pdf 
# # # 2014/15

# # 2015/16
# 1x3 DIN-A2 Querformat
echo -n ">> Klassenplan:    1x3 DIN-A2 Querformat                              "
width=$xsize
height=$(($ysize/3+2*$dy/3))

echo -n "1 "
gs -o gs-poster31.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                  0 ]>> setpagedevice" -f Klasse-latex_main.pdf >> log
echo -n "2 "
gs -o gs-poster32.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((  $height-$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log
echo    "3"
gs -o gs-poster33.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((2*$height-2*$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log

pdftk gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf cat output Klasse_quer.pdf
#rm gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf

# 2x3 DIN-A3 Hochformat (s/w-Druck)
# echo -n ">> Klassenplan:    2x3 DIN-A3 Hochformat (s/w-Druck)   "	--- ALT!
echo -n ">> Klassenplan:    2x3 DIN-A3 Hochformat (Farb-Druck Kopierer)   "
tempwidth=$width
tempheight=$height

width=$(($tempwidth/2+$dx/2))
height=$tempheight

echo -n "1 "
gs -o gs-poster311.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster31.pdf >> log
echo -n "2 "
gs -o gs-poster312.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f gs-poster31.pdf >> log
echo -n "3 "
gs -o gs-poster321.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster32.pdf >> log
echo -n "4 "
gs -o gs-poster322.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f gs-poster32.pdf >> log
echo -n "5 "
gs -o gs-poster331.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f gs-poster33.pdf >> log
echo    "6"
gs -o gs-poster332.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f gs-poster33.pdf >> log

pdftk gs-poster331.pdf gs-poster332.pdf gs-poster321.pdf gs-poster322.pdf gs-poster311.pdf gs-poster312.pdf cat output Klasse_quer_DINA3.pdf

# überflüssig seit A3 Farbkopierer
# # 2x6 DIN-A4 Querformat (statt) DIN-A3 Hochformat (Farbdruck)
# echo -n ">> Klassenplan:    2x6 DIN-A4 Querformat (statt) DIN-A3 Hochformat (Farbdruck)   "
# tempwidth=$width
# tempheight=$height
# 
# width=$tempwidth
# height=$(($tempheight/2+$dy/2))
# 
# echo -n "1 "
# gs -o gs-poster3111.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                 0 ]>> setpagedevice" -f gs-poster311.pdf >> log
# echo -n "2 "
# gs -o gs-poster3112.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy)) ]>> setpagedevice" -f gs-poster311.pdf >> log
# echo -n "3 "
# gs -o gs-poster3121.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                 0 ]>> setpagedevice" -f gs-poster312.pdf >> log
# echo -n "4 "
# gs -o gs-poster3122.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy)) ]>> setpagedevice" -f gs-poster312.pdf >> log
# echo -n "5 "
# gs -o gs-poster3211.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                 0 ]>> setpagedevice" -f gs-poster321.pdf >> log
# echo -n "6 "
# gs -o gs-poster3212.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy)) ]>> setpagedevice" -f gs-poster321.pdf >> log
# echo -n "7 "
# gs -o gs-poster3221.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                 0 ]>> setpagedevice" -f gs-poster322.pdf >> log
# echo -n "8 "
# gs -o gs-poster3222.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy)) ]>> setpagedevice" -f gs-poster322.pdf >> log
# echo -n "9 "
# gs -o gs-poster3311.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                 0 ]>> setpagedevice" -f gs-poster331.pdf >> log
# echo -n "10 "
# gs -o gs-poster3312.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy)) ]>> setpagedevice" -f gs-poster331.pdf >> log
# echo -n "11 "
# gs -o gs-poster3321.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                 0 ]>> setpagedevice" -f gs-poster332.pdf >> log
# echo    "12 "
# gs -o gs-poster3322.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy)) ]>> setpagedevice" -f gs-poster332.pdf >> log
# 
# pdftk gs-poster3312.pdf gs-poster3322.pdf gs-poster3311.pdf gs-poster3321.pdf gs-poster3212.pdf gs-poster3222.pdf gs-poster3211.pdf gs-poster3221.pdf gs-poster3112.pdf gs-poster3122.pdf gs-poster3111.pdf gs-poster3121.pdf cat output Klasse_hoch_DINA4_color.pdf

rm gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf \
gs-poster331.pdf gs-poster332.pdf gs-poster321.pdf gs-poster322.pdf gs-poster311.pdf gs-poster312.pdf #\
# gs-poster3312.pdf gs-poster3322.pdf gs-poster3311.pdf gs-poster3321.pdf gs-poster3212.pdf gs-poster3222.pdf gs-poster3211.pdf gs-poster3221.pdf gs-poster3112.pdf gs-poster3122.pdf gs-poster3111.pdf gs-poster3121.pdf
# # 2015/16

# # 1x4 DIN-A4 Querformat
# echo -n ">> Klassenplan:    1x4 DIN-A4 Querformat                              "
# width=$xsize
# height=$(($ysize/4+3*$dy/4))
# 
# echo -n "1 "
# gs -o gs-poster31.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                  0 ]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# echo -n "2 "
# gs -o gs-poster32.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((  $height-$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# echo -n "3 "
# gs -o gs-poster33.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((2*$height-2*$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# echo    "4"
# gs -o gs-poster34.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((3*$height-3*$dy))]>> setpagedevice" -f Klasse-latex_main.pdf >> log
# 
# pdftk gs-poster34.pdf gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf cat output Klasse_quer.pdf
# rm gs-poster34.pdf gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf

# hat vor Reli Deaktivierung funktioniert
# # # Reli
# # # 2x1 DIN-A4 Hochformat
# # echo -n ">> Reliplan:       2x1 DIN-A3 Hochformat                              "
# # width=$(($xsize/2+$dx/2))
# # height=$reliysize
# # 
# # echo -n "1 "
# # gs -o gs-poster1.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f Reli-latex_main.pdf >> log
# # echo    "2"
# # gs -o gs-poster2.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f Reli-latex_main.pdf >> log
# # 
# # pdftk gs-poster1.pdf gs-poster2.pdf cat output Reli_hoch.pdf
# # rm gs-poster1.pdf gs-poster2.pdf

# Oberstufe
# 2x1 DIN-A4 Hochformat
echo -n ">> Oberstufenplan: 2x1 DIN-A3 Hochformat                              "
width=$(($xsize/2+$dx/2))
height=$oberstufeysize

echo -n "1 "
gs -o gs-poster1.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f Oberstufe-latex_main.pdf >> log
echo    "2"
gs -o gs-poster2.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f Oberstufe-latex_main.pdf >> log

pdftk gs-poster1.pdf gs-poster2.pdf cat output Oberstufe_hoch.pdf
rm gs-poster1.pdf gs-poster2.pdf

mv Klasse_quer.pdf Klasse_Notfallkoffer.pdf

#pdftk Klasse_hoch.pdf Reli_hoch.pdf Oberstufe_hoch.pdf Klasse_print_color.pdf cat output Klasse_print.pdf
#pdftk Klasse_quer_DINA3.pdf Reli_hoch.pdf Oberstufe_hoch.pdf Klasse_hoch_DINA4_color.pdf cat output Klasse_print.pdf
# pdftk Klasse_quer_DINA3.pdf Reli_hoch.pdf Oberstufe_hoch.pdf cat output Klasse_print.pdf
pdftk Klasse_quer_DINA3.pdf Oberstufe_hoch.pdf cat output Klasse_print.pdf
# gs -o Klasse_printA4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Klasse_print.pdf
# gs -o Klasse_printA4_color.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Klasse_print_color.pdf
# gs -o Klasse_printA3.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a3 -dAutoRotatePages=/None -dPDFFitPage -f Klasse_print.pdf
#rm Klasse-latex_main.pdf Reli-latex_main.pdf Oberstufe-latex_main.pdf Klasse_hoch.pdf Reli_hoch.pdf Oberstufe_hoch.pdf Klasse_print_color.pdf
#rm Klasse-latex_main.pdf Reli-latex_main.pdf Oberstufe-latex_main.pdf Klasse_quer.pdf Klasse_quer_DINA3.pdf Reli_hoch.pdf Oberstufe_hoch.pdf Klasse_hoch_DINA4_color.pdf
#rm Klasse-latex_main.pdf Reli-latex_main.pdf Oberstufe-latex_main.pdf Klasse_quer.pdf Klasse_quer_DINA3.pdf Reli_hoch.pdf Oberstufe_hoch.pdf
# rm Klasse-latex_main.pdf Reli-latex_main.pdf Oberstufe-latex_main.pdf Klasse_quer_DINA3.pdf Reli_hoch.pdf Oberstufe_hoch.pdf
rm Klasse-latex_main.pdf Oberstufe-latex_main.pdf Klasse_quer_DINA3.pdf Oberstufe_hoch.pdf
#rm Klasse_print.pdf Klasse_print_color.pdf
