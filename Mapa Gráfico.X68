*-----------------------------------------------------------
* Title      : Sokoban
* Written by : �ngel Vidal Dom�nguez
* Date       : 05/2021
* Description: Sokoban
*-----------------------------------------------------------
DRKGRAY EQU $00404040
YELLOW    EQU $000FFFF
GREEN EQU $0000FF00
DRKBROWN EQU $00004080 
LIGHTBROWN EQU $00004ABA
BLACK EQU $00000000
WHITE EQU $00FFFFFF
GREENISHYELLOW EQU $0000CEC6

 
ORIX EQU 100
ORIY EQU 100
SIZE EQU 100
 
    ORG    $1000
START
CONFIG
    MOVE.B #62,D0
    MOVE.L #1,D1
    TRAP #15
    MOVE.L #33,D0
    MOVE.L #1024*$10000+768,D1
    TRAP #15
    MOVE.L #21,D0
    MOVE.L #$00FFFFFF,D1
    MOVE.L #$03181111,D2
    TRAP #15
    CLR D0
    CLR D1
    CLR D2
BUCLEPRINCIPAL
    JSR PINTAMAPA
    JSR SHOWTIME
    JSR TECLA
    JSR DELAY
    JSR BORRAMAPA
    MOVE.L #$0,D6
    JSR ERRORES
    CMP.L #$1,D6
    BEQ BUCLEPRINCIPAL
    JSR FINMAPA  
FINMAPA
    JSR BORRAMAPA
    JSR PINTAMAPA
    MOVE.L #21,D0
    MOVE.L #$00FFFFFF,D1
    MOVE.L #$03110000,D2
    TRAP #15
    JSR BLANCO
    LEA FINAL,A1
    MOVE.B #11,D0
    MOVE.W #0505,D1
    TRAP #15
    MOVE.B #17,D0
    MOVE.L D7,D1
    TRAP #15
    
    SIMHALT
    
    
************SUB TECLA  
*IZQUIERDA $25, ARRIBA $26, DERECHA $27 Y ABAJO $28
TECLA
    MOVE.B #19,D0
    MOVE.L #$28272625,D1
    TRAP #15
    CMP.L #$FF000000,D1
    BEQ ABAJO
    CMP.L #$00FF0000,D1
    BEQ DERECHA
    CMP.L #$0000FF00,D1
    BEQ ARRIBA
    CMP.L #$000000FF,D1
    BEQ IZQUIERDA
    RTS
    
************SUB DELAY
DELAY
    MOVE.B #23,D0       *Retardo del juego
    MOVE.L #10,D1       *10 milisegundos de retardo
    TRAP #15
    ADD.L #1,D5
    CMP.L #10,D5
    BEQ SEGUNDO
    RTS
SEGUNDO
    ADD.L #1,D7         *Esto es la compensaci�n en segundos
    SUB.L #10,D5
    RTS

************SUB ARRIBA
ERRORES
    MOVE.L #MAPA1,A1
BUCLEE  
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILAE
    CMP.B #'$',D0
    BNE NOCAJAE
    BEQ SICAJAE
NOCAJAE
    JMP BUCLEE
SICAJAE
    MOVE.L #$1,D6
    SUB.L #$2,A1
    MOVE.B (A1),D0
    CMPI.L #'#',D0
    BEQ COMPROBARAYA1
    CMPI.L #'%',D0
    BEQ COMPROBARAYA1
    ADD.L #$2,A1
    MOVE.B (A1),D0
    CMPI.L #'#',D0
    BEQ COMPROBARAYA2
    CMPI.L #'$',D0
    BEQ SIGUIENTECAJA1
    CMPI.L #'%',D0
    BEQ COMPROBARAYA2
    JMP BUCLEE
COMPROBARAYA1
    ADD.L #$1,A1
    SUB.L #$8,A1
    MOVE.B (A1),D0
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'%',D0
    BEQ ERROR
    ADD.L #$8,A1
    ADD.L #$8,A1
    MOVE.B (A1),D0
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'$',D0
    BEQ SIGUIENTECAJA2
    CMPI.L #'%',D0
    BEQ ERROR
    SUB.L #$7,A1
    JMP BUCLEE
COMPROBARAYA2
    SUB.L #$1,A1
    ADD.L #$8,A1
    MOVE.B (A1),D0 
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'$',D0
    BEQ SIGUIENTECAJA2
    CMPI.L #'%',D0
    BEQ ERROR
    SUB.L #$8,A1
    SUB.L #$8,A1
    MOVE.B (A1),D0 
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'%',D0
    BEQ ERROR
    ADD.L #$9,A1
    JMP BUCLEE
SIGUIENTECAJA1
    SUB.L #$1,A1
    ADD.L #$8,A1
    MOVE.B (A1),D0
    SUB.L #$8,A1 
    CMPI.L #'#',D0
    BEQ ERRORCAJA1
    CMPI.L #'%',D0
    BEQ ERRORCAJA1
    SUB.L #$8,A1
    MOVE.B (A1),D0
    ADD.L #$8,A1 
    CMPI.L #'#',D0
    BEQ ERRORCAJA1
    CMPI.L #'%',D0
    BEQ ERRORCAJA1
    ADD.L #$1,A1
    JMP BUCLEE
ERRORCAJA1
    ADD.L #$9,A1
    MOVE.B (A1),D0 
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'%',D0
    BEQ ERROR
    SUB.L #$8,A1
    SUB.L #$8,A1
    MOVE.B (A1),D0
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'%',D0
    BEQ ERROR
    ADD.L #$8,A1
    JMP BUCLEE
SIGUIENTECAJA2
    SUB.L #$1,A1
    MOVE.B (A1),D0
    ADD.L #$1,A1
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'%',D0
    BEQ ERROR
    ADD.L #$1,A1
    MOVE.B (A1),D0
    SUB.L #$1,A1
    CMPI.L #'#',D0
    BEQ ERROR
    CMPI.L #'%',D0
    BEQ ERROR
    SUB.L #$7,A1
    JMP BUCLEE    
ERROR   
    MOVE.L #MAPA1,A1
    MOVE.L #'####',(A1)
    ADD.L #$4,A1
    MOVE.L #'## ',(A1)
    ADD.L #$4,A1
    MOVE.L #'#@  ',(A1)
    ADD.L #$4,A1
    MOVE.L #' ##',(A1)
    ADD.L #$4,A1
    MOVE.L #'# $$',(A1)
    ADD.L #$4,A1
    MOVE.L #'  #',(A1)
    ADD.L #$4,A1
    MOVE.L #'# #.',(A1)
    ADD.L #$4,A1
    MOVE.L #' .#',(A1)
    ADD.L #$4,A1
    MOVE.L #'#   ',(A1)
    ADD.L #$4,A1
    MOVE.L #'  #',(A1)
    ADD.L #$4,A1
    MOVE.L #'####',(A1)
    ADD.L #$4,A1
    MOVE.L #'###',(A1)
    RTS  
NUEVAFILAE
    CMP.B #0,(A1)
    BNE BUCLEE
    RTS   
************SUB ARRIBA
ARRIBA
    MOVE.L #MAPA1,A1
BUCLEA2  
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILAA2
    CMP.B #'@',D0
    BEQ SIPERSA2
    CMP.B #'+',D0
    BNE NOPERSA2
    BEQ SIPERSA2O
NOPERSA2
    JMP BUCLEA2
SIPERSA2
    SUB.L #$9,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERARRIBA
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAA2
    CMPI.B #'%',D0
    BEQ COMPROBARCAJAA2F
    CMPI.B #'.',D0
    BEQ MOVEROBJARRIBA
    ADD.L #$9,A1
    BNE BUCLEA2
MOVEROBJARRIBA
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    SUB.L #$7,A1
    JMP BUCLEA2
MOVERARRIBA
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    SUB.L #$7,A1
    JMP BUCLEA2
COMPROBARCAJAA2
    SUB.L #$8,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAA2
    CMPI.B #'.',D0
    BEQ FIJARCAJAA2
    JMP BUCLEA2
MOVERCAJAA2
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEA2
FIJARCAJAA2
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEA2
COMPROBARCAJAA2F
    SUB.L #$8,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAA2F
    CMPI.B #'.',D0
    BEQ FIJARCAJAA2F
    JMP BUCLEA2
MOVERCAJAA2F
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEA2
FIJARCAJAA2F
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEA2
SIPERSA2O
    SUB.L #$9,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERARRIBAO
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAA2O
    CMPI.B #'.',D0
    BEQ MOVEROBJARRIBA0
    ADD.L #$9,A1
    BNE BUCLEA2
MOVEROBJARRIBA0
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    SUB.L #$7,A1
    JMP BUCLEA2
MOVERARRIBAO
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    SUB.L #$7,A1
    JMP BUCLEA2
COMPROBARCAJAA2O
    SUB.L #$8,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAA2O
    CMPI.B #'.',D0
    BEQ FIJARCAJAA2O
    JMP BUCLEA2
MOVERCAJAA2O
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    JMP BUCLEA2
FIJARCAJAA2O
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$8,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    JMP BUCLEA2
NUEVAFILAA2
    CMP.B #0,(A1)
    BNE BUCLEA2
    RTS
    
************SUB ABAJO
ABAJO
    MOVE.L #MAPA1,A1
BUCLEA1  
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILAA1
    CMP.B #'@',D0
    BEQ SIPERSA1
    CMP.B #'+',D0
    BNE NOPERSA1
    BEQ SIPERSA1O
NOPERSA1
    JMP BUCLEA1
SIPERSA1
    ADD.L #$7,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERABAJO
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAA1
    CMPI.B #'%',D0
    BEQ COMPROBARCAJAA1F
    CMPI.B #'.',D0
    BEQ MOVEROBJABAJO
    BNE BUCLEA1
MOVEROBJABAJO
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
MOVERABAJO
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
COMPROBARCAJAA1
    ADD.L #$8,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAA1
    CMPI.B #'.',D0
    BEQ FIJARCAJAA1
    JMP BUCLEA1
MOVERCAJAA1
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
FIJARCAJAA1
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$A,A1
    JMP BUCLEA1
COMPROBARCAJAA1F
    ADD.L #$8,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAA1F
    CMPI.B #'.',D0
    BEQ FIJARCAJAA1F
    JMP BUCLEA1
MOVERCAJAA1F
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
FIJARCAJAA1F
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$A,A1
    JMP BUCLEA1
SIPERSA1O
    ADD.L #$7,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERABAJOO
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAA1O
    CMPI.B #'.',D0
    BEQ MOVEROBJABAJOO
    BNE BUCLEA1
MOVEROBJABAJOO
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
MOVERABAJOO
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
COMPROBARCAJAA1O
    ADD.L #$8,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAA1O
    CMPI.B #'.',D0
    BEQ FIJARCAJAA1O
    JMP BUCLEA1
MOVERCAJAA1O
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    ADD.L #$9,A1
    JMP BUCLEA1
FIJARCAJAA1O
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$8,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    ADD.L #$A,A1
    JMP BUCLEA1
NUEVAFILAA1
    CMP.B #0,(A1)
    BNE BUCLEA1
    RTS
    
************SUB DERECHA
DERECHA
    MOVE.L #MAPA1,A1
BUCLED  
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILAD
    CMP.B #'@',D0
    BEQ SIPERSD
    CMP.B #'+',D0
    BNE NOPERSD
    BEQ SIPERSDO
NOPERSD
    JMP BUCLED
SIPERSD
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERDERECHA
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAD
    CMPI.B #'%',D0
    BEQ COMPROBARCAJADF
    CMPI.B #'.',D0
    BEQ MOVEROBJDERECHA
    BNE BUCLED
MOVEROBJDERECHA
    MOVE.B #'+',D0
    MOVE.B D0,(A1)+
    MOVE.B D0,-(A1)
    MOVE.B #' ',D0
    MOVE.B D0,-(A1)
    MOVE.B D0,(A1)+
    MOVE.B #'+',D0
    MOVE.B D0,(A1)+
    JMP BUCLED
MOVERDERECHA
    MOVE.B #'@',D0
    MOVE.B D0,(A1)+
    MOVE.B D0,-(A1)
    MOVE.B #' ',D0
    MOVE.B D0,-(A1)
    MOVE.B D0,(A1)+
    MOVE.B #'@',D0
    MOVE.B D0,(A1)+
    JMP BUCLED
COMPROBARCAJAD
    ADD.L #$1,A1
    MOVE.B (A1)+,D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAD
    CMPI.B #'.',D0
    BEQ FIJARCAJAD
    JMP BUCLED
MOVERCAJAD
    SUB.L #$1,A1
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$2,A1
    JMP BUCLED
FIJARCAJAD
    SUB.L #$1,A1
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$2,A1
    JMP BUCLED
COMPROBARCAJADF
    ADD.L #$1,A1
    MOVE.B (A1)+,D0
    CMPI.B #' ',D0
    BEQ MOVERCAJADF
    CMPI.B #'.',D0
    BEQ FIJARCAJADF
    JMP BUCLED
MOVERCAJADF
    SUB.L #$1,A1
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$2,A1
    JMP BUCLED
FIJARCAJADF
    SUB.L #$1,A1
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    ADD.L #$2,A1
    JMP BUCLED
SIPERSDO
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERDERECHAO
    CMPI.B #'$',D0
    BEQ COMPROBARCAJADO
    CMPI.B #'.',D0
    BEQ MOVEROBJDERECHAO
    BNE BUCLED
MOVEROBJDERECHAO
    MOVE.B #'+',D0
    MOVE.B D0,(A1)+
    MOVE.B D0,-(A1)
    MOVE.B #'.',D0
    MOVE.B D0,-(A1)
    MOVE.B D0,(A1)+
    MOVE.B #'+',D0
    MOVE.B D0,(A1)+
    JMP BUCLED
MOVERDERECHAO
    MOVE.B #'@',D0
    MOVE.B D0,(A1)+
    MOVE.B D0,-(A1)
    MOVE.B #'.',D0
    MOVE.B D0,-(A1)
    MOVE.B D0,(A1)+
    MOVE.B #'@',D0
    MOVE.B D0,(A1)+
    JMP BUCLED
COMPROBARCAJADO
    ADD.L #$1,A1
    MOVE.B (A1)+,D0
    CMPI.B #' ',D0
    BEQ MOVERCAJADO
    CMPI.B #'.',D0
    BEQ FIJARCAJADO
    JMP BUCLED
MOVERCAJADO
    SUB.L #$1,A1
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    ADD.L #$2,A1
    JMP BUCLED
FIJARCAJADO
    SUB.L #$1,A1
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    SUB.L #$1,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    ADD.L #$2,A1
    JMP BUCLED
NUEVAFILAD
    CMP.B #0,(A1)
    BNE BUCLED
    RTS

************SUB IZQUIERDA
IZQUIERDA
    MOVE.L #MAPA1,A1
BUCLEI  
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILAI
    CMP.B #'@',D0
    BEQ SIPERSI
    CMP.B #'+',D0
    BNE NOPERSI
    BEQ SIPERSIO
NOPERSI
    JMP BUCLEI
SIPERSI                         
    MOVE.B -(A1),D0
    MOVE.B -(A1),D0
    CMPI.B #' ',D0
    BEQ MOVERIZQUIERDA
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAI
    CMPI.B #'%',D0
    BEQ COMPROBARCAJAIF
    CMPI.B #'.',D0
    BEQ MOVEROBJIZQUIERDA
    MOVE.B (A1)+,D0
    MOVE.B (A1)+,D0
    BNE BUCLEI
MOVERIZQUIERDA
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    MOVE.B D0,(A1)+
    MOVE.B #' ',D0
    MOVE.B D0,(A1)+
    JMP BUCLEI
MOVEROBJIZQUIERDA
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    MOVE.B D0,(A1)+
    MOVE.B #' ',D0
    MOVE.B D0,(A1)+
    JMP BUCLEI
COMPROBARCAJAI
    SUB.L #$1,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAI
    CMPI.B #'.',D0
    BEQ FIJARCAJAI
    JMP BUCLEI
MOVERCAJAI
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEI
FIJARCAJAI
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEI
COMPROBARCAJAIF
    SUB.L #$1,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAIF
    CMPI.B #'.',D0
    BEQ FIJARCAJAIF
    JMP BUCLEI
MOVERCAJAIF
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEI
FIJARCAJAIF
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #' ',D0
    MOVE.B D0,(A1)
    JMP BUCLEI
SIPERSIO
    MOVE.B -(A1),D0
    MOVE.B -(A1),D0
    CMPI.B #' ',D0
    BEQ MOVERIZQUIERDAO
    CMPI.B #'$',D0
    BEQ COMPROBARCAJAIO
    CMPI.B #' ',D0
    BEQ MOVEROBJIZQUIERDAO
    MOVE.B (A1)+,D0
    MOVE.B (A1)+,D0
    BNE BUCLEI
MOVEROBJIZQUIERDAO
    MOVE.B #'+',D0
    MOVE.B D0,(A1)
    MOVE.B D0,(A1)+
    MOVE.B #'.',D0
    MOVE.B D0,(A1)+
    JMP BUCLEI
MOVERIZQUIERDAO
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    MOVE.B D0,(A1)+
    MOVE.B #'.',D0
    MOVE.B D0,(A1)+
    JMP BUCLEI
COMPROBARCAJAIO
    SUB.L #$1,A1
    MOVE.B (A1),D0
    CMPI.B #' ',D0
    BEQ MOVERCAJAIO
    CMPI.B #'.',D0
    BEQ FIJARCAJAIO
    JMP BUCLEI
MOVERCAJAIO
    MOVE.B #'$',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    JMP BUCLEI
FIJARCAJAIO
    MOVE.B #'%',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'@',D0
    MOVE.B D0,(A1)
    ADD.L #$1,A1
    MOVE.B #'.',D0
    MOVE.B D0,(A1)
    JMP BUCLEI

NUEVAFILAI
    CMP.B #0,(A1)
    BNE BUCLEI
    RTS


************SUB BORRAMAPA
BORRAMAPA
    MOVE.B #11,D0
    MOVE.W #$FF00,D1
    TRAP #15
    CLR D0
    CLR D1
    RTS
 
************SUB PINTAMAPA
PINTAMAPA
    MOVEM.L A1/D0-D2,-(A7)
    MOVE.L #MAPA1,A1
    MOVE.L #ORIX,D1
    MOVE.L #ORIY,D2     *X e Y en D1 y D2
    JSR BLANCO
BUCLE  
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILA
    CMP.B #'#',D0
    BNE NOMURO
    JSR GRIS
    JSR PINTAMURO
NOMURO  
    CMP.B #'@',D0
    BNE NOPERS
    JSR AMARILLO
    JSR PINTAMOZO
NOPERS
    CMP.B #'.',D0
    BNE NOOBJ
    JSR VERDE
    JSR PINTAOBJ
NOOBJ
    CMP.B #'$',D0
    BNE NOCAJA
    JSR MARRONCLARO
    JSR PINTACAJA
NOCAJA
    CMP.B #'%',D0
    BNE NOCAJAFIJA
    JSR MARRONOSCURO
    JSR PINTACAJA
NOCAJAFIJA
    CMP.B #'+',D0
    BNE NOPERSOBJ
    JSR AMARILLOVERDOSO
    JSR PINTAMOZO
NOPERSOBJ
    ADD.L #SIZE,D1  *Avanzamos coordenada X
    JMP BUCLE
       
NUEVAFILA
   
    ADD.L #SIZE,D2  *Avanzo coordenada Y (nueva fila)
    MOVE.L #ORIX,D1 *Repongo coordenada X inicial
   
    CMP.B #0,(A1)
    BNE BUCLE
    MOVEM.L (A7)+,A1/D0-D2
    RTS
 
*************SUB PINTAMURO
PINTAMURO  *Pinta un cuadrado de muro en X,Y indicado por D1 y D2
    MOVEM.L D0-D4,-(A7)
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #SIZE,D3
    ADD.L #SIZE,D4
    MOVE.L #87,D0   *cuadrado
    TRAP #15
    ADD.L #SIZE/3,D1
    MOVE.L D1,D3
    MOVE.L #84,D0   *lineas cruzadas
    TRAP #15
    ADD.L #SIZE/3,D1
    MOVE.L D1,D3
    TRAP #15
    ADD.L #SIZE/3,D1
    MOVE.L D1,D3
    SUB.L #SIZE,D1
    ADD.L #SIZE/3,D2
    MOVE.L D2,D4
    TRAP #15
    ADD.L #SIZE/3,D2
    MOVE.L D2,D4
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    RTS
   
***********SUB PINTAMOZO
PINTAMOZO
    MOVEM.L D0-D4,-(A7)
    ADD.L #SIZE/4,D1         *mitad tama�o que el muro
    ADD.L #SIZE/4,D2         *quitamos 1/4 de cada lado
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #SIZE/2,D3
    ADD.L #SIZE/2,D4
    MOVE.L #88,D0            *c�rculo
    TRAP #15
    ADD.L #SIZE/6,D1         *ojos
    ADD.L #SIZE/6,D2
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #2,D3
    ADD.L #2,D4
    TRAP #15
    ADD.L #SIZE/6,D1
    ADD.L #SIZE/6,D3
    TRAP #15
    SUB.L #SIZE/6,D1         *boca
    MOVE.L D1,D3
    ADD.L #SIZE/5,D3
    ADD.L #SIZE/6,D2
    MOVE.L D2,D4
    MOVE.L #84,D0
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    RTS
   
***********SUB PINTACAJA
PINTACAJA
    MOVEM.L D0-D4,-(A7)
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #SIZE,D3
    ADD.L #SIZE,D4
    MOVE.L #87,D0            *rect�ngulo
    TRAP #15
    ADD.L #SIZE/8,D1
    ADD.L #SIZE/8,D2
    SUB.L #SIZE/8,D3
    SUB.L #SIZE/8,D4
    MOVE.L #90,D0            *rect�ngulo
    TRAP #15
    ADD.L #SIZE/8,D1
    SUB.L #SIZE/8,D4
    MOVE.L #84,D0
    TRAP #15
    SUB.L #SIZE/8,D1
    ADD.L #SIZE/8,D4
    ADD.L #SIZE/8,D2
    SUB.L #SIZE/8,D3
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    RTS
    
***********SUB PINTAOBJ    
PINTAOBJ
    MOVEM.L D0-D4,-(A7)
    ADD.L #SIZE/3,D1         
    ADD.L #SIZE/3,D2         
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #SIZE/3,D3
    ADD.L #SIZE/3,D4
    MOVE.L #88,D0            *c�rculo
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    RTS

***********SUB SHOWTIME    
SHOWTIME    
    JSR BLANCO
    LEA TIME,A1
    MOVE.B #11,D0
    MOVE.W #0505,D1
    TRAP #15
    MOVE.B #17,D0
    MOVE.L D7,D1
    TRAP #15
    RTS

**********SUBS COLORES    
GRIS
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #DRKGRAY,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
   
AMARILLO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #YELLOW,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
VERDE
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #GREEN,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
MARRONCLARO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #LIGHTBROWN,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
NEGRO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVE.L #80,D0
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
BLANCO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #WHITE,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
MARRONOSCURO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #DRKBROWN,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
AMARILLOVERDOSO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #GREENISHYELLOW,D1
    TRAP #15
    MOVE.L #80,D0
    MOVE.L #BLACK,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
   
************    
 
* Put variables and constants here
    ORG $4000

MAPA1   DC.B '###### ',0  *# BORDE
        DC.B '#@   ##',0  *@ PERSONAJE
        DC.B '# $$  #',0  *$ CAJAS
        DC.B '# #. .#',0  *. DESTINO
        DC.B '#     #',0  *% CAJA INAMOVIBLE
        DC.B '#######',0,0
        
TIME    DC.L 'TIEMPO DE JUEGO: ',0

FINAL   DC.L 'ENHORABUENA HAS GANADO EL JUEGO Y TU TIEMPO EN COMPLETARLO HA SIDO: ',0
 
    END    START





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
