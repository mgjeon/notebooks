pro my_cor_par, hdr, scl, Oy, Oz, radius=Rsun
  Rsun=6.9570000e+08
  ;pixel size in meters
  arc2radian=(1.*!dtor)/(3600.)
  tmp=get_solar_radius(hdr, distance=r1)
  r=r1*1.d3
  pixel_size_arcsec = (hdr.cdelt1 + hdr.cdelt2) / 2.
  scl = r * pixel_size_arcsec * arc2radian
  ;scl = PIXEL2WCS_SCALE(hdr, /c2, Dsun_obs=Dsun_obs)

  ;find the sun center on image plane
  wcs = FITSHEAD2WCS(hdr)
  sunc = WCS_GET_PIXEL(wcs, [0, 0])

  Oytmp = sunc[0]
  Oztmp = sunc[1]
  Oy = Oytmp*scl
  Oz = Oztmp*scl
end

;setenv, 'ANCIL_DATA=/Users/rkwon/ssw/soho/gen/data'
f=file_search('/Users/mgjeon/workspace/winter_school/nbs/03_sun/*.fts')


;bg_c2=bg_min_coronagraph('20240508', 'c2', time_range_day=14)
;bg=bg_c2.normal
img0=lasco_readfits(f[0], hdr0)
img0=c2_calibrate(img0, hdr0) ;c3_calibrate for c3 images

img=lasco_readfits(f[1], hdr)
img=c2_calibrate(img, hdr) ;c3_calibrate for c3 images

my_cor_par, hdr, scl, Oy, Oz, radius=Rsun

imgsz=512

img_rd=img-img0
window, 0, xs=imgsz, ys=imgsz, title='Original Images'
tv, congrid(bytscl(alog10(img_rd), -12.0784, -9.88356), imgsz, imgsz)  

Oy1=Oy/scl;pixel2wcs(par.Oy, scale=par.scl, /inverse)
Oz1=Oz/scl;pixel2wcs(par.Oz, scale=par.scl, /inverse)

ang=hdr.CROTA1*!dtor
pointing=1
img_rotated=get_rotated_image(img_rd, Oy1, Oz1, ang, /counter_clockwise, pointing=pointing, y_new_pixel=y_new_pixel, z_new_pixel=z_new_pixel)


window, 1, xs=imgsz, ys=imgsz, title='De-rotated Images'
tv, congrid(bytscl(alog10(img_rotated), -12.0784, -9.88356), imgsz, imgsz)
end