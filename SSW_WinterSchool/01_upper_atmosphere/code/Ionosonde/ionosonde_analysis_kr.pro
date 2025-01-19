
; 본 겨울학교에서는 foF2 데이터 처리 및 분석, 그림까지만 실습한다. 
; hmF2는 아래 코드와 절차를 참고하여 추가 분석해도 됨.

path = './data/Ionosonde/korea'    ; 개인별 PC에 저장한 이오노존데 데이터 경로 
file0 = file_search(path + '/*.txt', count=fnum)                       ; .txt 파일개수 찾기 
print, file0                                                           ; .txt 파일 출력 

; file0에서, ic=이천 이오노존데, jj=제주 이오노존데 자료임. 
; 각각 그래프를 그리면 됨. 

for i = 0, fnum-1 do begin

    if i eq 0 then begin
        stn = 'I-cheon'            ;  station 이름 뽑아내기 
    endif
    if i eq 1 then begin
      stn = 'Jeju'                 ;  station 이름 뽑아내기 
    endif

    readcol, file0(i), format='(a,a,f,f)', $           ;파일 읽기, readcol 외부 프로시저 활용
    date0, time0, fo0, hm0, /silent                  ;date0, time0은 문자로, fof2, hmf2는 float 타입으로 읽음.
    
    year0  = strmid(date0, 0, 4)                       ; 연도 추출 
    month0 = strmid(date0, 5, 2)                       ; 월  추출 
    day0   = strmid(date0, 8, 2)                       ; 일  추출 
    doy    = julday(month0, day0, year0) - julday(1, 0, year0(0))         ; day of year 계산, Julday 함수 사용 
    
    hr0    = strmid(time0, 0, 2)                       ; 시간 추출 
    min0   = strmid(time0, 3, 2)                       ; 분  추출 
    sec0   = strmid(time0, 6, 2)                       ; 초  추출 
    time0  = hr0/24. + min0/(24.*60.) + sec0/(24.*60.*60.)     

    doy0   = doy + time0 
    doy_idx= sort(doy0)                                ; sort 함수는 오름차순 정렬시키는 함수. 
    doy1   = doy0(doy_idx)                             ; txt 파일을 보면, 날짜데이터가 거꾸로 되어 있음. 
    fof2   = fo0(doy_idx)

    d_num = n_elements(fof2)                           ; txt 파일 내의 열 데이터 총 개수세기
    
;----------------------------------- 그래프 그리기 (plot) ----------------------------------

;------------- 전체 데이터 그리기 ------------------------------------;
    win0 = window(dim=[1400, 800])
        pl0 = plot(doy1, fof2, font_size=19, $
        title=''+stn+' Ionosonde foF2 plot(full day)', $
        ytitle='foF2 (Mhz)', xtitle='UT (hr)', /nodata, /current)
    pf0 = plot(doy1, fof2, /overplot)

;-----------------------------------------------------------------
;stop
;----------------------- quiet 데이터 만들기 ------------------------
; quiet 데이터는 Kp index를 참고하여 조용한 지자기 폭풍의 날짜를 찾아 선정하며, 아래 날짜들을 각 시각별로 평균값을 취해 quiet 기준값을 계산.
; 실제 연구에서는 IQD(Internaional Quietest Days)를 찾아 5일을 평균하여 quiet reference로 결정함.
; 단, 이번 겨울학교에서는 간편하게 quiet day 하루만 선정하여 quiet reference로 결정하겠음. 
; 제일 첫번째 날짜를 quiet day로 선정.  doy1(0) = 첫번째 날짜 
; 

    qt_idx1 = where(doy1 ge doy1(0) and doy1 lt doy1(0)+1)          ;  quiet day 인덱스 추출  
    qt_doy1 = doy1(qt_idx1)                            ;  quiet day의 doy
    qt_fof2 = fof2(qt_idx1)                            ;  quiet day의 foF2

; quiet 데이터를 실제 지자기 폭풍이 발생한 날의 데이터 위에 overplot 해야 하므로, 
; 위에 추출한 quiet 데이터의 날짜를 지자기 폭풍 날짜로 덮어씌워야 함.  
; event 1의 경우, 지자기폭풍 시작 날짜가 3월 17일(doy = 76)이므로, 최종 그래프는 3월 17일~18일을 그려야 함.  
; quiet reference의 X축 값도 2일치로 그려져야 하므로, quiet로 선정한 날을 2일 복사붙여넣기 해야함. 

    add_day = fix(doy1(d_num-1)) - fix(doy1(0)) 

    qt1_doy1 = qt_doy1 + add_day-1          ; storm day 1일차로 doy 덮어쓰기 
    qt2_doy1 = qt_doy1 + add_day            ; storm day 2일차로 doy 덮어쓰기  

    qt3_doy1 = [qt1_doy1, qt2_doy1]   ; 두 날짜를 이어 붙이기 
    qt3_fof2 = [qt_fof2, qt_fof2]     ; 두 날짜 데이터 이어 붙이기 

;---------------------- storm 데이터 만들기 --------------------------------

    st_idx1 = where(doy1 ge fix(doy1(d_num-1)-1))    ;  storm 시작날 이후의 인덱스 추출 
    st_doy1 = doy1(st_idx1)                          ;  doy 추출 
    st_fof2 = fof2(st_idx1)                          ;  fof2 추출 

;---------------------- 최종 그래프 그리기 --------------------------------

    win1 = window(dim=[1400, 800])
    pl1 = plot(st_doy1, st_fof2, font_size=19, $
      title=''+stn+' Ionosonde foF2 plot(final)', ytitle='foF2 (Mhz)', xtitle='UT (hr)', /nodata, /current)
    pf1 = plot(st_doy1, st_fof2, color='red', thick=3, /overplot)              ; storm day를 빨간색 실선 
    pf2 = plot(qt3_doy1, qt3_fof2, color='black', thick=3, /overplot)          ; quiet day를 검은색 실선 

; 검은색 quiet reference와 비교하여, 어떻게 변하는지 확인. 
; 최종 그래프를 그린 후, 개인 PC에 저장. PPT에서 X축, Y축을 사용자에 맞게 수정. 
; event 2~6도 똑같은 방식으로 진행하면 됨. 
;------------------------- 완료 ----------------------------------------

endfor 

end