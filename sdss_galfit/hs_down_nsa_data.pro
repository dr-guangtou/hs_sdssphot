pro hs_down_nsa_data, input_catalog, test=test, atlas_only=atlas_only, $
    no_atlas=no_atlas, loc_atlas=loc_atlas, loc_data=loc_data

    loc_nsa = "http://sdss.physics.nyu.edu/mblanton/v0/detect/v0_1/" 
    spawn, 'which wget', wget 
    if ( wget EQ '' ) then begin 
        print, 'Can not find wget on the computer !!'
        message, ' ' 
    endif 

    if file_test( input_catalog ) then begin 
        cat = mrdfits( input_catalog, 1, /silent ) 
        num = n_elements( cat.Z )
    endif else begin 
        print, 'Can not find the input catalog !'
        message, ''
    endelse

    if keyword_set( test ) then begin 
        n_down = 5 
    endif else begin 
        n_down = num 
    endelse 

    for ii = 0, ( n_down - 1 ), 1 do begin 

        ;; Get the necessary information
        subdir  = strcompress( cat[ ii ].SUBDIR, /remove_all ) 
        iauname = strcompress( cat[ ii ].IAUNAME, /remove_all )
        nsaid   = strcompress( string( cat[ ii ].NSAID ), /remove_all )
        ;; Location for the galaxy
        loc_gal = loc_nsa + subdir + '/'

        print, '##############################################################'
        print, ' Work on the galaxy : ' + nsaid + ' !!'
        print, '##############################################################'

        ;; Files that are need to be downloaded
        g_fits = iauname + '-g.fits.gz'
        r_fits = iauname + '-r.fits.gz'
        i_fits = iauname + '-i.fits.gz' 
        g_psf  = iauname + '-g-bpsf.fits.gz'
        r_psf  = iauname + '-r-bpsf.fits.gz'
        i_psf  = iauname + '-i-bpsf.fits.gz'
        jpeg   = iauname + '.jpg'

        if NOT keyword_set( loc_data ) then begin 
            data_dir = 'data/' + nsaid + '/' 
        endif else begin 
            data_dir = strcompress( loc_data, /remove_all ) 
        endelse
        if NOT dir_exist( data_dir ) then begin 
            spawn, 'mkdir -p data/' + nsaid 
        endif 
        g_fits_new = data_dir + nsaid + '-g.fits.gz'
        r_fits_new = data_dir + nsaid + '-r.fits.gz'
        i_fits_new = data_dir + nsaid + '-i.fits.gz' 
        g_psf_new  = data_dir + nsaid + '-g-bpsf.fits.gz'
        r_psf_new  = data_dir + nsaid + '-r-bpsf.fits.gz'
        i_psf_new  = data_dir + nsaid + '-i-bpsf.fits.gz'

        if NOT keyword_set( loc_atlas ) then begin 
            jpeg_dir = 'data/atlas/'
        endif else begin 
            jpeg_dir = strcompress( loc_atlas, /remove_all ) 
        endelse
        if NOT dir_exist( jpeg_dir ) then begin 
            spawn, 'mkdir -p ' + jpeg_dir 
        endif 
        jpeg_new = jpeg_dir + nsaid + '.jpg'

        ;; Download the JPEG image first 
        if NOT keyword_set( no_atlas ) then begin 
            if NOT file_test( jpeg_new ) then begin 
                spawn, wget + ' -P ' + jpeg_dir + ' ' + loc_gal + jpeg + $
                    ' -O ' + jpeg_new
            endif else begin 
                print, '## ' + jpeg_new + ' is already there !!'
            endelse
        endif 

        ;; Download the data 
        if NOT keyword_set( atlas_only ) then begin 

            ;; FITS image 
            if NOT file_test( g_fits_new ) then begin 
                spawn, wget + ' -P ' + data_dir + ' ' + loc_gal + g_fits + $
                    ' -O ' + g_fits_new 
            endif 
            if NOT file_test( r_fits_new ) then begin 
                spawn, wget + ' -P ' + data_dir + ' ' + loc_gal + r_fits + $
                    ' -O ' + r_fits_new 
            endif 
            if NOT file_test( i_fits_new ) then begin 
                spawn, wget + ' -P ' + data_dir + ' ' + loc_gal + i_fits + $
                    ' -O ' + i_fits_new 
            endif 

            ;; PSF images
            if NOT file_test( g_psf_new ) then begin 
                spawn, wget + ' -P ' + data_dir + ' ' + loc_gal + g_psf + $
                    ' -O ' + g_psf_new 
            endif 
            if NOT file_test( r_psf_new ) then begin 
                spawn, wget + ' -P ' + data_dir + ' ' + loc_gal + r_psf + $
                    ' -O ' + r_psf_new 
            endif 
            if NOT file_test( i_psf_new ) then begin 
                spawn, wget + ' -P ' + data_dir + ' ' + loc_gal + i_psf + $
                    ' -O ' + i_psf_new 
            endif 

            ;; Decompress the files
            spawn, 'gunzip ' + data_dir + '*.gz' 

        endif 

    endfor 

end 
