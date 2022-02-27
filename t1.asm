assume cs:code
;a块的值加b块的值 放入c中
a segment 
		db		1,2,3,4,5,6,7,8
a ends

b segment
        db		1,2,3,4,5,6,7,8
b ends	

c segment 
		db      0,0,0,0,0,0,0,0
c ends



;数据哪来ds数据寄存器  

;存放到那里去es数据寄存器
						
;start 将程序入口地址记录在exe文件的描述信息中，cpu对cs:ip这两个寄存器进行设置。     
code segment
start:		

;程序返回

			mov ax,a
			mov ds,ax

			mov ax,c
			mov es,ax

			mov bx,0
			mov cx,8

			mov dx,0
setNumber:	push ds
			mov dl,ds:[bx]

			mov ax,b
			mov ds,ax

			add dl,ds:[bx]
			mov es:[bx],dl
			inc bx
			pop ds
			loop setNumber

			mov ax,4C00H
			int 21H

code ends
end start 
end
