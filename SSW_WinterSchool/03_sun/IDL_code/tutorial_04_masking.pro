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

setenv, 'ANCIL_DATA=/Users/rkwon/ssw/soho/gen/data'
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

Oy1=Oy/scl
Oz1=Oy/scl
ang=hdr.CROTA1*!dtor
img_rotated=get_rotated_image(img_rd, Oy1, Oz1, ang, /counter_clockwise, pointing=pointing, y_new_pixel=y_new_pixel, z_new_pixel=z_new_pixel)

window, 1, xs=imgsz, ys=imgsz, title='De-rotated Images'
tv, congrid(bytscl(alog10(img_rotated), -12.0784, -9.88356), imgsz, imgsz)

ymask_pix=findgen(hdr.naxis1)#replicate(1., hdr.naxis2)-0.5
zmask_pix=replicate(1., hdr.naxis1)#findgen(hdr.naxis2)-0.5

ymask=ymask_pix*scl-Oy;pixel2wcs(ymask_pix, scale=par.scl)-par.Oy
zmask=zmask_pix*scl-Oz;pixel2wcs(zmask_pix, scale=par.scl)-par.Oz
rr=sqrt(ymask^2.+zmask^2.)
rin=2.1*Rsun
rou=7.0*Rsun

mask_img=intarr(hdr.naxis1, hdr.naxis2)+1
w_in=where(rr le rin)
w_ou=where(rr ge rou)

mask_img[w_in]=0
mask_img[w_ou]=0

img_masked=img_rotated*mask_img
window, 2, xs=imgsz, ys=imgsz, title='Masked De-rotated Images'
tv, congrid(bytscl(alog10(img_masked), -12.0784, -9.88356), imgsz, imgsz)
ycoord_pix=[0., hdr.naxis1]-0.5
zcoord_pix=[0., hdr.naxis2]-0.5

ycoord=ycoord_pix*scl-Oy
zcoord=zcoord_pix*scl-Oz

theta_tmp=findgen(361)*!dtor
ylimb=Rsun*cos(theta_tmp)
zlimb=Rsun*sin(theta_tmp)

plot, ycoord, zcoord, /nodata, /norm, /noerase, pos=[0, 0, 1, 1], xst=5, yst=5
oplot, ylimb, zlimb, thick=3

end