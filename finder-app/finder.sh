#!/bin/bash

if [ $# -ne 2 ]; then
echo "Wrong number of arguments 2 req'd"
exit 1
fi
dir=$1
str=$2


if [ ! -d "$dir" ]; then
echo "Does not exist"
exit 1
fi
echo "$dir"
numfiles=$(grep -rl "$str" "$dir" | wc -l)
numlines=$(grep -r "$str" "$dir" | wc -l)
echo  "The number of files are $numfiles and the number of matching lines are $numlines"
