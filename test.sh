#! /usr/bin/bash

RES1=`compare -metric NCC screenshot.png green.png res.png`
RES2=`compare -metric NCC screenshot.png red.png res.png`
rm res.png

THR=0.8

if (( $RES1 >= $THR ))
then
    echo "Memory is OK."
    exit 0
fi

if (( $RES2 >= $THR ))
then
    echo "Memory is NOT OK!"
    exit 0
fi

echo "Recognition error!"
exit 1
