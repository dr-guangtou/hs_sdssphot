#!/bin/bash 

name=$1

psfex -c shuang.psfex $name"_cat.fits" \
    -CHECKIMAGE_NAME psf.fits
