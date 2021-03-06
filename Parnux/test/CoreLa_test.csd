
<Cabbage>
form caption("CoreLa") size(600, 300), pluginid("CoreLa") style("legacy")  colour:0(20, 30, 82, 255)

;;Sequencer
groupbox bounds(0, 0, 600, 300) plant("seq") text("Sequencer"){
label    bounds(35, 28, 40, 12) text("On/Off")
checkbox bounds(10, 25, 20, 20) colour:0(100, 100, 100, 255) popuptext("Start")  channel("sq") colour:1(100, 250, 60, 255)
checkbox bounds(13, 58, 15, 15) colour:0(100, 100, 100, 255) popuptext("Synth")  channel("dng") colour:1(100, 250, 60, 255)
label    bounds(30, 60, 40, 12) text("Synth")
checkbox bounds(470, 50, 15, 15) colour:0(100, 100, 100, 255) popuptext("Hold")  channel("hold") colour:1(100, 250, 60, 255)
label    bounds(464, 68, 30, 12) text("Hold")
nslider  bounds(130, 35, 40, 31) range(50, 180, 90, 1, 1) velocity(50) fontcolour(208, 157, 253, 255) text("BPM") channel("BPM") identchannel("BPMID")
nslider  bounds(170, 35, 30, 31) range(1, 10, 2, 1, 1) velocity(50) fontcolour(208, 157, 253, 255) text("DV") channel("DV") identchannel("DVID")
nslider  bounds(210, 35, 30, 31) range(1, 10, 5, 1, 1) velocity(50) fontcolour(208, 157, 253, 255) text("Step") channel("rysteps") identchannel("DVID")

label    bounds(498, 30, 88, 12) text("Indian Rythm")
combobox bounds(510, 50, 65, 25) text("Rythm", "Tala", "TalaRep", "TalaPlus", "TalaPlusR", "TalaPlusJ") channel("tala") 
nslider bounds(-100, -100, 40, 28) velocity(50) range(0.5, 4, 0.5, 1, 0.01) colour(10, 10, 10, 200)fontcolour(200, 200, 250, 250) widgetarray("check", 14) channel("check7") identchannel("check_ident7")
combobox bounds(220, 250, 60, 25) text("mod1", "mod2") channel("sqmod") value(1)
checkbox bounds(-100, -100, 10, 10) colour:0(100, 100, 100, 255) colour:1(208, 200, 253, 255)  widgetarray("sq", 14) channel("sq7") identchannel("sq_ident7")
checkbox bounds(-100, -100, 10, 10) colour:0(100, 100, 100, 255) colour:1(208, 200, 253, 255)  widgetarray("ac", 14) channel("ac7") identchannel("ac_ident7")
hslider bounds(70, 250, 150, 28) range(0.05, 2, 0.7, 1, 0.01) colour(208, 157, 253, 255) trackercolour(208, 157, 253, 255) channel("dur")
label    bounds(10, 258, 50, 12) text("Duration")
}


</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-m128 	-dm0 -n -+rtmidi=null -M0 -d  -m0d -Q0 --midi-key=4
</CsOptions>
<CsInstruments>

;sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

seed 0
massign	0,0


giRythArr  []   init 14
giRythArrP []   init 14
giRythArrB []   fillarray .5,.5,2,1,.5,1,2,1,.5
giPlusArr  []   fillarray -1.5,-1,-0.5, 0.5, 1, 1.5
giSumArr        sumarray giRythArr

giNoteArr  []   init 7 ;fillarray 75, 80, 68, 70
giAccArr   []   init 14
giNoteArrP []   init 7	
giLength        init lenarray:i(giNoteArr)
giEmptyArr []   init giLength	

	
giTalaCount  init 0
giPlusCount  init 0
giChngIndx   init 0
giElement    init 0

giActive     init 0
giCountMIDI  init 0



;;indian
opcode ArrTala, i[], i[]i
 iInArr[],iSteps xin
 giTalaCount = (giTalaCount+1)% iSteps
 iRead = 0
 iWrite = giTalaCount
 while iRead < iSteps do
 	giRythArrP [iRead] = iInArr[iWrite]
	iRead +=1
	iWrite = (iWrite+1)% iSteps
 od
 printarray giRythArrP,"%.02f", "ArrTala ="
 xout giRythArrP
endop
opcode ArrRep, i[], i[]i
 iInArr[],iSteps xin
 giRythArrP[] = iInArr
 giRythArrP[giTalaCount+1] = iInArr[giTalaCount]
 giTalaCount = (giTalaCount+1)% (iSteps-1)
 xout giRythArrP
endop
opcode ArrPlus, i[],i[]i
 iInArr[],iSteps xin

 giRythArrP[] = iInArr
  giRythArrP[giTalaCount] = iInArr[giTalaCount] + giPlusArr[giPlusCount]
  giRythArrP[giTalaCount] = ( giRythArrP[giTalaCount] < 0.5 ) ?
  giRythArr[giTalaCount] :  giRythArrP[giTalaCount]
    giPlusCount = (giPlusCount+1)% lenarray(giPlusArr)
 if giPlusCount == 0  then
    giTalaCount = (giTalaCount+1)% (iSteps)
 endif
  printarray giRythArrP,"%.02f", "ArrPlus ="
 xout giRythArrP
endop
opcode ArrPlusR, i[], i[]i
 iInArr[],iSteps xin
 if giTalaCount == giChngIndx then
  iElm random 0, iSteps
  iAdd random -2,2 
  iAdd = (iAdd == 0) ? 1 : iAdd
  giRythArrP[iElm] =  iInArr[iElm]+iAdd
  giRythArrP[iElm] = ( giRythArrP[iElm] < 0.5 ) ?
    giRythArr[iElm]+0.7 :  giRythArrP[iElm]
  giChngIndx = (giChngIndx+1)% 3
  printarray giRythArrP,"%.02f", "ArrPlusR ="   
  giTalaCount = 0
 endif
 giTalaCount = (giTalaCount+1)% iSteps
 xout giRythArrP
endop
opcode ArrPlusJ, i[], i[]i
 iInArr[],iSteps xin
 if giTalaCount == giChngIndx then
  giRythArrP[giElement] =  iInArr[giElement]+ giPlusArr[giPlusCount]
  giRythArrP[giElement] = ( giRythArrP[giElement] < 1 ) ?
    giRythArr[giElement] :  giRythArrP[giElement]
  giChngIndx = (giChngIndx+1)% 3
  giChngIndx = (giChngIndx=0) ? 1: giChngIndx 
  giTalaCount = 0
  giElement = (giElement+1)%iSteps
  giPlusCount =(giPlusCount+1) % lenarray(giPlusArr)
  printarray giRythArrP,"%.02f", "ArrPlusJ =" 
 endif
 giTalaCount = (giTalaCount+1)% iSteps
 xout giRythArrP
endop



instr widgets
;;tempo
 kBPM chnget "BPM"
 kdvn chnget "DV" 
 
  gkTempo = (kBPM/60)*kdvn


 ;;sequencer
 kSq chnget "sq"
 schedule "WidtArrW",0,0
schedule "WidtArrR",0,0
 if kSq == 1 && changed(kSq) == 1 then
  schedulek "TIAB_seq1", 0, 999
  schedulek "WidtArrR",0,0
 elseif kSq == 0 && changed(kSq) == 1 then
  turnoff2 "TIAB_seq1", 0, 0
 endif 
 gkdur chnget "dur"
 gkDing chnget "dng"

 
 ;;rythm
 gkTala chnget "tala"
 gkRySteps chnget "rysteps"
 
;;out widgets
 kSqCC    ctrl7    5,20,0,1
 kHoldCC    ctrl7    5,21,0,1
 if changed(kSqCC) == 1 then
 chnset kSqCC,    "sq"
 endif
 if changed(kHoldCC) == 1 then
 chnset kHoldCC,    "hold"
 endif
 
 
endin

instr MIDI_Play
 kHold chnget "hold"

 kstatus, kchn, kNote, kVel  midiin
 ktrig changed kchn, kNote, kVel
 kCount init 0
 if ktrig == 1 && kVel != 0 then
 kCount = ((kCount+1) > giLength) ? giLength : kCount+1
 elseif ktrig == 1 && kVel == 0 then
  kCount = (kCount-1 < 0) ? 0 : kCount-1
 endif
 
 if kVel != 0 && ktrig == 1 && kCount == 1 then
  schedulek "NoteRmv",  0, 0, kNote
 endif
 if kHold == 0 && changed(kHold) == 1 then
schedulek "NoteRmv",  0, 0, 0
 endif
 
 kchan chnget "sqmod"
 
 	if     kVel != 0 && ktrig == 1 && kchan == 1 && kCount != 1 then
  	 schedulek "NoteOn_sq1",  0, 0, kNote
 	elseif kVel == 0 && ktrig == 1 && kchan == 1 && kHold == 0 then
  	 schedulek "NoteOff_sq1", 0, 0, kNote
 	endif

endin

instr WidtArrW
 iWidget = 0
 while iWidget < 14 do
   S1 sprintfk "pos(%d, %d)", iWidget%14*40+25, 90
   S2 sprintfk "check_ident%d", iWidget+1
   S3 sprintfk "pos(%d, %d)", iWidget%14*40+40, 125
   S4 sprintfk "sq_ident%d", iWidget+1
   S5 sprintfk "pos(%d, %d)", iWidget%14*40+40, 145
   S6 sprintfk "ac_ident%d", iWidget+1
   chnset S1, S2
   chnset S3, S4
   chnset S5, S6
   iWidget += 1
 od

 iRyArr [] fillarray 1, .5,.5, 1, 2, 1, 2,2, .5,.5, 1, 2, 1, 3
 iAcArr [] fillarray 1,0,1,0,0,0,1,1,0,0,1,1,1,0
 iWrite = 0
 while iWrite < 14 do
   S2 sprintfk "check%d", iWrite+1
   chnset iRyArr[iWrite], S2
   S6 sprintfk "ac%d", iWrite+1
   chnset iAcArr[iWrite], S6
   iWrite += 1
 od 

endin

instr WidtArrR
ktrigarr chnget "check%d"
 iRead = 0
 iSteps[] init 14
 iAcArr[] init 14
 while iRead < 14 do 
   iSteps[iRead] chnget sprintfk("check%d", iRead+1)
   iAcArr[iRead] chnget sprintfk("ac%d", iRead+1)
   iRead += 1
 od
 printarray iSteps,"%.1f", "Steps ="
    giRythArr [] = iSteps
	giRythArrP [] = iSteps	
	giAccArr [] = iAcArr
endin


instr NoteOn_sq1
 giCountMIDI = (giCountMIDI+1 >= giLength) ? giLength : giCountMIDI+1
 iNote = p4
 iRead = giCountMIDI 
 if giCountMIDI == 0 then
  giNoteArr [] = giEmptyArr
 endif
 while iRead < giLength do
  giNoteArr [iRead] = giEmptyArr[iRead]
  iRead += 1
 od	
 giNoteArr [giCountMIDI-1] = iNote	
 printarray giNoteArr, "%.0f", "Notes On ="
endin
instr NoteOff_sq1
 giCountMIDI = (giCountMIDI-1 < 0) ? 0 : giCountMIDI-1
 iRead  = 0
 iWrite = 0
 iNote  = p4
 while iRead < giLength do
   if giNoteArr[iRead] != iNote then		
     giNoteArr [iWrite] = giNoteArr [iRead]						
     iWrite += 1											
   endif		
 iRead +=1
 od
 iRead2 = giCountMIDI
  while iRead2 < giLength do
  giNoteArr [iRead2] = giEmptyArr[iRead2]
  iRead2 += 1
 od	
 printarray giNoteArr, "%.0f", "Notes Off ="
endin



instr NoteRmv
giCountMIDI = 1
giNoteArr [] = giEmptyArr
giNoteArr [giCountMIDI-1] = p4
printarray giNoteArr, "%.0f", "Notes On ="
endin



;;short sequencer 1
instr TIAB_seq1
;to infinity and beyond

kTala = gkTala
kRythArrIndx init 0
kNoteArrIndx init 0
kAccArrIndx  init 0
kTime init 0
kDur = 1



if metro:k(kTime) == 1 then
kTime = 1/(giRythArrP[kRythArrIndx])*gkTempo
  if giNoteArr[kNoteArrIndx] != 0 then
   schedulek "MIDIout",0,gkdur,giNoteArr[kNoteArrIndx], 20*(giAccArr[kAccArrIndx]+1)
   if gkDing == 1 then
   schedulek "Ding",0,gkdur,giNoteArr[kNoteArrIndx],(100*(giAccArr[kAccArrIndx]+1))/500
   endif
  endif
   
            schedulek "SeqArrOn",0,0,kRythArrIndx+1
			schedulek "SeqArrOff",0.2,0,kRythArrIndx+1
kRythArrIndx = (kRythArrIndx+1) %  gkRySteps;lenarray(giRythArrP)
kNoteArrIndx = (kNoteArrIndx+1) % (giCountMIDI)

kAccArrIndx  = (kAccArrIndx+1)  % gkRySteps
	if kRythArrIndx == 0 then
	schedulek "TalaTrig",0,0,kTala,gkRySteps
	endif
	
			
endif


;printk2 kRythArrIndx

endin



instr Ding
 iFreq    = p4
 iAmp     = p5
iAtt= 0.01
iRel = 1
 aEnv transeg 0, iAtt, 4, iAmp, p3-iAtt, -4, 0
 aSine poscil aEnv, mtof(iFreq)
out aSine,aSine
endin


;;triger instrument
instr TalaTrig
iTala = p4
iSteps = p5
if iTala == 1 then
giRythArrP [] = giRythArr
elseif iTala == 2 then
giRythArrP [] ArrTala giRythArr,iSteps
elseif iTala == 3 then
giRythArrP [] ArrRep giRythArr,iSteps
elseif iTala == 4 then
giRythArrP [] ArrPlus giRythArr,iSteps
elseif iTala == 5 then
giRythArrP [] ArrPlusR giRythArr,iSteps
elseif iTala == 6 then
giRythArrP [] ArrPlusJ giRythArr,iSteps
endif

iWrite = 0
 while iWrite < 14 do
   S2 sprintfk "check%d", iWrite+1
   chnset giRythArrP[iWrite], S2
   iWrite += 1
 od 

;printarray giRythArr,"%.02f", "org ="
;printarray giRythArrP,"%.02f", "note ="
endin


instr MIDIout
inum = p4
ivel = p5
print inum
midion 1, inum, ivel
endin


instr SeqArrOn
 S1 sprintfk "sq%d",p4
 chnset 1, S1
endin  
instr SeqArrOff
 S1 sprintfk "sq%d",p4
 chnset 0, S1
endin   

</CsInstruments>
<CsScore>
i "MIDI_Play" 0 [6^6]
i "widgets"   0 [6^6]
</CsScore>
</CsoundSynthesizer>

