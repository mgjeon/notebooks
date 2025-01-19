 
Pro s2hms_str, second, h,m,s

  str_name = ['0','1','2','3','4','5','6','7','8','9']

  sign = ''
  if second lt 0 then begin
    sign ='-'
    second = -second
  endif

  h = fix(second/3600.)
  m = fix( (second - h *3600.)/60.)
  s = second - h*3600. - m*60.
  h = fix(h) & m = fix(m) & s= fix(s)

  h = str_name( h/10 ) + str_name( h - (h/10) * 10 )
  m = str_name( m/10 ) + str_name( m - (m/10) * 10 )
  s = str_name( s/10 ) + str_name( s - (s/10) * 10 )

  h = sign + h
  return
end

Pro jday2mmdd, year, jday, month, day

  month=0 & day =0

  month_day =[31, 28, 31, 30, 31,30, 31,31, 30,31,30, 31]
  if (year mod 4) eq 0 then month_day(1) =  29

  if jday le 31 then begin
    day = jday & month = 1
  endif

  if jday gt total(month_day(0:10)) then begin
    month = 12 & day = jday - total(month_day(0:10))
  endif


  for i=0, 12-2 do begin
    a = total( month_day(0:i)) *1.0
    b = total( month_day(0:i+1)) * 1.0
    if (jday eq a ) then begin
      month=i+1 & day = month_day(i)
    endif

    if (jday eq b ) then begin
      month=i+2 & day = month_day(i+1)
    endif

    if (jday gt a ) and (jday lt b) then begin
      month = i+2  & day = jday - a
    endif
  endfor
  return
end

FUNCTION num2str, num
  ; to convert single digit number  to string

  str_name = ['0','1','2','3','4','5','6','7','8','9']

  return, str_name(num)
end

FUNCTION change_doy, doy, adjustment

  ; Input: doy: 3 character string value (e.g. '123') or integer
  ;        adjustment:  a numer to increase or decrease doy
  ; OUtput: a new orbit number (5 chanrater string) 2004.11.18

  tmp = fix(doy * 1) + fix(adjustment)
  a1 = tmp/100 & a2 =(tmp mod 100)/10 & a3=(tmp mod 10)

  b1 = num2str(a1) & b2=num2str(a2) & b3=num2str(a3)
  b = b1 + b2 + b3

  new_doy = b
  return, new_doy
end

FUNCTION change_year, year, adjustment

  ; Input: doy: 4 character string value (e.g. '1234') or integer
  ;        adjustment:  a numer to increase or decrease doy
  ; OUtput: a new orbit number (5 chanrater string) 2004.11.18

  tmp = fix(year * 1) + fix(adjustment)
  a0 = tmp/1000
  a1 = (tmp mod 1000)/100 & a2 =(tmp mod 100)/10 & a3=(tmp mod 10)

  b1 = num2str(a1) & b2=num2str(a2) & b3=num2str(a3)
  b0 = num2str(a0)
  b = b0+ b1 + b2 + b3

  new_year = b
  return, new_year
end

; CALLING SEQUENCE:
;     EDRAURPLOT, edrfile='<full_path_to_EDR-AUR_filename>',
;     [ps_dir='/Users/romeog1/SSUSIData/procdir/l1b2edr-aur/']
;     [do_model_boundary='n']
;
; DEFAULT VALUES:
;      plots:
;      - 1356 angstrom radiance,
;      - rectified for slant path (disk only)
;      - cylindrical projection plot,
;      - maximum radiance of 10000 Rayleighs
;      - title is the filename
;      - sdr (not coarser GAIM resolution) pixels
;
; INPUTS
;   edraurplot:
;     Required inputs
;     - EDRFILE = full path EDR-AUR disk file
;     - ps_dir  = [optional outdir directory, if different from input one]
;     - do_model_boundary = [Use to prevent plotting Model Auroral Boundaries]

  eventdate = '2024085'
  path = '/Users/mgjeon/workspace/winter_school/nbs/01_upper_atmosphere/data/DMSP_SSUSI/event4/'+eventdate+'/'
  file_list = file_search(path + '*.NC', COUNT=fn)
;stop
for f =0, fn -1 do begin
  edrfile = file_list(f)
  ps_dir = path
  
;pro edraurplot, edrfile=edrfile, ps_dir=ps_dir, do_model_boundary=do_model_boundary

  if(~keyword_set(ps_dir)) then   ps_dir = file_dirname(edrfile)
  if(~keyword_set(do_model_boundary)) then do_model_boundary = 'y'

  read_ncdf, edr,file=edrfile
  UVcolor = ['1216','1304','1356','LBHS','LBHL']

  color_list = [ findgen(11) ]

  color_name = [ '1216','1304','1356','LBHS','LBHL', 'E0','Flux','boundary','NmE','HmE','Proton_Flag']
  unit_list  = [ 'kR',   'kR', 'kR',   'kR',  'kR',  'keV','ergs/s/cm!U2!N', $
    'ergs/s/cm!U2!N','cm!U-3!N','km','']

  do_log = 'y'
  fact_list  = [  1e-3, 1e-3, 1e-3, 1e-3, 1e-3, 1., 1., 1.,1.,1.,1.0]
  mc = n_elements(color_list)
  min_list = [fltarr(mc),0,90] & max_list = [1e4, 1e4, 5e3, 5e3, 5e3, 15, 5, 5, 1e6,130]
  if do_log eq 'y' then min_list = [100, 100, 50, 50, 50, 0.1, 0.1, 0.1, 1e4, 90.,  0.1]
  if do_log eq 'y' then max_list = [2e4, 2e4, 5e3,5e3,5e3,20., 20,  20 , 5e6, 130., 2.0]

  H = 110.0
  GRID_SIZE=25.
  d_lat = grid_size /(6378. + H) *180.0d/!dpi

  mLAT_cut=50.
  min_mag_lat = mLAT_cut
  ;; ------- note: mlat_cut should >= min_mag_lat ------
  display_min_mag_lat = mlat_cut
;  !p.font=0
  mlat_step_size = 20.
  if mlat_cut ge 50 then mlat_step_size = 15
  if mlat_cut ge 60 then mlat_step_size = 10

  year = edr.year
  doy  = edr.doy

  fdoy = fix(doy)
  fyear = fix(year)

  doy_name  = change_doy(doy,0)
  year_name = change_year(year,0)
  mission   = edr.Attributes.global.mission
  orbit_num = edr.Attributes.global.STOPPING_ORBIT_NUMBER

  sat_name = '(DMSP'+mission+')'

  id = strpos(edrfile, '_DF.NC')
  sub_num = strmid(edrfile, id-2,2)

  yeardoy = year_name+doy_name

  aa = 'SSUSI'+mission+ '_' + yeardoy + 'R'+ orbit_num + '_' + sub_num + '_'+color_name
  ps_file =  aa  + '.ps'

  ps_name = ps_file

  a = string("305)                ;"

  units = ['R','R','R','R','R','keV','ergs/s/cm!U2!N','cm!U-3!N','km']

  month_name = ['January', 'February', 'March', 'April','May','June','July',$
    'August','September','October','November','December']
  day_name = ['1',  '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9',  '10',$
    '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',$
    '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31']

  jday2mmdd, year, doy, month, day
  date_name = month_name(month-1) + ' ' + day_name(day-1) + ', ' + year_name $
    + ' DOY:' + doy_name + ' '

  a = size(edr.DISK_RADIANCEDATA_INTENSITY_NORTH)
  nx = a(1) & ny = a(2)
  nc = (nx-1)/2
  r_old = (nx-1)/2.

  r_new = r_old *(90. - display_min_mag_lat) / (90.-min_mag_lat)
  r_new = fix(r_new+0.5)
  r_real_new = r_new * d_lat

  x0 = nc - r_new & x1 = nc+ r_new
  y0 = x0         & y1 = x1

  sub_count_n =  reform(edr.DISK_RADIANCEDATA_INTENSITY_NORTH(*, *, 1))
  id0_n = where(sub_count_n le 0)
  id1_n = where(sub_count_n gt 0)

  sub_count_s =  reform(edr.DISK_RADIANCEDATA_INTENSITY_SOUTH(*, *, 1))
  id0_s = where(sub_count_s le 0)
  id1_s = where(sub_count_s gt 0)


  id_UT   = 10
  sub_mlat= reform( edr.LATITUDE_GEOMAGNETIC_GRID_MAP )
  sub_doy = sub_mlat

  sub_UT = edr.UT_N
  ia = where( sub_doy gt 0)       ; 2009.6.16
  ut_N_name = '**:**'

  if (id1_n(0) ge 0) and (ia(0) ge 0) then begin
    a= abs(sub_mlat(id1_n)) &  id = where(a eq max(a))
    aa = sub_ut(id1_n) & tmp_ut = aa(id(0))
    if tmp_ut lt 0 then tmp_ut = tmp_ut + 24.
    s2hms_str,tmp_ut*3600.,hh,mm,ss
    ut_N_name = hh + ':'+mm
  endif

  sub_UT = edr.UT_S
  ia = where( sub_doy gt 0)       ; 2009.6.16
  ut_S_name = '**:**'

  if (id1_s(0) ge 0) and (ia(0) ge 0) then begin
    a= abs(sub_mlat(id1_s)) &  id = where(a eq max(a))
    aa = sub_ut(id1_s) & tmp_ut = aa(id(0))

    if tmp_ut lt 0 then tmp_ut = tmp_ut + 24.
    s2hms_str,tmp_ut*3600.,hh,mm,ss
    ut_S_name = hh + ':'+mm
  endif

;;;; JBS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; JBSMLT= tmp_ut+ 19.75;15.37
; if jbsmlt ge 24 then jbsmlt=jbsmlt-24
; jbsmlat = -50 ;-79.87
; ang_jbs=(jbsmlt -6.d)*2.d*!dpi/24.d
; 
; jbsX=[-90, 90+jbsmlat]
; jbsY=[0, ang_jbs]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  n_list = n_elements(color_list)

  do_log_orig = do_log
;  !P.font=0

  if do_model_boundary eq 'y' then begin
    model_mlat = edr.MODEL_NORTH_GEOMAGNETIC_LATITUDE
    model_mlt  = edr.MODEL_NORTH_MAGNETIC_LOCAL_TIME
    ra_N = 90. - model_mlat
    ang_N = (model_mlt -6.d)*2.d*!dpi/24.d

    model_mlat = edr.MODEL_NORTH_POLAR_GEOMAGNETIC_LATITUDE
    model_mlt  = edr.MODEL_NORTH_POLAR_MAGNETIC_LOCAL_TIME
    pra_N = 90. - model_mlat
    pang_N = (model_mlt -6.d)*2.d*!dpi/24.d

    model_mlat = edr.MODEL_SOUTH_GEOMAGNETIC_LATITUDE
    model_mlt  = edr.MODEL_SOUTH_MAGNETIC_LOCAL_TIME
    ra_S = 90.0+ model_mlat
    ang_S = (model_mlt -6.d)*2.d*!dpi/24.d

    model_mlat = edr.MODEL_SOUTH_POLAR_GEOMAGNETIC_LATITUDE
    model_mlt  = edr.MODEL_SOUTH_POLAR_MAGNETIC_LOCAL_TIME
    pra_S = 90. + model_mlat
    pang_S = (model_mlt -6.d)*2.d*!dpi/24.d

  endif

  for jj=3,3  do begin     ; the last two are for NmE and HmE

    if(jj eq 7) then continue

    i = color_list(jj)

    if i eq 10 then begin
      do_log = 'n'
    endif else begin
      do_log = do_log_orig
    endelse
  
  set_plot, 'X'
  device, decomposed=0
  window, xsize=550, ysize=450
  erase, !p.color 
  loadct, 39
  
  boundary_color = 200
  new_max = 254.
  c_size=1.7
  xa=0.08
  xb=0.74
  ya=0.1
  yb= 0.9
  posi_N = [xa, ya,   xb, yb]

  xa1 = xb + 0.19 & xb1 = xa1 + 0.035
  ya1 = ya+0.15   & yb1 = ya1 + 0.56
  posi_N_bar = [xa1, ya1, xb1, yb1]
  y_ut = 1.01
  
;  device, /color,/inches,file = ps_dir + path_sep()+ps_name(jj),xsize=x_size,ysize=y_size,$
;    yoffset=yoff, xoffset=xoff,/portrait,bits=8, scale_factor= 1
 ;------------- southern hemisphere ------------

    case 1 of
      (jj ge 0 and jj lt 5): begin
        sub_img = reform(edr.DISK_RADIANCEDATA_INTENSITY_SOUTH(*, *, jj))
      end
      (jj eq 5): begin
        sub_img = reform(edr.ELECTRON_MEAN_SOUTH_ENERGY_MAP(*, *))
      end
      (jj eq 6): begin
        sub_img = reform(edr.ELECTRON_FLUX_SOUTH_BOUNDARY_MAP(*, *))
      end
      (jj eq 8): begin
        sub_img = reform(edr.NME_SOUTH(*, *))
      end
      (jj eq 9): begin
        sub_img = reform(edr.HME_SOUTH(*, *))
      end
      (jj eq 10): begin
        sub_img = reform(edr.PROTON_FLAG_SOUTH(*, *))
      end
    endcase
    sub_img = sub_img* fact_list(jj)
    tmp_max = max_list(jj)*fact_list(jj)
    tmp_min = min_list(jj)*fact_list(jj)

    id = where(sub_img ge tmp_max)
    if id(0) ge 0 then sub_img(id) = tmp_max
    sub_img = sub_img > tmp_min
    dis_img = (sub_img - tmp_min) *new_max /(tmp_max - tmp_min)
    if do_log eq 'y' then  $
      dis_img = (alog10(sub_img) - alog10(tmp_min)) *new_max $
      /(alog10(tmp_max) - alog10(tmp_min))
    id = where(sub_mlat lt display_min_mag_lat)
    if id(0) ge 0 then dis_img(id) = dis_img(id) *0.0 + 255

    iid0_s = where(edr.UT_s le 0.0)
    dis_img(iid0_s) = dis_img(iid0_s)*0.0+255

;;;;; LBHS ;;;;

tv, dis_img, posi_N(0),posi_N(1),/normal
    ang = findgen(361)*!dpi/180.d
    r0 = ang*0.0 + 90.- display_min_mag_lat
    plot,/polar, r0, ang,  position = posi_N, xstyle=1,ystyle=1.,color=255, /noerase
    oplot, /polar, r0, ang, thick=2, color=0

    ;=============== add global model boundary ===========
    if do_model_boundary eq 'y' then begin
      if n_elements(ra_S) ge 2 then oplot, /polar, ra_S, ang_S, color=boundary_color, $
        thick=3, linestyle=2
      if n_elements(pra_S) ge 2 then oplot, /polar, pra_S, pang_S, color=boundary_color, $
        thick=3, linestyle=2
    endif

    ;=====================================================
    for p=90-display_min_mag_lat - mlat_step_size,1,-mlat_step_size do begin
      ; oplot, ang*0+p,ang,/polar
      nx = n_elements( sub_count_s(*,0))
      n_center = (nx-1)/2
      x = n_center + p*cos(ang)/d_lat & xx = p*cos(ang)
      y = n_center + p*sin(ang)/d_lat & yy = p*sin(ang)
      cc = x*0
      for k=0,n_elements(cc)-1 do cc(k) = sub_count_s(x(k),y(k))

      for k=0, n_elements(x)-2 do begin
        cc1 = cc(k) & cc2 = cc(k+1)
        if cc1 gt 0 then oplot, xx(k:k+1),yy(k:k+1),color=255,thick=2  ;circle
        if cc1 le 0 then oplot, xx(k:k+1),yy(k:k+1),color=0, thick=2
      endfor
    endfor
    for p=90-display_min_mag_lat,1,-mlat_step_size do xyouts,/data,$
      -(p+1)/sqrt(2.),(p+1)/sqrt(2.),$
      '-'+strcompress(string(fix(90-p)))+'!Uo!N',orientation=45, color=0,charsize=c_size, font=1
    oplot, [-1,1]*1e3,[0,0],color=0 &  oplot, [0,0],[-1,1]*1e3,color=0 ;line
    p = (90-display_min_mag_lat)
    xyouts,/data,(0.-p*0.1)+2, p*1.03,'12',charsize=c_size,color=40, font=1
    xyouts,/data,0.-p*0.088,-p*1.12,'00 MLT',charsize=c_size,color=40, font=1
    xyouts,/data,(-p*1.19)+2,-p*0.05+1, '18',charsize=c_size,color=40,orientation=0, font=1
    xyouts,/data,(p*1.19)-6,-p*0.05+1, '06',charsize=c_size,color=40,orientation=0, font=1
    xyouts,/data, (p*0.3)+13,p*y_ut,'UT ' + ut_S_name,color=0,charsize=c_size, font=1
    xyouts,/data, -p*0.9,p*y_ut,'South',color=0,charsize=c_size, font=1
      
    cc= reform( sub_count_s(n_center,*))
    cy =  reform( sub_count_s(*,n_center))
    p = 90. - display_min_mag_lat
    ncc = n_elements(cc) & tmp_lat = findgen(ncc)/(ncc-1.)*2*p - p
    for k=0, n_elements(cc)-2 do begin
      if cc(k) gt 0 then oplot, [0,0], tmp_lat(k:k+1),color=255,thick=2  ;line
      if cc(k) le 0 then oplot, [0,0], tmp_lat(k:k+1),color=000,thick=2
      if cy(k) gt 0 then oplot, tmp_lat(k:k+1),[0,0], color=255,thick=2
      if cy(k) le 0 then oplot, tmp_lat(k:k+1),[0,0], color=000,thick=2
    endfor
      
      sss=findgen(17)*(!pi*2/16.)
      usersym, cos(sss), sin(sss), /fill
      ;oplot,/polar, jbsX, jbsY, psym=8, color=70, symsize=1.7

    color_bar = findgen(20,254)/20
    tv, color_bar,posi_N_bar(0),posi_N_bar(1),/normal
    fact = 1.0  & tmp_unit = unit_list(jj)

    if i le 4 then tmp_unit = '' + unit_list(jj)
    if do_log ne 'y' then begin
      plot,[0,1],[tmp_min,tmp_max]/fact,ystyle=1,xstyle=4,$
        ytitle = 'SSUSI ' + color_name(jj) + '  ( ' + tmp_unit + ' )',$
        color=0,position= posi_N_bar,/noerase,/nodata,charsize=c_size,yticklen=0.2
    endif else begin 
      plot,[0,1],[tmp_min,tmp_max]/fact,ystyle=1,xstyle=4,/ylog,font=1,$
        ytitle = 'SSUSI ' + color_name(jj) + ' (' + tmp_unit + ')',$
        color=0,position= [xa1, ya1+0.001, xb1, yb1+0.004],/noerase,/nodata,charsize=c_size,yticklen=0.2
    endelse

  endfor
  do_log = do_log_orig

  img = tvrd(/true)
  write_png, path+eventdate+'_KSS'+strtrim(f,2)+'.png', img

endfor ; for F
end