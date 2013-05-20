#! /bin/bash

M=NCC
DIR=tests
RES1=$(compare -metric $M $DIR/screenshot.png $DIR/green.png res.png 2>&1)
RES2=$(compare -metric $M $DIR/screenshot.png $DIR/red.png res.png  2>&1)
rm res.png

THR="0.5"

#echo "X $RES1 X"
#echo "X $RES2 X"

compare_result=$(echo "$RES1>$RES2" | bc)

if [ "$compare_result" == "1" ]
then
    echo "Memory is OK."
    exit 0
else
    echo "Memory is NOT OK!"
    exit 0
fi

echo "Recognition error!"
exit 1
