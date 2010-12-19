org 100h

start:
  call setupDraw
  mov al,4    ; color 4 - red
  jmp drawLoop


setupDraw:
  mov ax,13   ; mode = 13h 
  int 10h     ; call bios service
  mov cx,160  ; x position = 160
  mov dx,100  ; y position = 100
  ret
  
drawLoop:
  xor ah,ah
  int 16h
  mov al,4    ; color 4 - red
  cmp ah,1    ; if key == esc
  je  finishDraw
  
  cmp ah,'r'
  je  setColourRed
  cmp ah,'g'
  je  setColourGreen
  cmp ah,'b'
  je  setColourBlue
  ;cmp ah,1Ch  ; enter key
  ;je  next_generation
  ;cmp ah,39h  ; spacebar
  ;je  switch_cell
  cmp ah,4Bh  ; if left key
  je  drawKeyLeft
  cmp ah,4Dh  ; if right key
  je  drawKeyRight
  cmp ah,48h  ; if up key
  je  drawKeyUp
  cmp ah,50h  ; if down key
  je  drawKeyDown
  jmp drawLoop ;else, do the same again
  
setColourRed:
  mov al,4
  jmp drawLoop

setColourBlue:
  mov al,1
  jmp drawLoop
  
setColourGreen:
  mov al,10
  jmp drawLoop
  
drawKeyUp:
  call drawUp
  jmp drawLoop

drawKeyLeft:
  call drawLeft
  jmp drawLoop
  
drawKeyDown:
  call drawDown
  jmp drawLoop
  
drawKeyRight:
  call drawRight
  jmp drawLoop

; ============ Setting Draw Functions
; all functions receive
;
; al register: colour
; cx register: xpos
; dx register: ypos

drawUp:
  ;push ax     ; preserve the original value of ah
  mov ah,0Ch  ; function 0Ch
  dec dx      ; increment "y" position
  int 10h     ; call interruption and draw
  ;pop ax      ; restore ah's original value
  ret

drawDown:
  ;push ax
  mov ah,0Ch 
  inc dx 
  int 10h 
  ;pop ax
  ret

drawLeft:
  ;push ax
  mov ah,0Ch 
  dec cx 
  int 10h 
  ;pop ax
  ret

drawRight:
  ;push ax
  mov ah,0Ch
  inc cx
  int 10h
  ;pop ax
  ret

finishDraw:
  ;xor ax,ax   ; function 00h: readkey
  ;int 16h
  
  mov ax,3    ; mode = 3
  int 10h     ; change graphic mode

  mov ax,4C00h    ; exit to DOS
  int 21h