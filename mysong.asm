MySong:
  .word MySongHeader
MySongHeader:
; ***** HEADER *****

  .byte $33              ; Tempo

  ; Tracks:
  .word mysong_square1   ; Square1 track
  .word mysong_square2   ; Square1 track
  .word mysong_triangle  ; Triangle track
  .word mysong_drums     ; Drum track
  
  ; Todo:
  ;  ENVELOPES
  ;  SWEEP UNIT
  
  ; BRA LYDAR:
  ; 10100000 & $00
  ; 10000000 & $00
  
  ; Instrument settings
  .byte %10000000 ; Square 1 - DDLC VVVV 	Duty (D), envelope loop / length counter halt (L), constant volume (C), volume/envelope (V)
  .byte $00       ; Square 1 - EPPP NSSS 	Sweep unit: enabled (E), period (P), negate (N), shift (S) 
  .byte %10101000 ; Square 2 - DDLC VVVV 	Duty (D), envelope loop / length counter halt (L), constant volume (C), volume/envelope (V) 
  .byte $87       ; Square 2 - EPPP NSSS 	Sweep unit: enabled (E), period (P), negate (N), shift (S) 
  .byte %10000111 ; Triangle - CRRR RRRR 	Length counter halt / linear counter control (C), linear counter load (R)
  .byte %11000000 ; Drums - M M ? ? T T T T  (M=MOde, T=Type)
  
  
mysong_sweep1:
   .byte $0F, $0E, $0D, $0C, $09, $05, $00, $FF
   
mysong_sweep2:
   .byte $0F, $0E, $0D, $0C, $09, $05, $00, $FF

mysong_env1:
   .byte $0F, $0E, $0D, $0C, $09, $05, $00, $FF

mysong_env2:
   .byte $0F, $0E, $0D, $0C, $09, $05, $00, $FF
  

  ; ***** STREAMS *****
mysong_square1:
    .word mysong_square1_stream
mysong_square1_stream:
    ;.byte l4,C5,C5,C5,C5,B4,B4,D5,D5,$FF
	.byte l16,C2,D2,E2,G2,C3,D3,E3,G3,C4,D4,E4,G4,C5,D5,E5,G5,C6,G5,E5,D5,C5,G4,E4,D4,C4,G3,E3,D3,C3,G2,E2,D2
	.byte l16,A1,B1,C2,E2,A2,B2,C3,E3,A3,B3,C4,E4,A4,B4,C5,E5,A5,E5,C5,B4,A4,E4,C4,B3,A3,E3,C3,B2,A2,E2,C2,B1
	.byte l16,BR,BR,A1,C2,F2,G2,A2,C3,F3,G3,A3,C4,F4,G4,A4,C5,F5,C5,A4,G4,F4,C4,A3,G3,F3,C3,A2,G2,F2,C2,A1,BR
	.byte l16,BR,A1,B1,D2,G2,A2,B2,D3,G3,A3,B3,D4,G4,A4,B4,D5,G5,D5,B4,A4,G4,D4,B3,A3,G3,D3,B2,A2,G2,D2,B1,A1,$FF


mysong_square2:
    .word mysong_square2_stream
mysong_square2_stream:
    .byte l16,C2,D2,E2,G2,C3,D3,E3,G3,C4,D4,E4,G4,C5,D5,E5,G5,C6,G5,E5,D5,C5,G4,E4,D4,C4,G3,E3,D3,C3,G2,E2,D2,$FF
	

mysong_triangle:
    .word mysong_triangle_stream
mysong_triangle_stream:
    ;.byte l16,C2,D2,E2,G2,C3,D3,E3,G3,C4,D4,E4,G4,C5,D5,E5,G5,C6,G5,E5,D5,C5,G4,E4,D4,C4,G3,E3,D3,C3,G2,E2,D2,$FF
	.byte l8,C3,BR,C3,l16,BR,G2,l8,A2,C3,BR,G2,A2,C3,A2,C3,BR,C3,A2,C3
	.byte l8,A2,BR,A2,l16,BR,E2,l8,G2,A2,BR,E2,G2,A2,G2,A2,BR,A2,G2,A2
	.byte l8,F2,BR,F2,l16,BR,C2,l8,D2,F2,BR,C2,D2,F2,D2,F2,BR,F2,D2,F2
	.byte l8,G2,BR,G2,l16,BR,D2,l8,F2,G2,BR,D2,F2,G2,F2,G2,BR,G2,F2,G2,$FF
mysong_drums:
    .word mysong_drums_stream
mysong_drums_stream:
    .byte l16,3,BR,3,BR,11,BR,3,BR,$FF
	
