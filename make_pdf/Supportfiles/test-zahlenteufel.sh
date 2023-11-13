#!/bin/bash

typeset -i i
typeset -i j

i=91
j=$i/2
k=$j

pdftk Lehrerstundenpläne.pdf cat $(\
for ((o=1;o<=$k;o++))
  do
   echo -n "$o $((++j)) ";
   if [ $o -eq $k ] && [ $j -lt $i ]
     then echo $i
   fi
  done) output temp.pdf
