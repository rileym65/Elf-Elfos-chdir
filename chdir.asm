.list
.sym

; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

include    ../bios.inc
include    ../kernel.inc
include    ../../ops.inc

           org     8000h
           lbr     0ff00h
           db      'chdir',0
           dw      9000h
           dw      endrom+7000h
           dw      2000h
           dw      endrom-2000h
           dw      2000h
           db      0

           org     2000h
           br      start

include    date.inc
include    build.inc
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

dta:       ds      512

