echo "--------------------print_Raum.sh----------------------------------------------------"
echo "Raumplan druckfertig machen"

xsize=2605
ysize=1568
dx=100
dy=100

# # 2x2 DIN-A4 Hochformat
# echo -n ">> Raumplan:       2x2 DIN-A4 Hochformat                              "
# width=$(($xsize/2+$dx/2))
# height=$(($ysize/2+$dy/2))
# 
# echo -n "1 "
# gs -o gs-poster1.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                0 ]>> setpagedevice" -f Raum.pdf >> log
# echo -n "2 "
# gs -o gs-poster2.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                0 ]>> setpagedevice" -f Raum.pdf >> log
# echo -n "3 "
# gs -o gs-poster3.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$(($height-$dy))]>> setpagedevice" -f Raum.pdf >> log
# echo    "4 "
# gs -o gs-poster4.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx)) -$(($height-$dy))]>> setpagedevice" -f Raum.pdf >> log
# 
# #echo -n "1 "
# #gs -o gs-poster1.ps -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [    0     0]>> setpagedevice" -f Raum.pdf >> log
# #echo -n "2 "
# #gs -o gs-poster2.ps -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [-1280     0]>> setpagedevice" -f Raum.pdf >> log
# #echo -n "3 "
# #gs -o gs-poster3.ps -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [    0 -2000]>> setpagedevice" -f Raum.pdf >> log
# #echo    "4 "
# #gs -o gs-poster4.ps -sDEVICE=pdfwrite -g13000x20300 -c "<</PageOffset [-1280 -2000]>> setpagedevice" -f Raum.pdf >> log
# 
# pdftk gs-poster3.pdf gs-poster4.pdf gs-poster1.pdf gs-poster2.pdf cat output Raum_hoch.pdf
# rm gs-poster3.pdf gs-poster4.pdf gs-poster1.pdf gs-poster2.pdf

# # 1x3 DIN-A4 Querformat
# echo -n ">> Raumplan:       1x3 DIN-A4 Querformat                              "
# width=$xsize
# height=$(($ysize/3+2*$dy/3))
# 
# echo -n "1 "
# gs -o gs-poster31.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                  0 ]>> setpagedevice" -f Raum.pdf >> log
# echo -n "2 "
# gs -o gs-poster32.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((  $height-$dy))]>> setpagedevice" -f Raum.pdf >> log
# echo    "3 "
# gs -o gs-poster33.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0 -$((2*$height-2*$dy))]>> setpagedevice" -f Raum.pdf >> log
# 
# pdftk gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf cat output Raum_quer.pdf
# rm gs-poster33.pdf gs-poster32.pdf gs-poster31.pdf

# # 3x1 DIN-A4 Hochformat
# echo -n ">> Raumplan:       3x1 DIN-A4 Hochformat                              "
# width=$(($xsize/3+2*$dx/3))
# height=$ysize
# 
# echo -n "1 "
# gs -o gs-poster13.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                  0 ]>> setpagedevice" -f Raum.pdf >> log
# echo -n "2 "
# gs -o gs-poster23.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                  0 ]>> setpagedevice" -f Raum.pdf >> log
# echo    "3 "
# gs -o gs-poster33.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$((2*$width-2*$dx))              0 ]>> setpagedevice" -f Raum.pdf >> log
# 
# pdftk gs-poster13.pdf gs-poster23.pdf gs-poster33.pdf cat output Raum_hoch.pdf
# rm gs-poster13.pdf gs-poster23.pdf gs-poster33.pdf

# 2x1 DIN-A4 Querformat
echo -n ">> Raumplan:       2x1 DIN-A4 Querformat                              "
width=$(($xsize/2+$dx/2))
height=$ysize

echo -n "1 "
gs -o gs-poster1.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [               0                  0 ]>> setpagedevice" -f Raum.pdf >> log
echo    "2 "
gs -o gs-poster2.pdf -sDEVICE=pdfwrite -g${width}0x${height}0 -c "<</PageOffset [-$(($width-$dx))                  0 ]>> setpagedevice" -f Raum.pdf >> log

pdftk gs-poster1.pdf gs-poster2.pdf cat output Raum_quer.pdf
rm gs-poster1.pdf gs-poster2.pdf

# gs -o Raum_printA4.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/None -dPDFFitPage -f Raum_quer.pdf
# gs -o Raum_printA3.pdf -sDEVICE=pdfwrite -sPAPERSIZE=a3 -dAutoRotatePages=/None -dPDFFitPage -f Raum_quer.pdf
cp Raum_quer.pdf Raum_print.pdf

rm Raum_quer.pdf
