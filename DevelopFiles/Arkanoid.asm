BACKGROUND_ADD0 = $4000
BACKGROUND_MODE = $5107
PLAYERSPRITE = $5000
BALLSPRITE = $5010
INPUT = $5106    
CHR_COL = $5103
PLAYERSPEED = 3
BALLSPEED = 2
JUMPTIME = 30
GRAVITYFORCE = 2
LEFT_LIMIT = 40
RIGHT_LIMIT = 215
PLAYER_DOWN_BASE = 215
.macro div
    LSR
    LSR
    LSR
    LSR
.endmacro
.macro multiplaier num1, num2
    
    LDA num2
    CMP #0
    BEQ endmulonzero
    LDX #0
    mul:
    INX
    CLC
    ADC num1
    CPX num2
    BEQ esc
    JMP mul
    endmulonzero:
    LDA #0
    esc:

.endmacro
.macro multiplaier2 num1, num2
    
    LDA num2
    CMP #0
    BEQ endmulonzero2
    LDX #0
    mul2:
    INX
    CLC
    ADC num1
    CPX num2
    BEQ esc2
    JMP mul2
    endmulonzero2:
    LDA #0
    esc2:

.endmacro
.macro multiplaier3 num1, num2
    
    LDA num2
    CMP #0
    BEQ endmulonzero3
    LDX #0
    mul3:
    INX
    CLC
    ADC num1
    CPX num2
    BEQ esc3
    JMP mul3
    endmulonzero3:
    LDA #0
    esc3:

.endmacro
.macro multiplaier4 num1, num2
    
    LDA num2
    CMP #0
    BEQ endmulonzero4
    LDX #0
    mul4:
    INX
    CLC
    ADC num1
    CPX num2
    BEQ esc4
    JMP mul4
    endmulonzero4:
    LDA #0
    esc4:

.endmacro
.macro key val
    LDA INPUT
    CMP val
    .endmacro
;====



.SEGMENT "CODE"

    LDA #$01
    STA BACKGROUND_MODE

background0:
    LDX #0
    b_loop:
    LDA map0, X
    STA BACKGROUND_ADD0 ,X
    INX
    BNE b_loop

;PlayerPiece0
    LDA #$B6
    STA PLAYERSPRITE
    LDA #101
    STA PLAYERSPRITE+1
    LDA #PLAYER_DOWN_BASE
    STA PLAYERSPRITE+2
    LDA #$09
    STA PLAYERSPRITE+3
;
;PlayerPiece1
    LDA #$B6
    STA PLAYERSPRITE+4
    LDA #117
    STA PLAYERSPRITE+5
    LDA #PLAYER_DOWN_BASE
    STA PLAYERSPRITE+6
    LDA #$09
    STA PLAYERSPRITE+7
;
;PlayerPiece2
    LDA #$B6
    STA PLAYERSPRITE+8
    LDA #133
    STA PLAYERSPRITE+9
    LDA #PLAYER_DOWN_BASE
    STA PLAYERSPRITE+10
    LDA #$09
    STA PLAYERSPRITE+11
;
    LDA #125
    sta centerPosition
;BallInitialize
    LDA #$fF
    STA BALLSPRITE
    LDA #150
    STA BALLSPRITE + 1
    STA BALLSPRITE + 2
    LDA #$01
    STA BALLSPRITE + 3
;

    LDA #0
    STA directionBool
    LDA #1
    STA directionBool + 1

gameLoop:
    JMP gameLoop


vblank:

;==key==
    key #04
    BEQ MoveRight
    key #08
    BEQ MoveLeft
    JMP endMove
;==key==

;==moving==
    MoveLeft:
        LDA centerPosition
        CMP #LEFT_LIMIT
        BMI setOnLeft

        LDA centerPosition
        SEC
        SBC #PLAYERSPEED
        STA centerPosition
        JMP noMoveLeft

        setOnLeft:
        LDA #LEFT_LIMIT
        STA centerPosition

        noMoveLeft:
        JMP endMove
    MoveRight:
        LDA centerPosition
        CMP #RIGHT_LIMIT
        BPL setOnRight

        LDA centerPosition
        CLC
        ADC #PLAYERSPEED
        STA centerPosition
        JMP noMoveRight

        setOnRight:
        LDA #RIGHT_LIMIT
        STA centerPosition

        noMoveRight:
        JMP endMove
    endMove:

    sum_in_x:
        LDA directionBool
        CMP #0
        BNE endSumInX
        LDA BALLSPRITE + 1
        CLC
        ADC #BALLSPEED
        STA BALLSPRITE + 1
        endSumInX:
    sub_in_x:
        LDA directionBool
        CMP #1
        BNE endSubInX
        LDA BALLSPRITE + 1
        SEC
        SBC #BALLSPEED
        STA BALLSPRITE + 1
        endSubInX:
    sum_in_y:
        LDA directionBool + 1
        CMP #0
        BNE endSumInY
        LDA BALLSPRITE + 2
        CLC
        ADC #BALLSPEED
        STA BALLSPRITE + 2
        endSumInY:
    sub_in_y:
        LDA directionBool + 1
        CMP #1
        BNE endSubInY
        LDA BALLSPRITE + 2
        SEC
        SBC #BALLSPEED
        STA BALLSPRITE + 2
        endSubInY:


;==moving==

;==sync==
    LDA centerPosition
    SEC
    SBC #24
    STA PLAYERSPRITE+1

    LDA centerPosition
    SEC
    SBC #8
    STA PLAYERSPRITE+5

    LDA centerPosition
    CLC
    ADC #8
    STA PLAYERSPRITE+9
;==sync==


;==collision==
    LDA BALLSPRITE + 3
    CMP #0
    BNE collisionDown
    LDA #1
    STA canCollide
    collisionDown:
        lda canCollide
        CMP #1
        BEQ endCollisionDown
        LDA BALLSPRITE + 1
        CLC
        ADC #4
        div
        STA ppositionx
        LDA BALLSPRITE + 2
        CLC
        ADC #9
        div
        STA ppositiony
        multiplaier #15 , ppositiony
        CLC
        ADC ppositionx
        TAX
        LDA BACKGROUND_ADD0 , X
        CMP #251
        BPL Destroy
        JMP collideObstacle
        collideObstacle:
        CMP #37
        BEQ invertDirection
        JMP endCollisionDown
        Destroy:
        LDA #0
        STA BALLSPRITE + 3
        JMP endCollisionDown
        invertDirection:
        LDA #1
        STA directionBool + 1
        LDA #144
        STA BACKGROUND_ADD0 , X
        endCollisionDown:

    collisionUp:
        lda canCollide
        CMP #1
        BEQ endCollisionUp
        LDA BALLSPRITE + 1
        CLC
        ADC #4
        div
        STA ppositionx
        LDA BALLSPRITE + 2
        SEC
        SBC #0
        div
        STA ppositiony
        multiplaier2 #15 , ppositiony
        CLC
        ADC ppositionx
        TAX
        LDA BACKGROUND_ADD0 , X
        CMP #6
        BEQ collideUP
        LDA BACKGROUND_ADD0 , X
        CMP #37
        BNE endCollisionUp

        lda #144
        sta BACKGROUND_ADD0 , X

        collideUP:
        LDA #0
        STA directionBool + 1

        endCollisionUp:
    collisionRight:
        lda canCollide
        CMP #1
        BEQ endCollisionRight
        LDA BALLSPRITE + 1
        CLC
        ADC #8
        div
        STA ppositionx
        LDA BALLSPRITE + 2
        CLC
        ADC #4
        div
        STA ppositiony
        multiplaier3 #15 , ppositiony
        CLC
        ADC ppositionx
        TAX
        LDA BACKGROUND_ADD0 , X
        CMP #6
        BEQ collideRight

        lda BACKGROUND_ADD0 , X
        CMP #37
        BNE endCollisionRight
        LDA #144
        STA BACKGROUND_ADD0 , X

        collideRight:
        LDA #1
        STA directionBool


        endCollisionRight:
    collisionLeft:
        lda canCollide
        CMP #1
        BEQ endCollisionLeft
        LDA BALLSPRITE + 1
        SEC
        SBC #1
        div
        STA ppositionx
        LDA BALLSPRITE + 2
        CLC
        ADC #4
        div
        STA ppositiony
        multiplaier4 #15 , ppositiony
        CLC
        ADC ppositionx
        TAX
        LDA BACKGROUND_ADD0 , X
        CMP #6
        BEQ collideLeft

        lda BACKGROUND_ADD0 , X
        CMP #37
        BNE endCollisionLeft
        LDA #144
        STA BACKGROUND_ADD0 , X

        collideLeft:
        LDA #0
        STA directionBool

        endCollisionLeft:
    ballCollision:
        LDA BALLSPRITE + 2
        CLC
        ADC #4
        CMP #PLAYER_DOWN_BASE
        BPL leftMirroring
        JMP noMirror
        leftMirroring:
        LDA BALLSPRITE + 1
        CLC
        ADC #4
        CMP PLAYERSPRITE + 1
        BPL rightMirroring
        JMP noMirror
        rightMirroring:
        LDA PLAYERSPRITE + 9
        CLC
        ADC #4
        CMP BALLSPRITE + 1
        BPL mirror
        JMP noMirror
        mirror:
        LDA #1
        STA directionBool + 1
        noMirror:
;==collison==
end:
    RTI

map0:
    .byte 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,37,144,37,144,37,144,37,144,37,144,37,144,144,6
    .byte 6,144,144,37,144,37,144,37,144,37,144,37,144,37,144,6
    .byte 6,144,37,144,37,144,37,144,37,144,37,144,37,144,144,6
    .byte 6,144,144,37,144,37,144,37,144,37,144,37,144,37,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,144,144,144,144,144,144,144,144,144,144,144,144,144,144,6
    .byte 6,251,251,251,251,251,251,251,251,251,251,251,251,251,251,6

.segment "VECTORS"
.word vblank

.segment "RAM"
ppositionx:
    .byte 0
ppositiony:
    .byte 0
directionBool:
    .byte 0,0 ; On order: left_and_right, down_and_up
centerPosition:
    .byte 0
canCollide:
    .byte 0