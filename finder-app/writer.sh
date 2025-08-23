#!/bin/bash

if [ $# -ne 2 ]; then
echo "bad args"
exit 1
fi

writefile=$1
writestr=$2

dir=$(dirname "$writefile")
mkdir -p "$dir"
if [ $? -ne 0 ]; then
echo "no directory created"
exit 1
fi

#cd $dir

echo "$writestr">"$writefile"

if [ $? -ne 0 ]; then
echo "no file  created"
exit 1
fi


exit 0
