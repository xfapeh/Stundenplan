cat $1 |\
sed 's!<head>!<head><link rel="stylesheet" type="text/css" href="http://mwg.feuerpfeil.de/css/style.css">!g' |\
sed 's!<body>!<body style="background: none; height:90%;"><center>!g' |\
sed 's!<p align="center"><b><font size="5">!<h3>!g' |\
sed 's!</font></b><br></font></p>!</h3>!g' |\
sed 's!<table border="1" cellspacing="0" width="100%">!<table border="1" cellspacing="0" width="50%">!g' |\
sed 's!bgcolor="#33CCCC"!bgcolor="#900C0C"!g' |\
sed 's!bgcolor="#99FF99"!bgcolor="#900C0C" style="color:#FFFFFF"!g' |\
sed 's!bgcolor="#99CCFF"!bgcolor="#900C0C" style="color:#FFFFFF"!g' |\
sed 's! bgcolor="#FFFFCC"!!g'\
