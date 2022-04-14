assume cs:code,ds:data,ss:stack
data segment

	db  256 dup(0)

data ends

stack segment
	db		128 dup(0)
stack ends
code segment
	start:	mov ax,stack
			mov ss,ax
			mov sp,128

			call cpy_boot
		
		
			mov bx,0
			push bx
			mov bx,7E00H
			push bx
			retf


			mov ax,4C00H
			int 21H
;======================0:7E00H====================================
boot:	jmp  boot_start
;*************************data******************************
OPTION_1    db   '1)  restart PC',0
OPTION_2    db   '2)  start system',0
OPTION_3    db   '3)  show clock',0
OPTION_4    db   '4)  set clock',0

ADDRESS_OPTION		dw 	offset OPTION_1-offset boot+7E00H
					dw offset  OPTION_2-offset boot+7E00H
					dw offset  OPTION_3-offset boot+7E00H
					dw offset  OPTION_4-offset boot+7E00H
TIME_COMS			db 9,8,7,4,2,0
TIME_STYLE			db 'YY/MM/DD HH:MM:SS',0
;*************************data******************************
boot_start:
			call init_reg
			call clear_screen
			call show_option
			
			call choose_option
			mov ax ,4C00H
			int 21H
;=======================================
init_reg:	mov bx,0;0:7E00H
			mov ds,bx

			mov bx,0B800H
			mov es,bx

			ret			
clear_screen:
			mov dx,0700H
			mov cx,2000
			mov bx,0

clearScreen:mov es:[bx],dx
			add bx,2
			loop clearScreen		
			ret
show_option:
			mov bx,offset ADDRESS_OPTION-offset boot+7E00H
			mov di,160*10+70
			mov cx,4

showOption:	mov si,ds:[bx]
			call show_string
			add bx,2
			add di,160
			loop showOption
			ret
show_string:
			push dx
			push ds
			push es
			push si
			push di 
showString:	mov dl,ds:[si]
			cmp dl,0
			je showStringRet
			mov es:[di],dl
			inc si
			add di,2
			jmp showString
showStringRet:pop di
			  pop si
			  pop es
			  pop ds
			  pop dx
			  ret
choose_option:call clear_buff
			  mov ah,0;16H的0号 功能
			  int 16H

			  cmp al,'1'
			  je isChooseOne
			  cmp al,'2'
			  je isChooseTwo
			  cmp al,'3'
			  je isCHooseThree
			  cmp al,'4'
			  je isChooseFour

			  jmp choose_option;循环界面
isChooseOne:
			mov di,160*3
			mov byte ptr es:[di],'1'
			jmp choose_option
isChooseTwo:
			mov di,160*3
			mov byte ptr es:[di],'2'
			jmp choose_option
isCHooseThree:
			mov di,160*3
			mov byte ptr es:[di],'3'
			call show_clock
			JMP choose_option
isChooseFour:
			mov di,160*3
			mov byte ptr es:[di],'4'
			JMP choose_option

clear_buff:
			mov ah,1
			int 16H
			jz clearBuffRet
			mov ah,0
			int 16H
			jmp clear_buff
clearBuffRet:ret

;=========================3show clock===========
show_clock:call show_style
		   mov bx,offset TIME_COMS-offset boot+7E00H

showTime: mov si,bx
		   mov di,160*20
		   mov cx,6

showData:  mov al,ds:[si]
		   out 70H,al
		   in al,71H

		   mov ah,al
		   shr ah,1
		   shr ah,1
		   shr ah,1
		   shr ah,1

		   and al,00001111B

		   add ah,30H
		   add al,30H

		   mov es:[di],ah
		   mov es:[di+2],al
		   inc si
		   add di,6
		   loop showData
		   jmp showTime
	
		ret
show_style:
		   mov si,offset TIME_STYLE-offset boot+7E00H
		   mov di,160*20

		   call show_string
		   ret		

;=========================3show clock===========
boot_ends:nop
;======================0:7E00H====================================
cpy_boot:
		mov bx,cs
		mov ds,bx
		mov si,offset boot

		mov bx,0
		mov es,bx
		mov di,7E00H

		mov cx,offset boot_ends	- offset boot
		cld
		rep movsb

		ret

code ends


end start