f=file_search('/Users/mgjeon/workspace/winter_school/nbs/03_sun/*.fts')

img0=lasco_readfits(f[0], hdr0)
img0=c2_calibrate(img0, hdr0) ;c3_calibrate for c3 images

img=lasco_readfits(f[1], hdr)
img=c2_calibrate(img, hdr) ;c3_calibrate for c3 images

Rsun=6.9570000e+08


imgsz=512
window, 1, xs=imgsz, ys=imgsz, title='Running Difference Images'
tv, congrid(bytscl(alog10(img-img0), -12.0784, -9.88356), imgsz, imgsz)  


;pixel size in meters
arc2radian=(1.*!dtor)/(3600.)
tmp=get_solar_radius(hdr, distance=r1)
r=r1*1.d3
pixel_size_arcsec = (hdr.cdelt1 + hdr.cdelt2) / 2.
scl = r * pixel_size_arcsec * arc2radian

;find the sun center on image plane
wcs = FITSHEAD2WCS(hdr)
sunc = WCS_GET_PIXEL(wcs, [0, 0])

Oytmp = sunc[0]
Oztmp = sunc[1]
Oy = Oytmp*scl
Oz = Oztmp*scl;


ycoord_pix=[0., hdr.naxis1]-0.5
zcoord_pix=[0., hdr.naxis2]-0.5

ycoord=ycoord_pix*scl-Oy
zcoord=zcoord_pix*scl-Oz

theta_tmp=findgen(361)*!dtor
ylimb=Rsun*cos(theta_tmp)
zlimb=Rsun*sin(theta_tmp)

plot, ycoord, zcoord, /nodata, /norm, /noerase, pos=[0, 0, 1, 1], xst=5, yst=5
oplot, ylimb, zlimb, thick=3

cursor, yp, zp, /data
wait, 0.5
print, yp, zp
pos_ang=atan(zp, yp)
print, 'position angle: '+string(round(pos_ang*!radeg), format='(i3)')
r=(findgen(800.)/100.)*Rsun

yline=r*cos(pos_ang)
zline=r*sin(pos_ang)
oplot, yline, zline

yp=0.
zp=0.
repeat begin
  cursor, ytmp, ztmp, /data
  wait, 0.5
  if !mouse.button eq 1 then begin
    plots, ytmp, ztmp, /data, psym=1, symsize=2
    yp=[yp, ytmp]
    zp=[zp, ztmp]
  endif
endrep until (!mouse.button eq 4)
yp=yp[1:n_elements(yp)-1]
zp=zp[1:n_elements(zp)-1]
end