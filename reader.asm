section .bss
    ; 256 Bytes reserved for input string
    input_buffer resb 256 ; Buffer for input string
    key_buffer resb 1     ; Buffer for key

section .text
    global _start         ; Entry point for the program

_start:
    ; === Read from stdin ===
    mov rax, 0            ; sys_read
    mov rdi, 0            ; stdin
    mov rsi, input_buffer ; pointer to buffer
    mov rdx, 256          ; number of bytes to read
    syscall               ; syscall: write(1, input_buffer, rax)
    mov rbx, rax          ; Save length of input string (in case its less than 256 bytes)
    
    ; === Write to stdout ===
    mov rax, 1            ; syscall: write
    mov rdi, 1            ; stdout
    mov rsi, input_buffer ; pointer to buffer
    mov rdx, rbx          ; number of bytes to write
    syscall               ; syscall: write(1, input_buffer, rbx)

    ; === Exit ===
    mov rax, 60           ; syscall number for exit
    xor rdi, rdi          ; exit code 0
    syscall