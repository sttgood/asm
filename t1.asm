assume cs:code
;将a段中的数据逆序放到d段中
a segment 
		dw		1,2,3,4,5,6,7,8,0AH,0BH,0CH,0DH,0EH,0FH,0FFH
a ends

b segment 
		dw		0,0,0,0,0,0,0,0
b ends

code segment

;设置数据寄存器
		mov ax,a
		mov ds,ax
;设置栈寄存器
		mov ax,b
		mov ss,ax
		mov sp,16
;设置中间参数，数据偏移，循环次数
		mov bx,0
		mov cx,8

pushData:push ds:[bx]
		add bx,2
		loop pushData
		

		mov ax,4C00H
		int 21H



code ends



end