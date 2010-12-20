org 100h

start:
  call setupDraw
  call fileOpenForWriting
  jmp keyDrawLoop
  

fileOpenForWriting:
  push ax     ; we preserve the original register values
  push bx
  push cx
  push dx
  
  mov dx,FileName        ; filename in dx 
  xor cx,cx              ; clear cx - make ordinary file
  mov ah,3Ch             ; function 3Ch - create a file
  int 21h                ; DOS interruption
  jc createFileError     ; if the CFlag is on
  
  mov dx, FileName       ;
  mov al,2               ; read & write
  mov ah,3Dh             ; openFile
  int 21h
  jc openFileError
  
  mov [FileHandle], ax   ; copy the handle from ax to FileHandle
  
  pop dx                 ; restoring all register to previous conditions
  pop cx
  pop bx
  pop ax
  
  ret
  ;mov ah, 3Dh ; function to manage files
  ;mov al, 21h ; mode 100001
              ; 100 don't lock
              ; 001 write mode  
              
setupDraw:
  mov ax,13   ; mode = 13h 
  int 10h     ; call bios service
  mov cx,160  ; x position = 160
  mov dx,100  ; y position = 100
  ret
  
keyDrawLoop:
  push ax     ; preserving al's value
  xor ah,ah   
  int 16h     ; getting a key press value on ax
  pop bx      ; popping previous ax's value on bx's
  mov al, bl  ; moving bx's first 8bits (colour), back onto al
              ; that overwrites al's ascii value so we use scancodes
              ; to access the value of the key pressed
              
  cmp ah,1    ; if key == esc
  je  finishDraw
  cmp ah,13h  ; scancode for r
  je  setColourRedKey
  cmp ah,22h  ; scancode for g
  je  setColourGreenKey
  cmp ah,30h  ; scancode for b
  je  setColourBlueKey
  ;cmp ah,1Ch  ; enter key
  ;je  next_generation
  ;cmp ah,39h  ; spacebar
  ;je  switch_cell
  jmp drawKeys
  
drawKeys:  
  cmp ah,4Bh  ; if left keyk
  je  drawKeyLeft
  cmp ah,4Dh  ; if right key
  je  drawKeyRight
  cmp ah,48h  ; if up key
  je  drawKeyUp
  cmp ah,50h  ; if down key
  je  drawKeyDown
  jmp keyDrawLoop ;else, do the same again



setColourRedKey:
  call setColourRed
  jmp drawKeys

setColourBlueKey:
  call setColourBlue
  jmp drawKeys

setColourGreenKey:
  call setColourGreen
  jmp drawKeys

setColourRed:
  mov al,4
  ret

setColourBlue:
  mov al,1
  ret
  
setColourGreen:
  mov al,10
  ret
  
; ============ Specific Calls for Drawing with each Key

drawKeyUp:
  call drawUp
  jmp keyDrawLoop

drawKeyLeft:
  call drawLeft
  jmp keyDrawLoop
  
drawKeyDown:
  call drawDown
  jmp keyDrawLoop
  
drawKeyRight:
  call drawRight
  jmp keyDrawLoop

; ============ Specific Draw Functions
; all functions receive
;
; al register: colour
; cx register: xpos
; dx register: ypos

drawUp:
  push ax     ; preserve the original value of ah
  mov ah,0Ch  ; function 0Ch
  dec dx      ; increment "y" position
  int 10h     ; call interruption and draw
  pop ax      ; restore ah's original value
  ret

drawDown:
  push ax
  mov ah,0Ch 
  inc dx 
  int 10h 
  pop ax
  ret

drawLeft:
  push ax
  mov ah,0Ch 
  dec cx 
  int 10h 
  pop ax
  ret

drawRight:
  push ax
  mov ah,0Ch
  inc cx
  int 10h
  pop ax
  ret
  
createFileError: ; if there's an error creating the file
  mov dx, CreateErrorMessage
  mov ah,09h 
  int 21h 
  jmp exitError

openFileError:  ; error opening file
  mov dx, OpenErrorMessage
  mov ah,09h 
  int 21h 
  jmp exitError
  
exitError:
  mov ax,4C01h 
  int 21h

finishDraw:
  ;xor ax,ax   ; function 00h: readkey
  ;int 16h
  mov ax,3    ; mode = 3
  int 10h     ; change graphic mode
  jmp exitProgram

exitProgram:
  mov ax,4C00h    ; exit to DOS
  int 21h

CR equ 13
LF equ 10

CreateErrorMessage DB "Error While Creating File $"
OpenErrorMessage   DB "Error While Opening File $"

FileName     DB "C:\draw.txt",0 ; name of file to open 
FileHandle   DW 0               ; to store file handle 

RtoWrite     DB "r",0
GtoWrite     DB "g",0
BtoWrite     DB "b",0
UpToWrite    DB "1",0
RightToWrite DB "2",0
DownToWrite  DB "3",0
LeftToWrite  DB "4",0