*-------------------------------------------------------------------------
*
*       Setup the port registers to read joysticks.
*
*-------------------------------------------------------------------------

port_setup:
                moveq       #0x0040,d0
                move.b      d0,0x00a10009
                move.b      d0,0x00a1000b
                move.b      d0,0x00a1000d
                rts

*-------------------------------------------------------------------------
*
*       Check for input from Joypad 1.
*
*       Input:
*               None
*       Output:
*               Status of Joypad 1
*       Registers used:
*               d0, d1
*
*-------------------------------------------------------------------------

porta:
                moveq       #0,d0
                move.b      #0x0040,0x00a10003
                nop
                nop
                move.b      0x00a10003,d1
                andi.b      #0x003f,d1
                move.b      #0,0x00a10003
                nop
                nop
                move.b      0x00a10003,d0
                andi.b      #0x0030,d0
                lsl.b       #2,d0
                or.b        d1,d0
                not.b       d0
                rts
