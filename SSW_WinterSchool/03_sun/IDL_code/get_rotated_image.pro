function get_rotated_image, img, y0, z0, theta, clockwise=clockwise, counter_clockwise=counter_clockwise, $
                    pointing=pointing, y_new_pixel=y_new_pixel, z_new_pixel=z_new_pixel
  if ~keyword_set(counter_clockwise) then clockwise=1
  nx=n_elements(img[*, 0])
  ny=n_elements(img[0, *])
  ycoord0=findgen(nx)#replicate(1, ny)-y0
  zcoord0=replicate(1, nx)#findgen(ny)-z0  
  if keyword_set(clockwise) then begin
    ycoord=ycoord0*cos(theta)+zcoord0*sin(theta)
    zcoord=(-1.)*ycoord0*sin(theta)+zcoord0*cos(theta)
    ycoord=ycoord+y0
    zcoord=zcoord+z0
  endif
  if keyword_set(counter_clockwise) then begin
    ycoord=ycoord0*cos(theta)-zcoord0*sin(theta)
    zcoord=ycoord0*sin(theta)+zcoord0*cos(theta)
    ycoord=ycoord+y0
    zcoord=zcoord+z0
  endif
  img1=interpolate(img, ycoord, zcoord)
  
  if keyword_set(pointing) then begin
    y1=nx/2.-0.5
    z1=ny/2.-0.5
    del_y=y0-y1
    del_z=z0-z1
    ycoord=findgen(nx)#replicate(1, ny)+del_y
    zcoord=replicate(1, nx)#findgen(ny)+del_z
    img2=interpolate(img1, ycoord, zcoord)
    img1=img2
    y_new_pixel=y1
    z_new_pixel=z1
  endif
  return, img1
end