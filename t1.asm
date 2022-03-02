assume cs:code,ds:data,ss:stack
data segment

		db 128 dup (0)

data ends

stack segment
		db 128 dup (0)
stack ends


code segment
start:			mov ax,data
				mov ds ,ax

				mov ax,stack
				mov ss,ax
				mov sp,32

tests:			mov ax,offset start
				mov ax,offset tests	
				
				mov ax,4C00H
				int 21H
code ends
end start