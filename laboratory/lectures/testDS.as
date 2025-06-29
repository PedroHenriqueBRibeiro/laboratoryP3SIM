;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh
INITIAL_SP      EQU     FDFFh
CURSOR          EQU     FFFCh
CURSOR_INIT     EQU     FFFFh
ROW_SHIFT       EQU     8d
PACMAN_X        EQU     1d
PACMAN_Y        EQU     1d
RIGHT           EQU     3d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;------------------------------------------------------------------------------
                ORIG    8000h
L1			STR     '################################################################################', FIM_TEXTO
L2			STR     '#C ............       ##############      #############        #################', FIM_TEXTO
L3			STR     '## .         ...............      ##      ##                                  ##', FIM_TEXTO
L4			STR     '## .  ##  .  ###############      ##      ##       ##                         ##', FIM_TEXTO
L5			STR     '## .  ##  .   ........... ## .  . ##               ##                         ##', FIM_TEXTO
L6			STR     '## .  ##  .  ## .       . ##  ..  ##               ##                         ##', FIM_TEXTO
L7			STR     '## .  ##  .  ## .  ##   . ## .  . ##       ##########                         ##', FIM_TEXTO
L8			STR     '## .  ######### .  ## ..  ## ....          ##########                         ##', FIM_TEXTO
L9			STR     '## .            .  ## ..       #####            #####                         ##', FIM_TEXTO
L10			STR     '## .            .  ## .....  . #                    #                         ##', FIM_TEXTO
L11			STR     '   ........................... #                                                ', FIM_TEXTO
L12			STR     '   .  #####################  .                                                  ', FIM_TEXTO
L13			STR     '## .  #####################  .                      #                         ##', FIM_TEXTO
L14			STR     '## ........................... #                    #                         ##', FIM_TEXTO
L15			STR     '##                           .                                                ##', FIM_TEXTO
L16			STR     '##    #####################                                                   ##', FIM_TEXTO
L17			STR     '##    #####################                                                   ##', FIM_TEXTO
L18			STR     '##                                                                            ##', FIM_TEXTO
L19			STR     '##                                                                            ##', FIM_TEXTO
L20			STR     '##    ############################                                            ##', FIM_TEXTO
L21			STR     '##                                                                            ##', FIM_TEXTO
L22			STR     '################################################################################', FIM_TEXTO
L23			STR     '################################################################################', FIM_TEXTO
L24			STR     'SCORE:  000 ########################################################### LIFES :3', FIM_MAPA

RowIndex        WORD    0d
ColumnIndex     WORD    0d
TextIndex       WORD    0d
PacmanX         WORD    PACMAN_X
PacmanY         WORD    PACMAN_Y

;------------------------------------------------------------------------------
; ZONA III: tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    MoverDireita

;------------------------------------------------------------------------------
; ZONA IV: codigo principal
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; Rotina de Interrupção para mover direita
;------------------------------------------------------------------------------
MoverDireita:   PUSH    R1
                PUSH    R2
                
                ; Remove Pacman da posição atual
                MOV     R1, M[PacmanY]
                MOV     R2, M[PacmanX]
                SHL     R1, ROW_SHIFT
                OR      R1, R2
                MOV     M[CURSOR], R1
                MOV     R1, ' '
                MOV     M[IO_WRITE], R1
                
                ; Atualiza posição X
                INC     M[PacmanX]
                
                ; Desenha Pacman na nova posição
                MOV     R1, M[PacmanY]
                MOV     R2, M[PacmanX]
                SHL     R1, ROW_SHIFT
                OR      R1, R2
                MOV     M[CURSOR], R1
                MOV     R1, 'C'
                MOV     M[IO_WRITE], R1
                
                POP     R2
                POP     R1
                RTI

;------------------------------------------------------------------------------
; Função para imprimir o mapa
;------------------------------------------------------------------------------
PrintarMapa:    PUSH    R1
                PUSH    R2
                PUSH    R3
                
                MOV     R1, L1
                MOV     M[TextIndex], R1
                MOV     R2, 0d          ; Linha inicial
                MOV     R3, 0d          ; Coluna inicial

PrintLoop:      MOV     R1, M[TextIndex]
                MOV     R1, M[R1]       ; Carrega caractere
                
                CMP     R1, FIM_TEXTO   ; Fim da linha?
                JMP.Z   NextLine
                
                ; Configura cursor e imprime
                SHL     R2, ROW_SHIFT
                OR      R2, R3
                MOV     M[CURSOR], R2
                MOV     M[IO_WRITE], R1
                
                INC     R3              ; Próxima coluna
                INC     M[TextIndex]    ; Próximo caractere
                JMP     PrintLoop

NextLine:       INC     R2              ; Próxima linha
                MOV     R3, 0d          ; Reset coluna
                INC     M[TextIndex]    ; Pula o '@'
                JMP     PrintLoop
                
EndPrint:       POP     R3
                POP     R2
                POP     R1
                RET

;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:           ENI
                MOV     R1, INITIAL_SP
                MOV     SP, R1
                MOV     R1, CURSOR_INIT
                MOV     M[CURSOR], R1
                
                CALL    PrintarMapa
                
                ; Desenha Pacman inicial
                MOV     R1, M[PacmanY]
                MOV     R2, M[PacmanX]
                SHL     R1, ROW_SHIFT
                OR      R1, R2
                MOV     M[CURSOR], R1
                MOV     R1, 'C'
                MOV     M[IO_WRITE], R1

Cycle:          BR      Cycle
Halt:           BR      Halt