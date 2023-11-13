echo "usage ./fixup-dropbox.sh 08-18"

datedir=2021-$1

unzip Stdp${datedir}.zip -d Stdp${datedir}

cd Stdp${datedir} 
mv Stdp${datedir}/* .
mv stdp${datedir}/* .
rm Stdp${datedir}/.directory
rmdir Stdp${datedir} stdp${datedir}
cd ..
