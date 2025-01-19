;setenv, 'ANCIL_DATA=/Users/mgjeon/ssw/soho/gen/data'
;setenv, 'LASCO_DATA=/Users/mgjeon/ssw/soho/lasco/idl/data'
f=file_search('/Users/mgjeon/workspace/winter_school/nbs/03_sun/solardata/soho/lasco/level_05/240508/c2/*.fts')

i=36
;bg_c2=bg_min_coronagraph('20240508', 'c2', time_range_day=14)
;bg=bg_c2.normal
img0=lasco_readfits(f[i-1], hdr0)
img0=c2_calibrate(img0, hdr0) ;c3_calibrate for c3 images

img=lasco_readfits(f[i], hdr)
img=c2_calibrate(img, hdr) ;c3_calibrate for c3 images

;par=header2par(hdr, 'c2')

window, 0, xs=1024, ys=1024, title='Direct Images'
tv, bytscl(alog10(img), -10.9246, -7.82187)
window, 1, xs=1024, ys=1024, title='Running Difference Images'
tv, bytscl(alog10(img-img0), -12.0784, -9.88356)  
;iimage, alog10(img1-bg)
end