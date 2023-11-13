
echo "
verbose
open mwg-bayreuth.de
user mwg-bayreuth anteskopf2013
binary
prompt
cd www/tl_files/Stundenplan_html
mput *
cd Startseite
lcd Startseite
mput *
bye
" | ftp -n > ftp.log

tar cvzf ../Stundenplan_html.tar.gz * >> ftp.log

#scp ../Stundenplan_html.tar.gz btp907@btrzxg.rz.uni-bayreuth.de:/home/btp9/btp907/public_html/stundenplan/
#ssh btp907@btrzxg.rz.uni-bayreuth.de "cd public_html/stundenplan; tar xvzf Stundenplan_html.tar.gz; chmod 644 *" 
