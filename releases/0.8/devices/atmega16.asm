.nolist
.include "m16def.inc"
.list

  ; first address of RAM 
  .equ ramstart = $60
  .equ stackstart = RAMEND - $80
  .equ PADSIZE  = $10 ; 16 bit cellsize with binary representation
  .equ TIBSIZE  = $64 ; 80 characters is one line...
  .equ CELLSIZE = 2   ;
  .equ UPSIZE   = 16  ; size of user area (at least 16 bytes)

  .set PAGEMASK =  ~ ( PAGESIZE - 1 )
  .equ nrww = $1c00
  .equ codestart = $2a
  
  .equ RWWSRE = ASRE
  