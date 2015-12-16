#!/bin/sh

for i in `cat mosaic.lis`; do echo 8448_3701 && \
    sed "s/GALAXY_ID/$i/g temp.in" > $i"_r_1ser.in"; done 
