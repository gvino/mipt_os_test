#! /bin/bash

RES1=$(compare -metric NCC screenshot.png green.png res.png 2>&1)
RES2=$(compare -metric NCC screenshot.png red.png res.png  2>&1)
rm res.png

THR="0.5"

#echo "X $RES1 X"
#echo "X $RES2 X"

compare_result=$(echo "$RES1>$THR" | bc)
#echo "X$compare_result X"

if [ "$compare_result" == "1" ]
then
    echo "Memory is OK."
    exit 0
fi

compare_result=$(echo "$RES2>$THR" | bc)
#echo "X$compare_result X"

if [ "$compare_result" == "1" ]
then
    echo "Memory is NOT OK!"
    exit 0
fi

echo "Recognition error!"
exit 1
