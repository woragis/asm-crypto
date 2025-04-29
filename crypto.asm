; crypto.asm
; Simple XOR-based encryption/decryption program for Linux x86_64
; Uses NASM syntax

section .data
    prompt_msg db "Enter string to encrypt/decrypt: ", 0
    prompt_len equ $ - prompt_msg
    key_prompt db "Enter single character key: ", 0
    key_len equ $ - key_prompt
    result_msg db "Result: ", 0
    result_len equ $ - result_msg
    newline db 10, 0
    buffer times 256 db 0 ; Buffer for input string
    key_buffer db 0       ; Buffer for key
    BUFSIZE equ 256

section .text
global _start

_start:
    ; Print prompt for string
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall

    ; Read input string
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, buffer
    mov rdx, BUFSIZE
    syscall
    mov rbx, rax        ; Save length of input string

    ; Print prompt for key
    mov rax, 1
    mov rdi, 1
    mov rsi, key_prompt
    mov rdx, key_len
    syscall

    ; Read single character key
    mov rax, 0
    mov rdi, 0
    mov rsi, key_buffer
    mov rdx, 1
    syscall

    ; Perform XOR encryption/decryption
    mov rcx, rbx        ; Length of input
    mov rsi, buffer     ; Input buffer
    mov al, [key_buffer]; Key
    xor_loop:
        cmp rcx, 1      ; Don't process newline
        jle done
        xor byte [rsi], al ; XOR operation
        inc rsi
        dec rcx
        jmp xor_loop

done:
    ; Print result message
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_len
    syscall

    ; Print result
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rbx
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; status 0
    syscall