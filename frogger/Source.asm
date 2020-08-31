.486
.model flat, stdcall
option casemap :none


include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\msvcrt.inc
includelib msvcrt.lib

include drd.inc
includelib drd.lib

;sound
includelib \masm32\lib\winmm.lib
include \masm32\include\winmm.inc


.const

FROG_VELOCITY_X equ 40
FROG_VELOCITY_Y equ 40
WINDOW_WIDTH equ 800
WINDOW_HEIGHT equ 600
LABEL_HEIGHT equ 40
BLUE_CAR_WIDTH equ 120
RED_CAR_WIDTH equ 120
MAX_WIDTH equ 40
MAX_HEIGHT equ 40
SNAKE_HEIGHT equ 40
SNAKE_WIDTH equ 160
FRONT_BLUE_CAR equ 40
RCAR_WIDTH equ 80
HALF_RED_CAR_WIDTH equ 40
WOOD_WIDTH equ 160
ADDITIONAL_SPACE equ 300
ANOTHER_ADDITIONAL_SPACE equ 170
WATER_START_X equ 0
WATER_START_Y1 equ 80
WATER_START_Y2 equ 120
WATER_START_Y3 equ 160
WATER_START_Y4 equ 200
WATER_START_Y5 equ 240
LEAF_WIDTH equ 40
LEAF_START_Y equ 190
LEAF_START_X1 equ 670
LEAF_START_X2 equ 550
LEAF_START_X3 equ 430
LEAF_START_X4 equ 310
LEAF_START_X5 equ 190
LEAF_START_X6 equ 70
FLY_START_X1 equ 120
FLY_START_X2 equ 320
FLY_START_X3 equ 540
FLY_START_X4 equ 720
FLY_WIDTH equ 80
FLY_START_Y equ 40
.data

a DWORD 0
b DWORD 0
e DWORD 0
f DWORD 0
h DWORD 0
i DWORD 0
a1 DWORD 0
b1 DWORD 0
a2 DWORD 0
b2 DWORD 0
ko DWORD 0
ok DWORD 0
ab DWORD 0
wiinero DWORD 0
woodcounter DWORD 0
woodcounter2 DWORD 0
woodcounter5 DWORD 0
woodcounter6 DWORD 0
slowtime DWORD 0
slowtime2 DWORD 0
slowtime3 DWORD 0
slowtime4 DWORD 0
slowtime5 DWORD 0
slowtime6 DWORD 0
slowtime8 DWORD 0
slowtime9 DWORD 0

loser DWORD 0
checksnake DWORD 0
multip_x DWORD 0
multip_y DWORD 0
multip_width DWORD 0


frog_x DWORD WINDOW_WIDTH/2 - FROG_VELOCITY_X
frog_y DWORD WINDOW_HEIGHT - FROG_VELOCITY_Y
snake_x DWORD WINDOW_WIDTH - SNAKE_WIDTH
snake_y DWORD WINDOW_HEIGHT - 2*LABEL_HEIGHT
max_x DWORD 200 ; RANDOM LOCATION
max_y DWORD WINDOW_HEIGHT - 8*LABEL_HEIGHT
bcar1_x DWORD WINDOW_WIDTH - BLUE_CAR_WIDTH
bcar1_y DWORD WINDOW_HEIGHT - 6*LABEL_HEIGHT
bcar2_x DWORD WINDOW_WIDTH - 4* BLUE_CAR_WIDTH
bcar2_y DWORD WINDOW_HEIGHT- 4*LABEL_HEIGHT
rcar_x DWORD RCAR_WIDTH
rcar_y DWORD WINDOW_HEIGHT-5*LABEL_HEIGHT
wood1_x DWORD WINDOW_WIDTH - WOOD_WIDTH
wood1_y DWORD WINDOW_HEIGHT - 9*LABEL_HEIGHT
wood2_x DWORD WINDOW_WIDTH - WOOD_WIDTH - ADDITIONAL_SPACE
wood2_y DWORD WINDOW_HEIGHT-9*LABEL_HEIGHT
wood3_x DWORD WINDOW_WIDTH - WOOD_WIDTH
wood3_y DWORD WINDOW_HEIGHT - 10*LABEL_HEIGHT
wood4_x DWORD WINDOW_WIDTH - WOOD_WIDTH - ADDITIONAL_SPACE
wood4_y DWORD WINDOW_HEIGHT - 12*LABEL_HEIGHT
wood5_x DWORD WINDOW_WIDTH - WOOD_WIDTH - ANOTHER_ADDITIONAL_SPACE
wood5_y DWORD WINDOW_HEIGHT - 13*LABEL_HEIGHT
wood6_x DWORD WINDOW_WIDTH - WOOD_WIDTH - ADDITIONAL_SPACE - ANOTHER_ADDITIONAL_SPACE
wood6_y DWORD WINDOW_HEIGHT - 13*LABEL_HEIGHT

blr BYTE 0

bll BYTE 0

blu BYTE 0

bld BYTE 0

ble BYTE 0



arr DB 20*15 dup (0)

amap BYTE "map.bmp",0
map Img<0,0,0,0>

afrog BYTE "frog.bmp",0   ;   46x32
frog Img<0,0,0,0>

asnake BYTE "snake.bmp",0
snake Img<0,0,0,0>

amax BYTE "baymax.bmp",0
max Img<0,0,0,0>

blcar BYTE "bluecar.bmp"
bcar Img<0,0,0,0>

hbcar BYTE "blueback.bmp"
hcar Img<0,0,0,0>

fhbcar BYTE "bluefront.bmp",0
fbcar Img<0,0,0,0>

recar BYTE "redcar.bmp",0
rcar Img<0,0,0,0>

hlrcar BYTE "halfredcar.bmp",0
hrcar Img<0,0,0,0>

frrcar BYTE "frontredcar.bmp",0
frcar Img<0,0,0,0>

awinner BYTE "winner.bmp",0
winner Img<0,0,0,0>

awood1 BYTE "wood.bmp",0
wood1 Img<0,0,0,0>

alose BYTE "lose.bmp",0
lose Img<0,0,0,0>

ablack BYTE "black.bmp",0
black Img<0,0,0,0>



Soundfile db "Crazy_Frog_-_Axel_F.wav",0

.code

 Movement PROC
 pusha

 keys:
   invoke GetAsyncKeyState, VK_RIGHT
   cmp eax, 0
   jne right
   mov blr,FALSE
   invoke GetAsyncKeyState, VK_LEFT
   cmp eax, 0
   jne left
   mov bll , FALSE
   invoke GetAsyncKeyState, VK_UP
   cmp eax, 0
   jne up
   mov blu,FALSE
   invoke GetAsyncKeyState, VK_DOWN
   cmp eax, 0
   jne down
   mov bld , FALSE
  jmp nothing

 right:
  cmp blr ,TRUE
  je nothing
  cmp frog_x , WINDOW_WIDTH-FROG_VELOCITY_X
  je nothing
  add frog_x, FROG_VELOCITY_X
  mov blr,TRUE

  popa
  ret
left:
  cmp bll,TRUE
  je  nothing
  cmp frog_x , 0
  je  nothing
  sub frog_x , FROG_VELOCITY_X
  mov bll,TRUE
 popa
 ret
up:
  cmp blu,TRUE
  je nothing
  cmp frog_y ,0
  je nothing

   sub frog_y , FROG_VELOCITY_Y
  mov blu, TRUE
  popa
   ret
down:
  cmp bld , TRUE
  je nothing
  cmp frog_y , WINDOW_HEIGHT - FROG_VELOCITY_Y
  je nothing
  add frog_y , FROG_VELOCITY_Y
  mov bld , TRUE
  popa
 ret

 checky:
 cmp frog_y ,LABEL_HEIGHT*2
 je nothing
 popa
 ret

 nothing:
 popa
 ret


 Movement ENDP

  movewood3 PROC

 cmp slowtime3 , 2
 jne nothing
 mov eax , h
 mov ebx , i
 mov slowtime3 ,0
 cmp eax , ebx
 je switch1
 jne switch2

 switch1:
 dec wood3_x
 cmp wood3_x , 0
 je inca
 ret
 inca:
 inc h
 ret

 switch2:
 inc wood3_x
 cmp wood3_x , WINDOW_WIDTH - WOOD_WIDTH
 je incb
 ret
 incb:
 inc i
  ret

  nothing:
  inc slowtime3
  ret

 movewood3 ENDP

 movewood4 PROC

 cmp slowtime4 , 3
 jne nothing
 mov slowtime4 , 0
 mov eax , e
 mov ebx , f
 cmp eax , ebx
 je switch1
 jne switch2

 switch1:
 dec wood4_x
 cmp wood4_x, 0
 je inca
 ret
 inca:
 inc e
 ret

 switch2:
 inc wood4_x
 cmp wood4_x , WINDOW_WIDTH - WOOD_WIDTH
 je incb
 ret
 incb:
 inc f
  ret

 nothing:
 inc slowtime4
 ret

 movewood4 ENDP

 movesnakes PROC

 mov eax , a
 mov ebx , b
 cmp eax , ebx
 je switch1
 jne switch2

 switch1:       ; moves to the left
 dec snake_x
 cmp snake_x , 0
 je inca
 ret
 inca:
 inc a
 ret

 switch2:       ; moves to the right
 inc snake_x
 cmp snake_x , WINDOW_WIDTH - SNAKE_WIDTH
 je incb
 ret
 incb:
 inc b
  ret

 movesnakes ENDP

 bluecar1move PROC

 cmp ko,2
 je move
 jne notmove
 move:
 mov bcar1_x , 700
 mov ko,0
 ret
notmove:
 dec bcar1_x
 cmp bcar1_x , 2
 je drawhalfcar
 jne return
 drawhalfcar:
 mov ko,2
 ret
return:
 ret

 bluecar1move ENDP

  bluecar2move PROC

 cmp ok,2
 je move
 jne notmove
 move:
 mov bcar2_x , WINDOW_WIDTH-BLUE_CAR_WIDTH
 mov ok,0
 ret
notmove:
 dec bcar2_x
 cmp bcar2_x , 2
 je drawhalfcar
 jne return
 drawhalfcar:
 mov ok,2

 ret
return:
 ret

 bluecar2move ENDP

  wood2move PROC
  cmp slowtime, 5
  jne return
cmp woodcounter2,2
 je move
 jne notmove
 move:
 mov slowtime,0
 mov wood2_x , WINDOW_WIDTH-WOOD_WIDTH
 mov woodcounter2,0
 ret
notmove:
 mov slowtime,0
 dec wood2_x
 cmp wood2_x , 0
 je move
return:
inc slowtime
 ret

 wood2move ENDP

  wood1move PROC

  cmp slowtime, 5
  jne return
 cmp woodcounter,2
 je move
 jne notmove
 move:
 mov slowtime,0
 mov wood1_x , WINDOW_WIDTH-WOOD_WIDTH
 mov woodcounter,0
 ret
notmove:
mov slowtime,0
dec wood1_x
cmp wood1_x ,0
je move
return:
inc slowtime
 ret

 wood1move ENDP

 wood5move PROC

 cmp slowtime5, 5
 jne return
 cmp woodcounter5, 2
 je move
 jne notmove
 move:
 mov slowtime5,0
 mov wood5_x , WINDOW_WIDTH-WOOD_WIDTH
 mov woodcounter5,0
 ret
notmove:
mov slowtime5,0
dec wood5_x
cmp wood5_x , 0
je move
return:
inc slowtime5
   ret

 wood5move ENDP

 wood6move PROC

 cmp slowtime6, 5
 jne return
 cmp woodcounter6, 2
 je move
 jne notmove
 move:
 mov slowtime6,0
 mov wood6_x , WINDOW_WIDTH-WOOD_WIDTH
 mov woodcounter6,0
 ret
notmove:
mov slowtime6,0
dec wood6_x
cmp wood6_x , 0
je move
return:
inc slowtime6
   ret

 wood6move ENDP

 redcarmove PROC

 cmp ab,2
 je move
 jne notmove
 move:
 sub rcar_x , WINDOW_WIDTH-BLUE_CAR_WIDTH
 mov ab,0
 ret
notmove:
 inc rcar_x
 cmp rcar_x , WINDOW_WIDTH-BLUE_CAR_WIDTH
 je drawhalfcar
 jne return
 drawhalfcar:
 mov ab,2
 ret
return:
 ret

 redcarmove ENDP

  maxmove1 PROC

 mov ecx , a1
 mov edx , b1
 cmp ecx , edx
 je switch1
 jne switch2

 switch1:
 dec max_x
 cmp max_x, 0
 je inca1
 ret
 inca1:
 inc a1
 ret


 switch2:
 inc max_x
 cmp max_x , WINDOW_WIDTH-MAX_WIDTH
 je incb1
 ret
 incb1:
 inc b1
  ret

 maxmove1 ENDP

frogonwood12 PROC

check1:
mov eax , frog_y
mov ebx , wood1_y
cmp eax , ebx
je star1x
jne check2

star1x:
mov ecx , wood1_x
add ecx , 40
mov eax , frog_x
cmp eax , ecx
je move1
jne check2

move1:
mov eax, wood1_x
mov frog_x , eax
ret

check2:
mov eax , frog_y
mov ebx , wood2_y
cmp eax , ebx
je star2x
jne nothing

star2x:
mov ecx , wood2_x
add ecx , 40
mov eax , frog_x
cmp eax , ecx
je move2
jne nothing

move2:
mov eax, wood2_x
mov frog_x , eax
ret


nothing:
ret

frogonwood12 ENDP

getioio PROC , x:DWORD , y:DWORD

cmp x , 20
jge nothing
cmp y,15
jge nothing
xor edx , edx
mov eax , 20
mul y
add eax , x
add eax, offset arr
mov ebx , eax
mov al , byte ptr [ebx]
  ret

  nothing:
  mov eax , 9999
  ret

getioio ENDP

setioio PROC , x:DWORD , y:DWORD , value: BYTE

cmp x,20
jnb nothing
cmp y,15
jnb nothing
xor edx , edx
mov eax , 20
mul y
add eax , x
add eax, offset arr
mov ebx , eax
mov al, value
mov [ebx] , al
mov eax , 1
  ret

nothing:
  mov eax , 9999
  ret

setioio ENDP

clean PROC

mov ebx, offset arr
mov ecx , 15*20
loopa:
mov byte ptr [ebx], 0
inc ebx
loop loopa
ret

clean ENDP


fill PROC , x:DWORD , y:DWORD , value: BYTE , len: DWORD
mov ecx , len
mov ebx , x
loopb:
pusha
invoke setioio , ebx , y , value
popa
inc ebx
loop loopb
ret

fill ENDP


 loose PROC
 mov eax, frog_x
 mov ecx,40
 mov edx,0
 div ecx
 mov edi, eax
 mov eax, frog_y
 mov edx,0
 div ecx
 invoke getioio, edi , eax
 cmp al, 1
 jne didntlose
 mov loser, 5
 mov frog_x, WINDOW_WIDTH/2 - FROG_VELOCITY_X
 mov frog_y, WINDOW_HEIGHT - FROG_VELOCITY_Y
didntlose:
 ret
loose ENDP

 wiiner PROC

 mov eax, frog_x
 mov ecx,40
 mov edx,0
 div ecx
 mov edi, eax
 mov eax, frog_y
 mov edx,0
 div ecx
 invoke getioio , edi , eax
 cmp al, 2
 je iswiiner
   ret
  iswiiner:
  mov wiinero, 3
 ret

wiiner ENDP

frogonwood34 PROC

 check3:
 mov eax , frog_x
 sub eax , 40
 mov ebx , wood3_x
 cmp eax , ebx
 je checky3
 jne check4

 checky3:
 mov eax , frog_y
 mov ebx , wood3_y
 cmp eax , ebx
 je onwood3
 jne check4



 onwood3:

 mov eax , h
 mov ebx , i
 cmp eax , ebx
 je left3
 jne right3


 left3:
 mov eax , wood3_x
 mov frog_x , eax
 ret

 right3:
 add frog_x , 40
 ret


 check4:
 mov eax , frog_x
 sub eax , 40
 mov ebx , wood4_x
 cmp eax , ebx
 je checky4
 jne nothing

 checky4:
 mov eax , frog_y
 mov ebx , wood4_y
 cmp eax , ebx
 je onwood4
 jne nothing



 onwood4:

 mov eax , e
 mov ebx , f
 cmp eax , ebx
 je left4
 jne right4


 left4:
 mov eax , wood4_x
 mov frog_x , eax
 ret

 right4:
 add frog_x , 40
 ret




nothing:
ret

frogonwood34 ENDP

frogonwood56 PROC

check5:
mov eax , frog_y
mov ebx , wood5_y
cmp eax , ebx
je star5x
jne check6

star5x:
mov ecx , wood5_x
add ecx , 40
mov eax , frog_x
cmp eax , ecx
je move5
jne check6

move5:
mov eax, wood5_x
mov frog_x , eax
ret

check6:
mov eax , frog_y
mov ebx , wood6_y
cmp eax , ebx
je star6x
jne nothing

star6x:
mov ecx , wood6_x
add ecx , 40
mov eax , frog_x
cmp eax , ecx
je move6
jne nothing

move6:
mov eax, wood6_x
mov frog_x , eax
ret


nothing:
ret


frogonwood56 ENDP


  multip PROC , x: DWORD , y: DWORD , awidth: DWORD

  mov edx,0
  mov edi, 40
  mov eax,x
  div edi
  mov multip_x , eax
  mov eax,y
  mov edi, 40
  mov edx,0
  div edi
  mov multip_y,eax
  mov edx,0
  mov edi, 40
  mov eax , awidth
  div edi
  mov multip_width, eax


  ret
  multip ENDP


main PROC

 invoke drd_init, WINDOW_WIDTH, WINDOW_HEIGHT, INIT_WINDOW
 invoke PlaySound,addr Soundfile,NULL,SND_ASYNC
 invoke drd_imageLoadFile, offset amap, offset map
 invoke drd_imageLoadFile, offset afrog , offset frog
 invoke drd_imageSetTransparent, offset frog, 0FFFFFFh
 invoke drd_imageLoadFile, offset asnake , offset snake
 invoke drd_imageLoadFile, offset amax , offset max
 invoke drd_imageLoadFile, offset blcar , offset bcar
 invoke drd_imageLoadFile, offset hbcar , offset hcar
 invoke drd_imageLoadFile, offset fhbcar , offset fbcar
 invoke drd_imageLoadFile, offset recar , offset rcar
 invoke drd_imageLoadFile, offset hlrcar , offset hrcar
 invoke drd_imageLoadFile, offset frrcar , offset frcar
 invoke drd_imageLoadFile, offset awood1 , offset wood1
 invoke drd_imageLoadFile, offset alose , offset lose
 invoke drd_imageLoadFile, offset ablack , offset black
 invoke drd_imageLoadFile, offset awinner , offset winner

again:
 ; invoke Sleep,100
  invoke clean
;  __________________________________________________________________
  fillwater:
  invoke multip , WATER_START_X , WATER_START_Y1 ,  WINDOW_WIDTH
  invoke fill , multip_x, multip_y, 1 ,multip_width
  invoke multip , WATER_START_X , WATER_START_Y2 ,  WINDOW_WIDTH
  invoke fill , multip_x, multip_y, 1 ,multip_width
  invoke multip , WATER_START_X , WATER_START_Y3 ,  WINDOW_WIDTH
  invoke fill , multip_x, multip_y, 1 ,multip_width
  invoke multip , WATER_START_X , WATER_START_Y4 ,  WINDOW_WIDTH
  invoke fill , multip_x, multip_y, 1 ,multip_width
  invoke multip , WATER_START_X , WATER_START_Y5 ,  WINDOW_WIDTH
  invoke fill , multip_x, multip_y, 1 ,multip_width
 ; ___________________________________________________________________
  leafs:
  invoke multip , LEAF_START_X1 , LEAF_START_Y , LEAF_WIDTH
  invoke fill , multip_x, multip_y, 0 ,multip_width
  invoke multip , LEAF_START_X2 , LEAF_START_Y ,  LEAF_WIDTH
  invoke fill , multip_x, multip_y, 0 ,multip_width
  invoke multip , LEAF_START_X3 , LEAF_START_Y ,  LEAF_WIDTH
  invoke fill , multip_x, multip_y, 0 ,multip_width
  invoke multip , LEAF_START_X4 , LEAF_START_Y ,  LEAF_WIDTH
  invoke fill , multip_x, multip_y, 0 ,multip_width
  invoke multip , LEAF_START_X5 , LEAF_START_Y ,  LEAF_WIDTH
  invoke fill , multip_x, multip_y, 0 ,multip_width
  invoke multip , LEAF_START_X6 , LEAF_START_Y ,  LEAF_WIDTH
  invoke fill , multip_x, multip_y, 0, multip_width
  ;  _______________________________________________________________________
   flys:
    invoke multip , FLY_START_X1 , FLY_START_Y , FLY_WIDTH
invoke fill , multip_x, multip_y, 2 ,multip_width
invoke multip , FLY_START_X2 , FLY_START_Y , FLY_WIDTH
invoke fill , multip_x, multip_y, 2 ,multip_width
invoke multip , FLY_START_X3 , FLY_START_Y , FLY_WIDTH
invoke fill , multip_x, multip_y, 2 ,multip_width
invoke multip , FLY_START_X4 , FLY_START_Y , FLY_WIDTH
invoke fill , multip_x, multip_y, 2 ,multip_width
  ;  _______________________________________________________________________


  invoke drd_imageDraw , offset map, 0,0                       ; (0 , 0)
  invoke drd_imageDraw , offset snake, snake_x, snake_y

  invoke multip , snake_x , snake_y , SNAKE_WIDTH
  invoke fill, multip_x , multip_y ,1 , multip_width

  invoke drd_imageDraw , offset max , max_x , max_y
  invoke multip , max_x , max_y , MAX_WIDTH
  invoke fill, multip_x , multip_y , 1 , multip_width

  invoke drd_imageDraw , offset wood1, wood1_x, wood1_y
  invoke multip , wood1_x , wood1_y  , WOOD_WIDTH
  invoke fill, multip_x , multip_y , 0 , 7
  invoke drd_imageDraw , offset wood1, wood2_x, wood2_y
  invoke multip , wood2_x , wood2_y  , WOOD_WIDTH
  invoke fill, multip_x , multip_y , 0 , 7
  invoke drd_imageDraw , offset wood1, wood3_x, wood3_y
  invoke multip , wood3_x , wood3_y  , WOOD_WIDTH
  invoke fill, multip_x , multip_y , 0 , 7
  invoke drd_imageDraw , offset wood1, wood4_x, wood4_y
  invoke multip , wood4_x , wood4_y  , WOOD_WIDTH
  invoke fill, multip_x , multip_y , 0 , 7
  invoke drd_imageDraw , offset wood1, wood5_x, wood5_y
  invoke multip , wood5_x , wood5_y  , WOOD_WIDTH
  invoke fill, multip_x , multip_y , 0 , 7
  invoke drd_imageDraw , offset wood1, wood6_x, wood6_y
  invoke multip , wood6_x , wood6_y  , WOOD_WIDTH
  invoke fill, multip_x , multip_y , 0 , 7
  invoke drd_imageDraw , offset frog, frog_x, frog_y
  invoke getioio, frog_x , frog_y
  cmp ko , 2
  je there
  cmp ok,2
  je there
  cmp ab,2
  je there
  invoke drd_imageDraw , offset bcar, bcar1_x, bcar1_y

  invoke multip , bcar1_x , bcar1_y , BLUE_CAR_WIDTH
  invoke fill, multip_x , multip_y ,1 , multip_width

  invoke drd_imageDraw , offset bcar, bcar2_x, bcar2_y

  invoke multip , bcar2_x , bcar2_y , BLUE_CAR_WIDTH
  invoke fill, multip_x , multip_y ,1 , multip_width


  invoke drd_imageDraw , offset rcar, rcar_x, rcar_y

  invoke multip , rcar_x , rcar_y , RED_CAR_WIDTH
  invoke fill, multip_x , multip_y ,1 , multip_width



there:
  cmp ble , 1
  jne there2
  mov frog_x , WINDOW_WIDTH/2 - FROG_VELOCITY_X
  mov frog_y , WINDOW_HEIGHT - FROG_VELOCITY_Y
  mov ble , 0
  there2:
  invoke Movement
  invoke movesnakes
  invoke maxmove1
  invoke bluecar1move
  invoke bluecar2move
  invoke wood1move
  invoke wood2move
  invoke movewood3
  invoke movewood4
  invoke wood5move
  invoke wood6move
  invoke redcarmove
  invoke frogonwood12
  invoke frogonwood34
  invoke frogonwood56
  invoke wiiner
  cmp wiinero ,3
  je youwin
  invoke loose
  cmp  loser , 5
  je screenout
  cmp ko,2
  je drawhalfblue
  jne here
  cmp ok,2
  je drawhalfblue
  jne here
  cmp ab,2
  je drawhalfred
  jne here
 drawhalfblue:
   invoke drd_imageDraw , offset hcar, 0, bcar1_y
   invoke drd_imageDraw , offset fbcar, WINDOW_WIDTH-FRONT_BLUE_CAR, bcar1_y
   invoke drd_processMessages
   invoke drd_flip
   jmp again
   drawhalfred:
   invoke drd_imageDraw , offset hrcar, WINDOW_WIDTH-HALF_RED_CAR_WIDTH , rcar_y
   invoke drd_imageDraw , offset frcar, 0, bcar1_y
   invoke drd_processMessages
   invoke drd_flip
   jmp again

 here:
  inc slowtime9
  invoke drd_processMessages
  invoke drd_flip
  jmp again



  youwin:
  invoke drd_imageDraw , offset black,0, 0
  invoke drd_imageDraw , offset winner ,100, 100
  invoke drd_processMessages
  invoke drd_flip
  jmp again


  screenout:

  invoke drd_imageDraw , offset black,0, 0
  invoke drd_imageDraw , offset lose, 300, 200
  invoke Sleep,100

  invoke drd_processMessages
  invoke drd_flip

  invoke Sleep,10
  mov loser , 0
  jmp again


  main ENDP

end main