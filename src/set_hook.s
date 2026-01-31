.globl set_hwbp
.globl unset_hwbp
.section .text

set_hwbp:		
	endbr64
	sub rsp, 1240	
	mov rax, rdx
	lea rdx, [rsp]
	push rcx
	push r8
	push r9    
	mov rcx, -2
	mov dword ptr [rdx+0x30], 0x0010001F
	sub rsp, 0x28
	call rax
	add rsp, 0x28
	cmp rax, 0x0
	jne gt_fail
	pop rax   
	lea rdx, [rsp+16]
	push rdx  
	cmp rax, 0x0
	je find_dr
	mov rcx, rax
	dec rcx

known_bit:
	mov rax, 0x1
	shl al, cl
	pop rdx   
	or [rdx+0x70], rax
	pop rax   
	mov [rdx+0x48+rcx*4], rax
	pop rcx    
	sub rsp, 0x20
	call call_ntc
	add rsp, 1272
	ret

call_ntc:
	endbr64
	lea rax, [rip+_exit]
	mov [rdx+0xf8], rax
	lea rax, [rsp]
	mov [rdx+0x98], rax
	mov rax, rcx
	mov rcx, rdx
	xor rdx, rdx
	sub rsp, 0x28
	call rax
	add rsp, 0x28
	ret

_exit:
	endbr64
	xor rax, rax
	ret

find_dr:
	mov rax, [rdx+0x70]
	xor rcx, rcx

dr_loop:
	cmp rcx, 0x7
	jge no_free
	bt rax, rcx
	jc add_bit
	jmp known_bit
	
add_bit:
	add rcx, 0x2
	jmp dr_loop

no_free:
	add rsp, 1264
	mov rax, 0x1
	ret

gt_fail:
	sub rsp, 1264
	ret

unset_hwbp:			
	endbr64
	sub rsp, 1240
	mov rax, rdx
	lea rdx, [rsp]
	mov dword ptr [rdx+0x30], 0x0010001F
	push rcx
	push r8
	mov rcx, -2
	sub rsp, 0x20
	call rax
	add rsp, 0x20
	lea rdx, [rsp+0x10]
	xor rcx, rcx
	pop rax

check_dr_set:
	cmp rcx, 0x7
	jge dr_not_set
	cmp [rdx+0x48+4*rcx], rax
	jne unset_add_bit
	mov qword ptr [rdx+0x48+4*rcx], 0x0
	mov rax, 0x1
	shl al, cl
	xor rax, 0xffffffffffffffff
	and [rdx+0x70], rax
	pop rcx
	sub rsp, 0x20
	call call_ntc
	add rsp, 1272
	xor rax, rax
	ret

unset_add_bit:
	add rcx, 0x2
	jmp check_dr_set

dr_not_set:
	add rsp, 1248
	mov rax, 0x1
	ret
