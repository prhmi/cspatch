<CsoundSynthesizer>
<CsOptions>
-m128
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1


seed 63

opcode ArrCheck, i, ii[]
 iEl, iArr[] xin
 iRes = 0
 indx = 0
 while indx < lenarray:i(iArr) do
  if iEl == iArr[indx] then
   iRes = 1
   igoto end
  endif
  indx += 1
 od
 end:
 xout iRes
endop


opcode RndRp, i,i[]
iInArr[] xin
iRnd = iInArr[0]
iRead = 0
	until ArrCheck:i(iRnd,iInArr) == 0 do
	iRnd = int(random:i(1,12))
	iRead = (iRead+1) % lenarray(iInArr)
	enduntil
xout iRnd
endop

instr 1

iInArr [] init  9
iOutArr [] init lenarray(iInArr)
iOutArr2 [] init lenarray(iInArr)

iRead = 0
iCheck = 0
itrim = 0
while iRead < lenarray(iInArr) do
iInArr [iRead] = int(random:i(1,12))
	if ArrCheck:i(iInArr[iRead],iOutArr) == 0 then
	iOutArr[iCheck] = iInArr [iRead]
	iCheck += 1
	itrim += 1
	endif
	iOutArr2 = iOutArr
	iWrite = iCheck
	while iWrite < lenarray(iOutArr2) do
	iOutArr2 [iWrite] = RndRp:i(iOutArr2)
	iWrite +=1
	od
	
iRead +=1
od
print iCheck
	trim iOutArr, itrim
	printarray iOutArr, "%.0f", "note"
	printarray iOutArr2, "%.0f", "note2"

endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
