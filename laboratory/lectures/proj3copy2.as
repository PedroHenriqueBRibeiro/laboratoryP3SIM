;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR                EQU     0Ah
FIM_TEXTO         EQU     '@'
FIM_MAPA          EQU     99d
IO_READ           EQU     FFFFh
IO_WRITE          EQU     FFFEh
IO_STATUS         EQU     FFFDh
INITIAL_SP        EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT	    EQU     FFFFh
ROW_POSITION	    EQU     0d
COL_POSITION	    EQU     0d
ROW_SHIFT	        EQU     8d
COLUMN_SHIFT     EQU     8d    
PACMAN_X          EQU     1d
PACMAN_Y          EQU     1d
DOWN              EQU     0d
UP                EQU     1d
LEFT              EQU     2d
RIGHT             EQU     3d
STOP              EQU     4d
TIMER_UNITS       EQU     FFF6h
ACTIVATE_TIMER    EQU     FFF7h
ON                EQU     1d
OFF               EQU     0d
POSICAO_INICIAL   EQU     8052h ;89C3h

RND_MASK		EQU	8016h	; 1000 0000 0001 0110b
LSB_MASK		EQU	0001h	; Mascara para testar o bit menos significativo do Random_Var
PRIME_NUMBER_1	EQU 11d
PRIME_NUMBER_2	EQU 13d


;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
L1    STR '################################################################################', FIM_TEXTO
L2    STR '#  ............        ..#####......     #########.....      .................##', FIM_TEXTO
L3    STR '## .##########.##.##.##..........##.................##.##  ##.##   ##.##   ##.##', FIM_TEXTO
L4    STR '## .#        #.##.##....##..##.#.##.##....##.##.###.##.##  ##.## . ##.## . ##.##', FIM_TEXTO
L5    STR '## .#........#.##.##.##.##  ##.#.......##.##.##  .#.##.##  ##.## . ##.## . ##.##', FIM_TEXTO
L6    STR '## .#.#    #.#.##....##.##  ...#.##.##.##.##.##   ..##.##  ##.##   ##.##   ##.##', FIM_TEXTO
L7    STR '## .#.#    #.#.##  #....######......##.......#####........................... ##', FIM_TEXTO
L8    STR '## .#.#    #.#.##  #.##.........##.##.##.##.......... ##.##  ....##   ...###. ##', FIM_TEXTO
L9    STR '## .#.#....#...    #.##########.##.##.##.###########. ##.##  .##.##   ##.###. ##', FIM_TEXTO
L10   STR '## . .######.#.     ..................................##.##  .##...   ...###. ##', FIM_TEXTO
L11   STR '## .         #.## ########....#######################.........##########.###. ##', FIM_TEXTO
L12   STR '## .##########.## #.........................................................  ##', FIM_TEXTO
L13   STR '## ....................................######...............................  ##', FIM_TEXTO
L14   STR '## .##########.## #.........................................................  ##', FIM_TEXTO
L15   STR '## .#........#.## ########....#####.############.####....###.###.##....#.###. ##', FIM_TEXTO
L16   STR '## .#.#.####.#.## # ................##................##.##. .##.##   .#.###. ##', FIM_TEXTO
L17   STR '## .#.#....#.#.## # .#########...##.## ##.#########.#......   ...##   .#.###. ##', FIM_TEXTO
L18   STR '## .#.#.##.#.#.## # .##........#....## ##.##..........#. #####.####.##.#.###. ##', FIM_TEXTO
L19   STR '## ...#.##.#.#.## # .##.## .##...##... ##.##.#####.##.#...................... ##', FIM_TEXTO
L20   STR '## .#.#....#.#.## # ....## .........## ...##.##   .##.##......######...#...##.##', FIM_TEXTO
L21   STR '## ......... ....   .##... .##.#.##.####.....#   #....##   ...##   #....   ...##', FIM_TEXTO
L22   STR '################################################################################', FIM_TEXTO
L23   STR '################################################################################', FIM_TEXTO
L24   STR 'SCORE:  000 ########################################################### LIFES :3', FIM_MAPA


Derrota         STR     'YOU LOSE!',FIM_MAPA

Vitoria         STR     'YOU WIN!',FIM_MAPA


RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d
YFim            WORD   11d

;-------------------------------------------------------------------------------
;Configurações Pacman
;-------------------------------------------------------------------------------
EnderecoString    WORD  0d
PacmanDirection   WORD  RIGHT
PacmanNovoX       WORD  PACMAN_X
PacmanNovoY       WORD  PACMAN_Y
PacmanEndereco    WORD  POSICAO_INICIAL

;-------------------------------------------------------------------------------
;Configurações pontos
;-------------------------------------------------------------------------------
Unidade           WORD  48d
Dezena            WORD  48d
Centena           WORD  48d
linha_Pontos      WORD  23d
coluna_Pontos     WORD  8d
flagWin           WORD  0d

;-------------------------------------------------------------------------------
;Configurações Vida
;-------------------------------------------------------------------------------

Vidas             WORD  51d
linha_vida        WORD  23d
coluna_vida       WORD  79d
Random_var        WORD  A5A5h

;-------------------------------------------------------------------------------
;Configurações dos Fantasmas
;-------------------------------------------------------------------------------
DirecaoGhost1   WORD    DOWN
XGhost1         WORD    78d
YGhost1         WORD    1d
PosGhost1       WORD    0

DirecaoGhost2   WORD    DOWN
XGhost2         WORD    78d
YGhost2         WORD    19d
PosGhost2       WORD    0

DirecaoGhost3   WORD    DOWN
XGhost3         WORD    4d
YGhost3         WORD    19d
PosGhost3       WORD    0



;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    MoverDireita
INT1            WORD    MoverEsquerda
INT2            WORD    MoverCima
INT3            WORD    MoverBaixo
                ORIG    FE0Fh

INT15           WORD    Timer

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main


Timer:            PUSH R1
                  PUSH R2

                  CALL PrintPontos 
                  
                  ; --- Controle do Fantasma 1 ---
                  CALL GhostAI
                  MOV R2, M[DirecaoGhost1]
                  CMP R2, DOWN
                  CALL.Z MovimentaBaixoGhost1
                  CMP R2, UP 
                  CALL.Z MovimentaCimaGhost1
                  CMP R2, RIGHT
                  CALL.Z MovimentaDireitaGhost1
                  CMP R2, LEFT
                  CALL.Z MovimentaEsquerdaGhost1
                  
                  ; --- Controle do Fantasma 2 ---
                  CALL GhostAI2
                  MOV R2, M[DirecaoGhost2]
                  CMP R2, DOWN
                  CALL.Z MovimentaBaixoGhost2
                  CMP R2, UP 
                  CALL.Z MovimentaCimaGhost2
                  CMP R2, RIGHT
                  CALL.Z MovimentaDireitaGhost2
                  CMP R2, LEFT
                  CALL.Z MovimentaEsquerdaGhost2


                  ; --- Controle do Fantasma 3 ---
                  CALL GhostAI3
                  MOV R2, M[DirecaoGhost3]
                  CMP R2, DOWN
                  CALL.Z MovimentaBaixoGhost3
                  CMP R2, UP 
                  CALL.Z MovimentaCimaGhost3
                  CMP R2, RIGHT
                  CALL.Z MovimentaDireitaGhost3
                  CMP R2, LEFT
                  CALL.Z MovimentaEsquerdaGhost3
                  
                  ; --- Verificação de colisões ---
                  CALL ColisaoGhostPacman
                  
                  ; --- Controle do Pacman ---
                  CALL VerificaMovimento
                  MOV R1, M[PacmanDirection]
                  CMP R1, RIGHT
                  CALL.Z MovimentaDireita
                  CMP R1, LEFT
                  CALL.Z MovimentaEsquerda
                  CMP R1, UP
                  CALL.Z MovimentaCima
                  CMP R1, DOWN
                  CALL.Z MovimentaBaixo

                  CALL checkWin
                  CALL Configura_Timer

                  POP R2
                  POP R1
                  RTI
;------------------------------------------------------------------------------
;Função de colisão com o fantasmas
;------------------------------------------------------------------------------
ColisaoGhostPacman:     PUSH R1
                        PUSH R2
                        PUSH R3
                        MOV R1, M[PacmanNovoX]
                        MOV R2, M[XGhost1]
                        CMP R1, R2
                        JMP.NZ checkGhost2
                        MOV R1, M[PacmanNovoY]
                        MOV R2, M[YGhost1]
                        CMP R1, R2
                        JMP.Z colisaoDetectada

checkGhost2:            MOV R1, M[PacmanNovoX]
                        MOV R2, M[XGhost2]
                        CMP R1, R2
                        JMP.NZ checkGhost3
                        MOV R1, M[PacmanNovoY]
                        MOV R2, M[YGhost2]
                        CMP R1, R2
                        JMP.Z colisaoDetectada

checkGhost3:            MOV R1, M[PacmanNovoX]
                        MOV R2, M[XGhost3]
                        CMP R1, R2
                        JMP.NZ notDead
                        MOV R1, M[PacmanNovoY]
                        MOV R2, M[YGhost3]
                        CMP R1, R2
                        JMP.NZ notDead

colisaoDetectada:       CALL ResetMapa
                        DEC M[Vidas]
                        CALL diminuirVida

notDead:                POP R3
                        POP R2
                        POP R1
                        RET
;------------------------------------------------------------------------------
;Funções de fim de jogo
;------------------------------------------------------------------------------

checkWin: PUSH R1 
              
              MOV R1, M[Vidas] ;Verifica vida = 0
              CMP R1, 48d
              
              JMP.Z Lose 
              
              MOV R1, M[Centena]   ;Verifica pontuação = 100
              CMP R1, 49d
              JMP.NZ NaoGanhou
              
              MOV R1, M[Dezena]
              CMP R1, 48d
              JMP.NZ NaoGanhou
              
              MOV R1, M[Unidade]
              CMP R1, 48d
              JMP.NZ NaoGanhou
              
              Jmp Win
              
              POP R1
              RET 

Lose:POP R1
     CALL printWinLose  
     JMP Halt

NaoGanhou:POP R1
          RET  

Win:    POP R1

        PUSH R1
        MOV R1, 1d
        MOV M[flagWin],R1
        CALL printWinLose
        POP R1
        
        JMP Halt

;------------------------------------------------------------------------------
;Função para imprimir a vitoria ou a derrota
;------------------------------------------------------------------------------
printWinLose:   PUSH    R1
                PUSH    R2
                PUSH    R3

                MOV     R1, 34d
                MOV     M[ColumnIndex],R1
                MOV     R1, M[ flagWin ]
                CMP     R1, 1d
                JMP.NZ  Perdeu 
                MOV     R1, Vitoria
                JMP     Continue

                Perdeu:         MOV     R1, Derrota

                Continue:       MOV     R3, M[ ColumnIndex ]
                                MOV     M[ TextIndex ], R1
                WhileFIM:       MOV     R2, M[ YFim ]
                                MOV     R1, M[ TextIndex ]
                                SHL     R2, 8d
                                MOV     R1, M[ R1 ]
                                OR      R2, R3
                                MOV     M[ CURSOR ], R2

                                INC     M[ TextIndex ]
                                INC     R3

                                CMP     R1, FIM_MAPA
                                JMP.Z  FimVitoria
                                MOV     M[ IO_WRITE ], R1
                                JMP     WhileFIM

FimVitoria:     POP     R3
                POP     R2
                POP     R1
                RET
               
;------------------------------------------------------------------------------
;Funções de colisão com fantasma
;------------------------------------------------------------------------------

diminuirVida: PUSH R1
             PUSH R2
             PUSH R3
             
             MOV   R1, M[ Vidas ]
             MOV   R2, M[linha_vida]
             MOV   R3, M[coluna_vida]
             SHL   R2, 8d
             OR    R2, R3
             MOV   M[ CURSOR ], R2
             MOV   M[ IO_WRITE ], R1 

             POP R3
             POP R2
             POP R1
             RET

ResetMapa: PUSH R1
           PUSH R2 

           MOV R1, M[PacmanEndereco] ;Limpa a posicao que o pacman estava
           MOV R2, ' '
           MOV M[R1], R2 ; Limpou a posicao na RAM 

           MOV R1, DOWN; direcao para baixo
           MOV M[PacmanDirection], R1

           MOV R2, PACMAN_X 
           MOV  M[PacmanNovoX], R2 ; Muda os valores de x e y do pacman

           MOV R2, PACMAN_Y
           MOV  M[PacmanNovoY], R2
           MOV R1, POSICAO_INICIAL 
           MOV  M[PacmanEndereco],R1
           MOV R2,'C'
           MOV M[R1],R2 

           POP R2
           POP R1
           RET

;------------------------------------------------------------------------------
;Funções de movimentação do pacman
;------------------------------------------------------------------------------

MoverDireita:     PUSH R1
                  
                  MOV R1, RIGHT
                  MOV M[PacmanDirection], R1

                  POP R1

                  RTI

MoverEsquerda:    PUSH R1
                  
                  MOV R1, LEFT
                  MOV M[PacmanDirection], R1

                  POP R1

                  RTI

MoverCima:        PUSH R1
                
                  MOV R1, UP
                  MOV M[PacmanDirection], R1

                  POP R1

                  RTI

MoverBaixo: PUSH R1
                  
           MOV R1, DOWN
           MOV M[PacmanDirection], R1

           POP R1

           RTI

MovimentaDireita: PUSH R1
                  PUSH R2

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]

                  SHL R1, 8d
                  OR R1,R2
                  MOV M[CURSOR],R1
                  MOV R1, ' '
                  MOV M[IO_WRITE],R1

                  MOV R1, M[PacmanEndereco]

                  MOV R2, ' '   
                  MOV M[R1],R2


                  INC M[PacmanNovoX]
                  INC M[PacmanEndereco]

                  MOV R1,M[PacmanEndereco]
                  MOV R2, 'C'
                  MOV M[R1],R2 

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]
                  SHL R1, 8d
                  OR R1,R2                  
                  MOV M[CURSOR], R1

                  MOV R1,'C'
                  MOV M[IO_WRITE],R1

                  POP R2
                  POP R1
                  RET

MovimentaEsquerda:PUSH R1
                  PUSH R2

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]

                  SHL R1, 8d
                  OR R1,R2
                  MOV M[CURSOR],R1
                  MOV R1, ' '
                  MOV M[IO_WRITE],R1
                  
                  MOV R1, M[PacmanEndereco]
                  MOV R2, ' '   
                  MOV M[R1],R2

                  DEC M[PacmanNovoX]
                  DEC M[PacmanEndereco]

                  MOV R1,M[PacmanEndereco]
                  MOV R2, 'C'
                  MOV M[R1],R2 

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]
                  SHL R1, 8d
                  OR R1,R2                  
                  MOV M[CURSOR], R1

                  MOV R1,'C'
                  MOV M[IO_WRITE],R1

                  POP R2
                  POP R1
                  RET

MovimentaBaixo:   PUSH R1
                  PUSH R2

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]

                  SHL R1, 8d
                  OR R1,R2
                  MOV M[CURSOR],R1
                  MOV R1, ' '
                  MOV M[IO_WRITE],R1

                  INC M[PacmanNovoY]
                  MOV R1,M[PacmanEndereco]
                  MOV R2, ' '
                  MOV M[R1],R2
                  ADD R1,81d
                  MOV M[PacmanEndereco],R1
                  MOV R2, 'C'
                  MOV M[R1],R2

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]
                  SHL R1, 8d
                  OR R1,R2                  
                  MOV M[CURSOR], R1

                  MOV R1,'C'
                  MOV M[IO_WRITE],R1

                  POP R2
                  POP R1
                  RET

MovimentaCima:    PUSH R1
                  PUSH R2

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]

                  SHL R1, 8d
                  OR R1,R2
                  MOV M[CURSOR],R1
                  MOV R1, ' '
                  MOV M[IO_WRITE],R1

                  DEC M[PacmanNovoY]
                  MOV R1,M[PacmanEndereco]
                  MOV R2, ' '   
                  MOV M[R1],R2
                  SUB R1,81d
                  MOV M[PacmanEndereco],R1
                  MOV R2, 'C'
                  MOV M[R1],R2 

                  MOV R1, M[PacmanNovoY]
                  MOV R2, M[PacmanNovoX]
                  SHL R1, 8d
                  OR R1,R2                  
                  MOV M[CURSOR], R1

                  MOV R1,'C'
                  MOV M[IO_WRITE],R1

                  POP R2
                  POP R1
                  RET

VerificaMovimento: PUSH R1 
                   PUSH R2 

                   MOV R1, M[PacmanDirection]

                   CMP R1, RIGHT
                   CALL.Z VerificaDireita
                   CMP R1, LEFT 
                   CALL.Z VerificaEsquerda
                   CMP R1, UP
                   CALL.Z VerificaCima
                   CMP R1, DOWN
                   CALL.Z VerificaBaixo
                   
                   POP R2
                   POP R1
                   RET

VerificaDireita: PUSH R1
                 PUSH R2

                 MOV R1, M[PacmanEndereco]
                 INC R1
                 MOV R1, M[R1]
                 CMP R1,'#'
                 CALL.Z Parede
                 CMP R1,'.'
                 CALL.Z Ponto  
                 POP R2
                 POP R1
                 RET 

VerificaEsquerda: PUSH R1
                  PUSH R2
                  
                  MOV R1, M[PacmanEndereco]
                  DEC R1
                  MOV R1, M[R1]
                  CMP R1,'#'
                  CALL.Z Parede
                  CMP R1,'.'
                  CALL.Z Ponto
                  POP R2
                  POP R1
                  RET 

VerificaBaixo:    PUSH R1
                  PUSH R2
                  
                  MOV R1, M[PacmanEndereco]
                  ADD R1, 81d
                  MOV R1, M[R1]
                  CMP R1,'#'
                  CALL.Z Parede
                  CMP R1,'.'
                  CALL.Z Ponto
                  POP R2
                  POP R1
                  RET 

VerificaCima:    PUSH R1
                 PUSH R2
                  
                 MOV R1, M[PacmanEndereco]
                 SUB R1, 81d
                 MOV R1, M[R1]
                 CMP R1,'#'
                 CALL.Z Parede
                 CMP R1,'.'
                 CALL.Z Ponto
                 POP R2
                 POP R1
                 RET 

Parede:         PUSH R5 
                MOV R5, STOP
                MOV M[PacmanDirection],R5
                POP R5
                RET

;------------------------------------------------------------------------------
;Funções de pontuação
;------------------------------------------------------------------------------

Ponto: PUSH R1
       PUSH R2
       PUSH R3
       PUSH R4
       PUSH R5

       MOV R2, M[PacmanEndereco]
       INC M[Unidade]

       MOV R5, M[PacmanDirection]
       CMP R5, RIGHT
       CALL.Z PontoDireita
       CMP R5, LEFT
       CALL.Z PontoEsquerda
       CMP R5, UP
       CALL.Z PontoCima
       CMP R5, DOWN
       CALL.Z PontoBaixo


       MOV R3, 58d
       MOV R4, M[Unidade]

       CMP R3,R4
       CALL.Z aumentaDezena

       CALL PrintPontos

       SHL R1, 3


       POP R5
       POP R4
       POP R3
       POP R2
       POP R1 
       RET  

PontoDireita: PUSH R1
              PUSH R2

              MOV R2, M[PacmanEndereco]
              MOV R1,' '
              INC R2
              MOV M[R2], R1

              POP R2
              POP R1
              RET

PontoEsquerda:PUSH R1
              PUSH R2

              MOV R2, M[PacmanEndereco]
              MOV R1,' '
              DEC R2
              MOV M[R2], R1

              POP R2
              POP R1
              RET

PontoCima:PUSH R1
          PUSH R2

          MOV R2, M[PacmanEndereco]
          MOV R1,' '
          
          SUB R2, 81d

          MOV M[R2], R1

          POP R2
          POP R1
          RET

PontoBaixo:PUSH R1
           PUSH R2

           MOV R2, M[PacmanEndereco]
           MOV R1,' '
          
           ADD R2, 81d

           MOV M[R2], R1

           POP R2
           POP R1
           RET

aumentaDezena:PUSH R1
              PUSH R2

              MOV R1, 48d
              MOV M[Unidade],R1
              INC M[Dezena]
              MOV R2, 58d
              MOV R1,M[Dezena]
              CMP R1,R2
              CALL.Z aumentaCentena

              POP R2
              POP R1
              RET

aumentaCentena:PUSH R1
               PUSH R2

               MOV R1, 48d
               MOV M[Dezena],R1
               INC M[Centena]

               POP R2
               POP R1
               RET






                                ;-----------------------------------------------
                                ;                 FANTASMA 1                   -
                                ;-----------------------------------------------





;------------------------------------------------------------------------------
;Funções de movimentação do fantasma 1
;------------------------------------------------------------------------------

VerificaMovimentoGhost1:PUSH R1 
                        PUSH R2 

                        MOV R1, M[DirecaoGhost1]

                        CMP R1, DOWN  
                        CALL.Z VerificaBaixoGhost1
                        CMP R1, UP
                        CALL.Z VerificaCimaGhost1
                        CMP R1,RIGHT
                        CALL.Z VerificaDireitaGhost1
                        CMP R1,LEFT
                        CALL.Z VerificaEsquerdaGhost1
                   
                        POP R2
                        POP R1
                        RET

MovimentaBaixoGhost1:PUSH R1
                     PUSH R2

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost1]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1

                     INC M[YGhost1]
                     MOV R1,M[PosGhost1]
                     ADD R1,81d
                     MOV M[PosGhost1],R1

                     MOV R1, M[YGhost1] 
                     MOV R2, M[XGhost1]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaCimaGhost1:PUSH R1
                     PUSH R2

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost1]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1

                     DEC M[YGhost1]
                     MOV R1,M[PosGhost1]
                     SUB R1,81d
                     MOV M[PosGhost1],R1

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaDireitaGhost1:PUSH R1
                       PUSH R2

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]

                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost1]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1                     

                     INC M[XGhost1]
                     MOV R1,M[PosGhost1]
                     ADD R1,1d
                     MOV M[PosGhost1],R1

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaEsquerdaGhost1:PUSH R1
                        PUSH R2

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost1]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1                                  

                     DEC M[XGhost1]
                     MOV R1,M[PosGhost1]
                     DEC R1
                     MOV M[PosGhost1],R1

                     MOV R1, M[YGhost1]
                     MOV R2, M[XGhost1]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

VerificaBaixoGhost1:PUSH R1
                   PUSH R2
                  
                   MOV R1, M[PosGhost1]
                   ADD R1, 81d
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost
                   POP R2
                   POP R1
                   RET 

VerificaCimaGhost1:PUSH R1
                   PUSH R2
                   MOV R1, M[PosGhost1]
                   SUB R1, 81d
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost
                   POP R2
                   POP R1
                   RET 

VerificaDireitaGhost1:PUSH R1
                   PUSH R2
                  
                   MOV R1, M[PosGhost1]
                   INC R1
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost
                   POP R2
                   POP R1
                   RET 

VerificaEsquerdaGhost1:PUSH R1
                       PUSH R2
                  
                       MOV R1, M[PosGhost1]
                       DEC R1
                       MOV R1, M[R1]
                       CMP R1,'#'
                       CALL.Z ParedeGhost
                       POP R2
                       POP R1
                       RET 

ParedeGhost:PUSH R5 
            MOV R5, STOP
            MOV M[DirecaoGhost1],R5 
            CALL Random
            CALL VerificaMovimentoGhost1
            POP R5
            RET


;------------------------------------------------------------------------------
; GhostAI
; Função para perseguir o Pacman         
;------------------------------------------------------------------------------
GhostAI:          PUSH R1
                  PUSH R2
                  PUSH R3
                  PUSH R4

                  ; Obter posições atuais
                  MOV R1, M[XGhost1]      ; Fantasma X
                  MOV R2, M[PacmanNovoX]  ; Pacman X
                  MOV R3, M[YGhost1]      ; Fantasma Y
                  MOV R4, M[PacmanNovoY]  ; Pacman Y

                  ; Calcular diferenças
                  SUB R2, R1  ; R2 =  (PacmanX - GhostX)
                  SUB R4, R3  ; R4 =  (PacmanY - GhostY)

                  ; Prioridade para movimento horizontal
                  CMP R2, 0
                  JMP.Z CheckVertical  ; Se  = 0, verifica vertical
                  JMP.P TryRight       ; Se  > 0, tenta direita
                  JMP TryLeft          ; Se  < 0, tenta esquerda

CheckVertical:    CMP R4, 0
                  JMP.Z EndGhostAI     ; Se  também = 0, não move
                  JMP.P TryDown        ; Se  > 0, tenta baixo
                  JMP TryUp            ; Se  < 0, tenta cima

TryRight:        MOV R1, RIGHT
                 MOV M[DirecaoGhost1], R1
                 CALL VerificaMovimentoGhost1
                 MOV R1, M[DirecaoGhost1]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI
                 JMP CheckVertical     ; Se não pode ir para direita, tenta vertical

TryLeft:         MOV R1, LEFT
                 MOV M[DirecaoGhost1], R1
                 CALL VerificaMovimentoGhost1
                 MOV R1, M[DirecaoGhost1]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI
                 JMP CheckVertical     ; Se não pode ir para esquerda, tenta vertical

TryDown:         MOV R1, DOWN
                 MOV M[DirecaoGhost1], R1
                 CALL VerificaMovimentoGhost1
                 MOV R1, M[DirecaoGhost1]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI
                 JMP TryRight         ; Se não pode ir para baixo, tenta direita

TryUp:           MOV R1, UP
                 MOV M[DirecaoGhost1], R1
                 CALL VerificaMovimentoGhost1
                 MOV R1, M[DirecaoGhost1]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI
                 JMP TryLeft           ; Se não pode ir para cima, tenta esquerda

EndGhostAI:      POP R4
                 POP R3
                 POP R2
                 POP R1
                 RET

;------------------------------------------------------------------------------
;Random (Gerar número aleatório)
;------------------------------------------------------------------------------
Random:         PUSH    R1
                PUSH    R2
                MOV     R1, LSB_MASK
                AND     R1, M[Random_var]
                BR.Z    RandomDirection
                MOV     R1, RND_MASK
                XOR     M[Random_var], R1

RandomDirection:     ROR     M[Random_var], 1
                     
                MOV     R2, 4d
                MOV     R1, M[ Random_var]
                DIV     R1, R2                  ;Dividir por 4, para cada direção (up, down, left, right)
                MOV     M[ DirecaoGhost1 ], R2  ;O resto da divisão é um valor entre 0 e 3

                POP     R2
                POP     R1
                RET




                                ;-----------------------------------------------
                                ;                 FANTASMA 2                   -
                                ;-----------------------------------------------


;------------------------------------------------------------------------------
;Funções de movimentação do fantasma 2
;------------------------------------------------------------------------------

VerificaMovimentoGhost2:PUSH R1 
                        PUSH R2 

                        MOV R1, M[DirecaoGhost2]

                        CMP R1, DOWN  
                        CALL.Z VerificaBaixoGhost2
                        CMP R1, UP
                        CALL.Z VerificaCimaGhost2
                        CMP R1,RIGHT
                        CALL.Z VerificaDireitaGhost2
                        CMP R1,LEFT
                        CALL.Z VerificaEsquerdaGhost2
                   
                        POP R2
                        POP R1
                        RET

MovimentaBaixoGhost2:PUSH R1
                     PUSH R2

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost2]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1

                     INC M[YGhost2]
                     MOV R1,M[PosGhost2]
                     ADD R1,81d
                     MOV M[PosGhost2],R1

                     MOV R1, M[YGhost2] 
                     MOV R2, M[XGhost2]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaCimaGhost2:PUSH R1
                     PUSH R2

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost2]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1

                     DEC M[YGhost2]
                     MOV R1,M[PosGhost2]
                     SUB R1,81d
                     MOV M[PosGhost2],R1

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaDireitaGhost2:PUSH R1
                       PUSH R2

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]

                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost2]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1                     

                     INC M[XGhost2]
                     MOV R1,M[PosGhost2]
                     ADD R1,1d
                     MOV M[PosGhost2],R1

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaEsquerdaGhost2:PUSH R1
                        PUSH R2

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost2]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1                                  

                     DEC M[XGhost2]
                     MOV R1,M[PosGhost2]
                     DEC R1
                     MOV M[PosGhost2],R1

                     MOV R1, M[YGhost2]
                     MOV R2, M[XGhost2]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

VerificaBaixoGhost2:PUSH R1
                   PUSH R2
                  
                   MOV R1, M[PosGhost2]
                   ADD R1, 81d
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost2
                   POP R2
                   POP R1
                   RET 

VerificaCimaGhost2:PUSH R1
                   PUSH R2
                   MOV R1, M[PosGhost2]
                   SUB R1, 81d
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost2
                   POP R2
                   POP R1
                   RET 

VerificaDireitaGhost2:PUSH R1
                   PUSH R2
                  
                   MOV R1, M[PosGhost2]
                   INC R1
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost2
                   POP R2
                   POP R1
                   RET 

VerificaEsquerdaGhost2:PUSH R1
                       PUSH R2
                  
                       MOV R1, M[PosGhost2]
                       DEC R1
                       MOV R1, M[R1]
                       CMP R1,'#'
                       CALL.Z ParedeGhost2
                       POP R2
                       POP R1
                       RET 


ParedeGhost2:   PUSH R5 
                MOV R5, STOP
                MOV M[DirecaoGhost2],R5 
                CALL Random2
                CALL VerificaMovimentoGhost2
                POP R5
                RET

;------------------------------------------------------------------------------
; GhostAI2
; Função para perseguir o Pacman
;------------------------------------------------------------------------------
GhostAI2:         PUSH R1
                  PUSH R2
                  PUSH R3
                  PUSH R4

                  ; Obter posições atuais
                  MOV R1, M[XGhost2]      ; Fantasma X
                  MOV R2, M[PacmanNovoX]  ; Pacman X
                  MOV R3, M[YGhost2]      ; Fantasma Y
                  MOV R4, M[PacmanNovoY]  ; Pacman Y

                  ; Calcular diferenças
                  SUB R2, R1  ; R2 =  (PacmanX - GhostX)
                  SUB R4, R3  ; R4 =  (PacmanY - GhostY)

                  ; Prioridade para movimento horizontal
                  CMP R2, 0
                  JMP.Z CheckVertical2  ; Se  = 0, verifica vertical
                  JMP.P TryRight2       ; Se  > 0, tenta direita
                  JMP TryLeft2          ; Se  < 0, tenta esquerda

CheckVertical2:   CMP R4, 0
                  JMP.Z EndGhostAI2     ; Se  também = 0, não move
                  JMP.P TryDown2        ; Se  > 0, tenta baixo
                  JMP TryUp2            ; Se  < 0, tenta cima

TryRight2:       MOV R1, RIGHT
                 MOV M[DirecaoGhost2], R1
                 CALL VerificaMovimentoGhost2
                 MOV R1, M[DirecaoGhost2]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI2
                 JMP CheckVertical2     ; Se não pode ir para direita, tenta vertical

TryLeft2:        MOV R1, LEFT
                 MOV M[DirecaoGhost2], R1
                 CALL VerificaMovimentoGhost2
                 MOV R1, M[DirecaoGhost2]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI2
                 JMP CheckVertical2     ; Se não pode ir para esquerda, tenta vertical

TryDown2:        MOV R1, DOWN
                 MOV M[DirecaoGhost2], R1
                 CALL VerificaMovimentoGhost2
                 MOV R1, M[DirecaoGhost2]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI2
                 JMP TryRight2         ; Se não pode ir para baixo, tenta direita

TryUp2:          MOV R1, UP
                 MOV M[DirecaoGhost2], R1
                 CALL VerificaMovimentoGhost2
                 MOV R1, M[DirecaoGhost2]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI2
                 JMP TryLeft2           ; Se não pode ir para cima, tenta esquerda

EndGhostAI2:      POP R4
                 POP R3
                 POP R2
                 POP R1
                 RET


;------------------------------------------------------------------------------
;Random Fantasma 2 (Gerar número aleatório)
;------------------------------------------------------------------------------
Random2:        PUSH    R1
                PUSH    R2
                MOV     R1, LSB_MASK
                AND     R1, M[Random_var]
                BR.Z    RandomDirection2
                MOV     R1, RND_MASK
                XOR     M[Random_var], R1

RandomDirection2:     ROR     M[Random_var], 1
                     
                MOV     R2, 4d
                MOV     R1, M[ Random_var]
                DIV     R1, R2                  ;Dividir por 4, para cada direção (up, down, left, right)
                MOV     M[ DirecaoGhost2 ], R2  ;O resto da divisão é um valor entre 0 e 3

                POP     R2
                POP     R1
                RET





                                ;-----------------------------------------------
                                ;                 FANTASMA 3                   -
                                ;-----------------------------------------------


;------------------------------------------------------------------------------
;Funções de movimentação do fantasma 3
;------------------------------------------------------------------------------

VerificaMovimentoGhost3:PUSH R1 
                        PUSH R2 

                        MOV R1, M[DirecaoGhost3]

                        CMP R1, DOWN  
                        CALL.Z VerificaBaixoGhost3
                        CMP R1, UP
                        CALL.Z VerificaCimaGhost3
                        CMP R1,RIGHT
                        CALL.Z VerificaDireitaGhost3
                        CMP R1,LEFT
                        CALL.Z VerificaEsquerdaGhost3
                   
                        POP R2
                        POP R1
                        RET

MovimentaBaixoGhost3:PUSH R1
                     PUSH R2

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost3]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1

                     INC M[YGhost3]
                     MOV R1,M[PosGhost3]
                     ADD R1,81d
                     MOV M[PosGhost3],R1

                     MOV R1, M[YGhost3] 
                     MOV R2, M[XGhost3]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaCimaGhost3: PUSH R1
                     PUSH R2

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost3]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1

                     DEC M[YGhost3]
                     MOV R1,M[PosGhost3]
                     SUB R1,81d
                     MOV M[PosGhost3],R1

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaDireitaGhost3:PUSH R1
                       PUSH R2

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]

                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost3]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1                     

                     INC M[XGhost3]
                     MOV R1,M[PosGhost3]
                     ADD R1,1d
                     MOV M[PosGhost3],R1

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

MovimentaEsquerdaGhost3:PUSH R1
                        PUSH R2

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]

                     SHL R1, 8d ;Escrever na tela espaço ou comida
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R2,M[PosGhost3]
                     MOV R1,M[R2]
                     MOV M[IO_WRITE],R1                                  

                     DEC M[XGhost3]
                     MOV R1,M[PosGhost3]
                     DEC R1
                     MOV M[PosGhost3],R1

                     MOV R1, M[YGhost3]
                     MOV R2, M[XGhost3]
                     SHL R1, 8d
                     OR R1,R2                  
                     MOV M[CURSOR], R1
                     MOV R1,'V'
                     MOV M[IO_WRITE],R1

                     POP R2
                     POP R1
                     RET

VerificaBaixoGhost3:PUSH R1
                   PUSH R2
                  
                   MOV R1, M[PosGhost3]
                   ADD R1, 81d
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost3
                   POP R2
                   POP R1
                   RET 

VerificaCimaGhost3:PUSH R1
                   PUSH R2
                   MOV R1, M[PosGhost3]
                   SUB R1, 81d
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost3
                   POP R2
                   POP R1
                   RET 

VerificaDireitaGhost3:PUSH R1
                   PUSH R2
                  
                   MOV R1, M[PosGhost3]
                   INC R1
                   MOV R1, M[R1]
                   CMP R1,'#'
                   CALL.Z ParedeGhost3
                   POP R2
                   POP R1
                   RET 

VerificaEsquerdaGhost3:PUSH R1
                       PUSH R2
                  
                       MOV R1, M[PosGhost3]
                       DEC R1
                       MOV R1, M[R1]
                       CMP R1,'#'
                       CALL.Z ParedeGhost3
                       POP R2
                       POP R1
                       RET 


ParedeGhost3:   PUSH R5 
                MOV R5, STOP
                MOV M[DirecaoGhost3],R5 
                CALL Random3
                CALL VerificaMovimentoGhost3
                POP R5
                RET

;------------------------------------------------------------------------------
; GhostAI3
; Função para perseguir o Pacman
;------------------------------------------------------------------------------
GhostAI3:         PUSH R1
                  PUSH R2
                  PUSH R3
                  PUSH R4

                  ; Obter posições atuais
                  MOV R1, M[XGhost3]      ; Fantasma X
                  MOV R2, M[PacmanNovoX]  ; Pacman X
                  MOV R3, M[YGhost3]      ; Fantasma Y
                  MOV R4, M[PacmanNovoY]  ; Pacman Y

                  ; Calcular diferenças
                  SUB R2, R1  ; R2 =  (PacmanX - GhostX)
                  SUB R4, R3  ; R4 =  (PacmanY - GhostY)

                  ; Prioridade para movimento horizontal
                  CMP R2, 0
                  JMP.Z CheckVertical3  ; Se  = 0, verifica vertical
                  JMP.P TryRight3       ; Se  > 0, tenta direita
                  JMP TryLeft3          ; Se  < 0, tenta esquerda

CheckVertical3:   CMP R4, 0
                  JMP.Z EndGhostAI3     ; Se  também = 0, não move
                  JMP.P TryDown3        ; Se  > 0, tenta baixo
                  JMP TryUp3           ; Se  < 0, tenta cima

TryRight3:       MOV R1, RIGHT
                 MOV M[DirecaoGhost3], R1
                 CALL VerificaMovimentoGhost3
                 MOV R1, M[DirecaoGhost3]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI3
                 JMP CheckVertical3     ; Se não pode ir para direita, tenta vertical

TryLeft3:        MOV R1, LEFT
                 MOV M[DirecaoGhost3], R1
                 CALL VerificaMovimentoGhost3
                 MOV R1, M[DirecaoGhost3]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI3
                 JMP CheckVertical3     ; Se não pode ir para esquerda, tenta vertical

TryDown3:        MOV R1, DOWN
                 MOV M[DirecaoGhost2], R1
                 CALL VerificaMovimentoGhost3
                 MOV R1, M[DirecaoGhost3]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI3
                 JMP TryRight3         ; Se não pode ir para baixo, tenta direita

TryUp3:          MOV R1, UP
                 MOV M[DirecaoGhost3], R1
                 CALL VerificaMovimentoGhost3
                 MOV R1, M[DirecaoGhost3]
                 CMP R1, STOP
                 JMP.NZ EndGhostAI3
                 JMP TryLeft3           ; Se não pode ir para cima, tenta esquerda

EndGhostAI3:     POP R4
                 POP R3
                 POP R2
                 POP R1
                 RET


;------------------------------------------------------------------------------
;Random Fantasma 3 (Gerar número aleatório)
;------------------------------------------------------------------------------
Random3:        PUSH    R1
                PUSH    R2
                MOV     R1, LSB_MASK
                AND     R1, M[Random_var]
                BR.Z    RandomDirection3
                MOV     R1, RND_MASK
                XOR     M[Random_var], R1

RandomDirection3:     ROR     M[Random_var], 1
                     
                MOV     R2, 4d
                MOV     R1, M[ Random_var]
                DIV     R1, R2                  ;Dividir por 4, para cada direção (up, down, left, right)
                MOV     M[ DirecaoGhost3 ], R2  ;O resto da divisão é um valor entre 0 e 3

                POP     R2
                POP     R1
                RET








;------------------------------------------------------------------------------
; Função print string
;------------------------------------------------------------------------------
PrintarMapa:PUSH    R1
            PUSH    R2
            PUSH    R3

            MOV     R1, L1
            MOV M[ TextIndex ], R1

            While:MOV R1, M[ TextIndex ]
                  MOV   R2, M[ RowIndex ]
                  MOV   R3, M[ ColumnIndex ]
                  SHL   R2, 8d
                  MOV	R1, M[ R1 ]
                  OR    R2, R3
                  MOV   M[ CURSOR ], R2
                                
                  CMP   R1, FIM_TEXTO
                  JMP.Z EndWhile
                  CMP   R1, FIM_MAPA
                  JMP.Z FimPrintMapa
                  MOV   M[ IO_WRITE ], R1 
                                
                  INC	M[ ColumnIndex ]
                  INC	M[ TextIndex ]

                  JMP   While 

           EndWhile:MOV     R1, 0d
                    INC     M[ RowIndex ]
                    INC     M[ TextIndex ]
                    MOV     M[ ColumnIndex ], R1
                    JMP     While

FimPrintMapa:   MOV     R1, 99d 
                MOV     M[ ColumnIndex ], R1
                POP     R3
                POP     R2
                POP     R1
                RET

PrintPontos:PUSH R1
            PUSH R2
            PUSH R3 
            PUSH R4

            MOV   R1, M[ Centena ]
            MOV   R2, M[ linha_Pontos ]
            MOV   R3, M[ coluna_Pontos ]
            SHL   R2, 8d
            OR    R2, R3
            MOV   M[ CURSOR ], R2
            MOV   M[ IO_WRITE ], R1 

            MOV R4, M[coluna_Pontos]
            INC R4

            MOV   R1, M[ Dezena ]
            MOV   R2, M[linha_Pontos]
            MOV   R3, R4
            SHL   R2, 8d
            OR    R2, R3
            MOV   M[ CURSOR ], R2
            MOV   M[ IO_WRITE ], R1 

            INC R4

            MOV   R1, M[ Unidade ]
            MOV   R2, M[linha_Pontos]
            MOV   R3, R4
            SHL   R2, 8d
            OR    R2, R3
            MOV   M[ CURSOR ], R2
            MOV   M[ IO_WRITE ], R1 

            POP R4
            POP R3 
            POP R2
            POP R1
            RET

;------------------------------------------------------------------------------
; Função para configurar o timer
;------------------------------------------------------------------------------

Configura_Timer:  PUSH R1
                  PUSH R2

                  MOV R1,5d
                  MOV M[TIMER_UNITS], R1
                  MOV R1, ON
                  MOV M[ACTIVATE_TIMER], R1

                  POP R2
                  POP R1
                  RET

;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:           ENI
                MOV     R1, INITIAL_SP
                MOV     SP, R1        
                MOV     R1, CURSOR_INIT
                MOV     M[ CURSOR ], R1

                CALL PrintarMapa

                ; --- Inicialização Fantasma 1 ---
                MOV R1, M[XGhost1]
                MOV R2, M[YGhost1]
                MOV R3, 81d
                MUL R2, R3
                ADD R3, R1
                MOV R1, L1
                ADD R1, R3
                MOV M[PosGhost1], R1

                ; Desenha Ghost1 inicial
                MOV R1, M[YGhost1]
                MOV R2, M[XGhost1]
                SHL R1, 8d
                OR R1, R2
                MOV M[CURSOR], R1
                MOV R1, 'V'
                MOV M[IO_WRITE], R1

                ; --- Inicialização Fantasma 2 ---
                MOV R1, M[XGhost2]          ; Coluna Ghost2
                MOV R2, M[YGhost2]          ; Linha Ghost2
                MOV R3, 81d                 ; Largura do mapa
                MUL R2, R3                  ; Calcula offset Y
                ADD R3, R1                  ; Adiciona offset X
                MOV R1, L1                  ; Endereço base
                ADD R1, R3                  ; Posição final
                MOV M[PosGhost2], R1        ; Salva posição

                ; Desenha Ghost2 inicial
                MOV R1, M[YGhost2]
                MOV R2, M[XGhost2]
                SHL R1, 8d
                OR R1, R2
                MOV M[CURSOR], R1
                MOV R1, 'V'
                MOV M[IO_WRITE], R1

                ; --- Inicialização Fantasma 3 ---
                MOV R1, M[XGhost3]
                MOV R2, M[YGhost3]
                MOV R3, 81d
                MUL R2, R3
                ADD R3, R1
                MOV R1, L1
                ADD R1, R3
                MOV M[PosGhost3], R1

                ; Desenha Ghost3
                MOV R1, M[YGhost3]
                MOV R2, M[XGhost3]
                SHL R1, 8d
                OR R1, R2
                MOV M[CURSOR], R1
                MOV R1, 'X'  ; Caractere diferente
                MOV M[IO_WRITE], R1

                ; Configura o timer
                MOV R1, 5d
                MOV M[TIMER_UNITS], R1
                MOV R1, ON
                MOV M[ACTIVATE_TIMER], R1

Cycle:          BR      Cycle               ; Loop principal
Halt:           BR      Halt