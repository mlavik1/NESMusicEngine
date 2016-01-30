; ----------------------------------------------------------------------
; ------------------     MAIN FILE - For testing -----------------------
; ------------------                             -----------------------
; ----------------------------------------------------------------------

  .inesprg 1  
  .ineschr 1   
  .inesmap 0 
  .inesmir 1  

;;;;;;;;;;;;;;;
	
  .bank 0
  .org $C000 
  
  .include "sound_engine.asm"  
  .include "mysong.asm"
  
RESET:
  SEI         
  CLD        
  LDX #$40
  STX $4017   
  LDX #$FF
  TXS         
  INX     
  STX $2000  
  STX $2001    
  STX $4010   

vblankwait1:     
  BIT $2002
  BPL vblankwait1

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x 
  INX
  BNE clrmem
   

  LDA #%10000000   ; enable NMI
  STA $2000


  ; *******************************
  ; *** Initialise Sound Engine ***

  LDA MySong
  STA song_header
  LDA MySong+1
  STA song_header+1
  
  JSR set_song
  ; *******************************
  
Forever:


  JMP Forever  
  
 
 

 

NMI:
  LDA #$00
  STA $2003  
  LDA #$02
  STA $4014 
  
  
  ; Update music:
  JSR se_update
  


  
  RTI        
 
;;;;;;;;;;;;;;  
  
  
  
  .bank 1
  .org $E000
  ; ...

  .org $FFFA  
  .dw NMI       
                 
  .dw RESET     
              
  .dw 0       
  
  
;;;;;;;;;;;;;; 
  
  
  .bank 2
  .org $0000
