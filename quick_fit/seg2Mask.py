#!/usr/bin/env python
# encoding: utf-8
"""Convert Segmentation to Mask Image."""

import os
import argparse

from astropy.io import fits


def run(segFile, sigma=2.0, mskMax=1000.0, mskThr=0.01):
    """Convert segmentation map to mask image."""
    segFile = args.segFile
    mskFile = segFile.replace('.fits', '_msk.fits')
    if not os.path.isfile(segFile):
        raise Exception("## Can not find the segmentation image : %s" %
                        segFile)
    """Load in the segmentation image"""
    segImg = fits.open(segFile)[0].data
    xSize, ySize = segImg.shape
    """Find out the value of the central pixel"""
    cenVal = segImg[int(xSize/2), int(ySize/2)]
    """Clear the central object"""
    segImg[segImg == cenVal] = 0
    """Making a mask array"""
    segImg[segImg > 0] = 1
    segImg = segImg.astype(int)
    """Save the array to fits file"""
    hdu = fits.PrimaryHDU(segImg)
    hdulist = fits.HDUList([hdu])
    hdulist.writeto(mskFile, clobber=True)

    return segImg


if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("segFile", help="Name of the segmentation file")

    args = parser.parse_args()

    run(args.segFile, sigma=2.0, mskMax=1000.0, mskThr=0.01)
