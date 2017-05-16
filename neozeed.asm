
        include sega.s

_main:
        include genesis.dat

***< Variables defining >

vtimer  equ $ff0000     ;long
swpal   equ vtimer+4    ;word
cpt     equ swpal+2     ;long

        move.w      #1,swpal
        move.l      #0,cpt

        move.w      sr,-(sp)            ; disable interrupt
        or.w        #$700,sr

*---< Init the GFX >

        lea         GFXCTRL,a0          ; GFX Control
        move        #$8016,(a0)         ; reg. 80, Enable Hor. Sync
        move        #$8174,(a0)         ; reg. 81, Enable Ver. Sync + Fast transfer
        move        #$8238,(a0)         ; reg. 82, A plane left half location = $E000
        move        #$8338,(a0)         ; reg. 83, A plane right half location = $E000
        move        #$8407,(a0)         ; reg. 84, B plane location = $E000
        move        #$8560,(a0)         ; reg. 85, Sprite data table $C000
        move        #$8600,(a0)         ; reg. 86, ?
        move        #$8700,(a0)         ; reg. 87, Background color #0
        move        #$8801,(a0)         ; reg. 88, ?
        move        #$8901,(a0)         ; reg. 89, ?
        move        #$8a01,(a0)         ; reg. 8a, 
        move        #$8b00,(a0)         ; reg. 8b, enabled interrupt 2
        move        #$8c00,(a0)         ; reg. 8c, 40 cells mode 
        move        #$8d2e,(a0)         ; reg. 8d,
        move        #$8f02,(a0)         ; reg. 8f, 
        move        #$9000,(a0)         ; reg. 90,
        move        #$9100,(a0)         ; reg. 91,
        move        #$92ff,(a0)         ; reg. 92,

        move.w      (sp)+,sr 

*---< Fill the  palette  >

        move.l     #$c0000000,GFXCTRL  
        move.w     #15,d0
        lea        pal,a0
loopp:  move.w     (a0)+,GFXDATA
        dbf        d0,loopp

*---< Load the tile >

        move.l     #$40000000,GFXCTRL
        move.w     #$1c00,d0               ; 32 * 28 tile * 8 long=1c000
        lea        start_pic,a0
loopt:  move.l     (a0)+,GFXDATA
        dbf        d0,loopt

*---< fill the tile map >

        move.l      #$60000003,GFXCTRL
        move.w      #0,d0                   ;counter : 32*28=896 tiles
        
loopm:
        move.w      d0,GFXDATA
        addq.w      #1,d0
        cmp.w       #896,d0
        bne         loopm

****< Main loop>

loop:
        move.l     cpt,d0
        cmp.l      #15,d0                ; 16 frames length for 1 color change
        ble        rien

        move.l     #$c0100000,GFXCTRL    ; write to Cram pos 9 pal 1
        cmp.w      #1,swpal
        bne        rr

        move.w     #$00e,GFXDATA         ; swap the palette entry
        move.w     #$eee,GFXDATA
        bra        bool 
        
rr:
        move.w     #$eee,GFXDATA         ; swap the palette entry
        move.w     #$00e,GFXDATA

bool:
        neg        swpal
        move.l     #0,cpt

rien:
        addi.l      #1,cpt


        clr.l       d0
        move.l      vtimer,d0
vloop   cmp.l       vtimer,d0
        beq         vloop

        bra loop

******************************************************************************

        include neo.pal
        include neo.s

        org $20000                  
