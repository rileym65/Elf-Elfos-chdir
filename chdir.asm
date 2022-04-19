.list

; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

.op "PUSH","N","9$1 73 8$1 73"
.op "POP","N","60 72 A$1 F0 B$1"
.op "CALL","W","D4 H1 L1"
.op "RTN","","D5"
.op "MOV","NR","9$2 B$1 8$2 A$1"
.op "MOV","NW","F8 H2 B$1 F8 L2 A$1"

include    ../bios.inc
include    ../kernel.inc

           org     2000h
begin:     br      start
           eever
           db      'Written by Michael H. Riley',0

start:     ghi     ra                  ; copy argument address to rf
           phi     rf
           glo     ra
           plo     rf
           ldn     ra                  ; get first byte of args
           bz      view                ; view if no path
loop1:     lda     ra                  ; look for first less <= space
           smi     33
           bdf     loop1
           dec     ra                  ; backup to char
           ldi     0                   ; need proper termination
           str     ra
chdirgo:   mov     rd,fildes
           ldn     rf                  ; get first byte of pathname
           lbz     view                ; jump if going to view dir
           ldi     0                   ; flags for open
           call    o_chdir
           bnf     opened              ; jump if file was opened
           mov     rf,errmsg
           call    o_msg
           ldi     8                   ; indicate invalid directory
           sep     sret
opened:    ldi     0
           sep     sret                ; return to os
view:      mov     rf,dta
           ldi     0
           str     rf                  ; place terminator
           call    o_chdir
           mov     rf,dta
           call    o_msg
           mov     rf,crlf
           call    o_msg
           ldi     0
           sep     sret                ; return to caller

errmsg:    db      'Invalid Directory'
crlf:      db      10,13,0
fildes:    db      0,0,0,0
           dw      dta
           db      0,0
           db      0
           db      0,0,0,0
           dw      0,0
           db      0,0,0,0

endrom:    equ     $

.suppress

dta:       ds      512

           end     begin

