section .bss
    input_buffer resb 100        ; user input
    encrypted_buffer resb 100    ; encrypted result

section .data
    newline db 10
    newline_len equ 1
    xor_key db 0x42              ; encryption key

section .text
    global _start

_start:
    ; --- Read input from stdin ---
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; stdin
    mov rsi, input_buffer
    mov rdx, 100
    syscall
    mov rcx, rax        ; rcx = length of input

    ; --- Encrypt each byte with XOR ---
    xor rbx, rbx        ; rbx = index
    movzx r8, byte [xor_key]

encrypt_loop:
    cmp rbx, rcx
    jge print_original

    mov al, [input_buffer + rbx] ; read input byte
    mov dl, al
    xor dl, r8b                  ; XOR with key
    mov [encrypted_buffer + rbx], dl

    inc rbx
    jmp encrypt_loop

; --- Print Original ---
print_original:
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, input_buffer
    mov rdx, rcx        ; length
    syscall

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

; --- Print Encrypted ---
    mov rax, 1
    mov rdi, 1
    mov rsi, encrypted_buffer
    mov rdx, rcx
    syscall

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

; --- Exit program ---
    mov rax, 60
    xor rdi, rdi
    syscall
