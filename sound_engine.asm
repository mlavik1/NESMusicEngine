
  ; ***** TIME *****
frame_ticker      .rs 1

song_tempo        .rs 1


  ; *** TEMP ***
tmp_byte               .rs 1
tmp_word               .rs 2
tmp_stream_no          .rs 1
tmp_stream_pos_ptr     .rs 2


  ; ***** INSTRUMENTS *****
instrument_settings1 .rs 4
  
instrument_settings2 .rs 4
  
apu_loc1:
 .byte $00
 .byte $04
 .byte $08
 .byte $0C
  
apu_loc2:
 .byte $01
 .byte $05
 .byte $09
 .byte $0D
  
apu_loc_tone:
 .byte $02
 .byte $06
 .byte $0A
 .byte $0E

apu_channel_enable:
 .byte $%00000001
 .byte $%00000010
 .byte $%00000100
 .byte $%00001000
  
  ; ***** POINTERS*****

song_header               .rs 2           ; song header

stream_header             .rs 8           ; header of each stream

stream_ptr                .rs 8

stream_len                .rs 4           ; note length (decreased each tick) - tempo counter

stream_curr_len           .rs 4           ; note length (decreased each tick) - tempo counter

stream_pos                .rs 8           ; position in stream:




note_length_table:
    .byte $01   ;32nd note
    .byte $02   ;16th note
    .byte $04   ;8th note
    .byte $08   ;quarter note
    .byte $10   ;half note
    .byte $20   ;whole note

  
  ; ********************************
  ; ********** NOTE TABLE **********
  ; (found this table online)
note_table:;       C    C#/Db    D    D#/Eb    E       F    F#/Gb    G      A    A#/Bb    B
    .word                                                                $07F1, $0780, $0713 ; 1
    .word $06AD, $064D, $05F3, $059D, $054D, $0500, $04B8, $0475, $0435, $03F8, $03BF, $0389 ; 2
    .word $0356, $0326, $02F9, $02CE, $02A6, $027F, $025C, $023A, $021A, $01FB, $01DF, $01C4 ; 3
    .word $01AB, $0193, $017C, $0167, $0151, $013F, $012D, $011C, $010C, $00FD, $00EF, $00E2 ; 4
    .word $00D2, $00C9, $00BD, $00B3, $00A9, $009F, $0096, $008E, $0086, $007E, $0077, $0070 ; 5
    .word $006A, $0064, $005E, $0059, $0054, $004F, $004B, $0046, $0042, $003F, $003B, $0038 ; 6
    .word $0034, $0031, $002F, $002C, $0029, $0027, $0025, $0023, $0021, $001F, $001D, $001B ; 7
    .word $001A, $0018, $0017, $0015, $0014, $0013, $0012, $0011, $0010, $000F, $000E, $000D ; 8
    .word $000C, $000C, $000B, $000A, $000A, $0009, $0008                                    ; 9
  
END = $FF
BR = $FE
l32 = $A0
l16 = $A1
l8 = $A2
l4 = $A3
l2 = $A4
l1 = $A5
  
;Octave 1
A1 = $00    
As1 = $01  
Bb1 = $01 
B1 = $02

;Octave 2
C2 = $03
Cs2 = $04
Db2 = $04
D2 = $05
Ds2 = $06
Eb2 = $06
E2 = $07
F2 = $08
Fs2 = $09
Gb2 = $09
G2 = $0A
Gs2 = $0B
A2 = $0C
As2 = $0D
Bb2 = $0D
B2 = $0E

;Octave 3
C3 = $0F
Cs3 = $10
Db3 = $10
D3 = $11
Ds3 = $12
Eb3 = $12
E3 = $13
F3 = $14
Fs3 = $15
Gb3 = $15
G3 = $16
Gs3 = $17
A3 = $18
As3 = $19
Bb3 = $19
B3 = $1A

;Octave 4
C4= $1B
Cs4 = $1C
Db4 = $1C
D4 = $1D
Ds4 = $1E
Eb4 = $1E
E4 = $1F
F4 = $20
Fs4 = $21
Gb4 = $21
G4 = $22
Gs4 = $23
A4 = $24
As4 = $25
Bb4 = $25
B4 = $26

;Octave 5
C5= $27
Cs5 = $28
Db5 = $28
D5 = $29
Ds5 = $2A
Eb5 = $2A
E5 = $2B
F5 = $2C
Fs5 = $2D
Gb5 = $2D
G5 = $2E
Gs5 = $2F
A5 = $30
As5 = $31
Bb5 = $31
B5 = $32

;Octave 6
C6= $33


  ; ********************************
  

  
  JMP EndOfCode
  
  
  
; -------------------- [ Routine: se_init ] --------------------
; ----------------- initialises the sound engine----------------
se_init:
 
 ; Enable all sound channels:
  LDA #%11111101
  STA $4015

 ; Instrument settings:
  LDX #0
.instrument_settings_loop:
  LDY apu_loc1,X                         ; APU register location 1
  lda instrument_settings1,X
  sta $4000,Y
  LDY apu_loc2,X                         ; APU register location 1
  lda instrument_settings2,X
  sta $4000,Y
  INX
  CPX #4
 BNE .instrument_settings_loop
 

 ; **      **
 ;lda  #$87      ; sweep enabled, shift = 7 (1/128)
 ; sta  $4001
 ;lda  #$C0      ; clock sweep immediately
  ;sta  $4017
  
 RTS
 
 
; -------------------- [ Routine: set_song ] -------------------
; ----------------- reads song and stream headers----------------
set_song:

  ldy #$00
  STY tmp_stream_no  ; FIX THIS MESS !!!

  LDA [song_header],y        ; song tempo: this number will be added to frame_counter each frame
  STA song_tempo
  iny
  
 ; --- load stream pointers ---
  ldx #0
LoadStreams:                  ; loads all stream pointers
  LDA [song_header],y
  STA stream_ptr,x
  iny
  inx     ; FIX THIS MESS !!!
  LDA [song_header],y
  STA stream_ptr,x
  JSR reset_stream_position    ; reset each stream position
  iny
  inx     ; FIX THIS MESS !!!
  INC tmp_stream_no      ; FIX THIS MESS !!!
  cpx #8
 BNE LoadStreams
 ; ---
 
  ;Todo:
  ;  ENVELOPES
  ;  SWEEP UNIT
 
 ; --- load instrument settings ---
  LDA [song_header],y
  STA instrument_settings1
  iny
  LDA [song_header],y
  STA instrument_settings2
  iny
  LDA [song_header],y
  STA instrument_settings1+1
  iny
  LDA [song_header],y
  STA instrument_settings2+1
  iny
  LDA [song_header],y
  STA instrument_settings1+2
  iny
  LDA [song_header],y
  STA instrument_settings1+3
  iny
  ; ---
  
  
  ; -- set initial stream length counters to 1 ---
  LDX #0                        ; first stream
  LDA #1                        ; initial length counter
.init_streams_loop:              ; loop through all streams
  STA stream_curr_len,x
  inx
  CPX #4
 BNE .init_streams_loop
  
  
  
  JSR se_init  
  
 RTS ; set_song
  
  
; -------------------- [ Routine: se_update ] --------------------
; --------------------- updates frame ticker ---------------------
se_update:

  LDA frame_ticker
  ADC song_tempo 
  STA frame_ticker               ; update frame ticker
  BCS se_tick                    ; frame tick?
  
  
  
 RTS ; se_update
 
 
; -------------------- [ Routine: se_tick ] --------------------
; ----------------                              ----------------
se_tick:
  LDX #0                        ; first stream
  STX tmp_stream_no
.stream_loop:                   ; loop through all streams
  DEC stream_curr_len,x
  BNE .continue_playing
  JSR read_stream               ; read next from stream
.continue_playing
  INX
  CPX #4
  STX tmp_stream_no
  BNE .stream_loop              ; next stream

 RTS ; se_tick
 
 
; ------------- [ Routine: read_frame ] -------------
; ------- NOTE: Keep stream_no in x-register --------
read_stream:

  LDA tmp_stream_no             ; get stream number
  ASL A
  TAX
 ; store current stream position in temp variable
  LDA stream_pos,X
  STA tmp_stream_pos_ptr
  LDA stream_pos+1,X
  STA tmp_stream_pos_ptr+1

  JSR increment_stream_position    
  
  LDY #0
  LDA [tmp_stream_pos_ptr],Y      ; load the current stream value 
  
 ; End of stream? :
  CMP #END
   BNE .check_if_break
   JSR reset_stream_position       ; end of stream: reset pointer
   JMP read_stream
   
.check_if_break
  CMP #BR
    BNE .not_break
	LDX tmp_stream_no
	LDY apu_loc_tone,X         
    LDA #0
    STA $4000,Y
    STA $4000+1,Y
	JMP .skip_play
.not_break
  
.check_if_length
  CMP #l32
    BCC .play_note
    TAY
    ;LDA #4
	AND #%00001111
	TAX
	LDA note_length_table,X
    LDX tmp_stream_no
    STA stream_len,x
	TYA
    JMP  read_stream
   
.play_note:  
  ASL A                           ; binary multiplication by 2  
  LDX tmp_stream_no
  LDY apu_loc_tone,X         
  TAX
  LDA note_table,X
    STA $4000,Y
  LDA note_table+1,X
    STA $4000+1,Y
  
.skip_play:
  ; **** TEMP ******
  ; TODO: Les stream length fr? notelengde
  ;LDA #2
  LDX tmp_stream_no
  LDA stream_len,x
  STA stream_curr_len,x
  
 RTS ; read_frame 
  
  
; -------------------- [ Routine: reset_stream_position ] -------------------
; -------------------- NOTE: set tmp_stream_no first   ----------------------
reset_stream_position:
  STX tmp_word
  STY tmp_word+1
  
  LDA tmp_stream_no             ; get stream number
  ASL A
  TAX
  
  LDA stream_ptr,X
  STA tmp_stream_pos_ptr
  LDA stream_ptr+1,X
  STA tmp_stream_pos_ptr+1 
  
  LDY #0
  LDA [tmp_stream_pos_ptr],Y      ; load the current stream value 
  STA stream_pos,X
  INX
  INY
  LDA [tmp_stream_pos_ptr],Y      ; load the current stream value 
  STA stream_pos,X 
  
  LDA #2
  STA stream_len,X
  
  LDX tmp_word
  LDY tmp_word+1
 RTS
  
increment_stream_position:
  LDA tmp_stream_no             ; get stream number
  ASL A
  TAX 
   ; Increase stream pointer: go to next position
  LDA stream_pos,X
  ADC #1
  STA stream_pos,X
  BCC .no_carry
  INX
  LDA stream_pos,X
  CLC
  ADC #1
  STA stream_pos,X
.no_carry:                       ; stream_pos' high-bit > #$FF
   
 RTS
  
EndOfCode:
  BRK
