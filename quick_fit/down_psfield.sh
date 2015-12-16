#!/bin/bash 

round=0
for i in `cat $1`; do
    round=`echo " $round + 1" | bc`
    #Read the Inputs
    id=`echo $i | awk -F "," '{print $1}'`
    run=`echo $i | awk -F "," '{print $2}'`
    camcol=`echo $i | awk -F "," '{print $3}'`
    field=`echo $i | awk -F "," '{print $4}'`
    row=`echo $i | awk -F "," '{print $5}'`
    col=`echo $i | awk -F "," '{print $6}'`

    psname=$id"_psfield.fit"
    psf=$id"_r_psf.fits"

    url="http://data.sdss3.org/sas/dr12/boss/photo/redux/301/$run/objcs/$camcol/psField-00$run-$camcol-$field.fit" 
    echo $url

    wget $url -O $psname

    echo "read_PSF $psname $camcol $row $col $psf" >> temp

done 
