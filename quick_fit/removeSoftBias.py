#!/usr/bin/env python
# encoding: utf-8
"""Convert Segmentation to Mask Image."""

import os
import argparse

from astropy.io import fits


def run(fitsFile, bias=1000.0):
    """Remove a soft bias from the image."""
    if not os.path.isfile(fitsFile):
        raise Exception("## Can not find the input image : %s" %
                        fitsFile)
    """Load in the FITS image"""
    fitsImg = fits.open(fitsFile)[0].data
    newImg = (fitsImg - bias)
    """Save the array to fits file"""
    hdu = fits.PrimaryHDU(newImg)
    hdulist = fits.HDUList([hdu])
    hdulist.writeto(fitsFile, clobber=True)

    return newImg


if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("fitsFile", help="Name of the input FITS file")

    args = parser.parse_args()

    run(args.fitsFile, bias=1000.0)
