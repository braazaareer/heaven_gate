; heaven_gate.asm — NASM, target = win32
; Assemble with:
;   nasm -f win32 heaven_gate.asm -o heaven_gate.o

bits 32
default rel

section .text
    global _heaven_gate      ; export with leading underscore

; ----------------------------------------------------------------------------
; 32‑bit entry point (WOW64 stub)
; ----------------------------------------------------------------------------
_heaven_gate:
    push    0x33             ; selector for 64‑bit CS
    push    heaven_gate64    ; offset of 64‑bit stub
    db      0xCB             ; RETF → pop RIP,CS → switch to 64‑bit

; ----------------------------------------------------------------------------
; 64‑bit stub (now in long mode)
; ----------------------------------------------------------------------------
heaven_gate64:
    nop
    nop

    ; push selector for 32‑bit CS (0x23)
    db      0x6A, 0x23       ; PUSH 0x23

    ; LEA RAX, [RIP + rel32_to_ret32]
    ;   opcode: 48 8D 05 <imm32>
    db      0x48, 0x8D, 0x05
    dd      ret32 - ($ + 4)  ; NASM computes a proper little‑endian imm32

    ; push RAX (return RIP)
    db      0x50             ; PUSH RAX

    ; RETFQ → far return back to 32‑bit
    db      0xCB

; ----------------------------------------------------------------------------
; resume here under 32‑bit CS=0x23
; ----------------------------------------------------------------------------
ret32:
    ret
