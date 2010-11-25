.module BlockMap
Code:

; ==========================================================================
; InitialiseFromLevel
; --------------------------------------------------------------------------
; Initialises the block map from the currently loaded level.
; --------------------------------------------------------------------------
; Destroyed: AF, BC, DE, HL.
; ==========================================================================
IntialiseFromLevel:
	ld hl,(Level.BlockMap)
	ld de,Header
	ld bc,Header.Size
	ldir
	ld (Grid),hl
	ret

; ==========================================================================
; GetBlockFromPoint
; --------------------------------------------------------------------------
; Gets the pointer to a block in the map from coordinates.
; --------------------------------------------------------------------------
; Inputs:    (HL, DE) - Coordinate to retrieve the block for.
; Outputs:   Carry flag set if the point is outside the block map.
;            Carry flag reset and DE pointing to the block map if inside the
;               block map.
; Destroyed: AF, BC, DE, HL.
; ==========================================================================
GetBlockFromPoint:

; --------------------------------------------------------------------------
; Offset X by the origin.
; --------------------------------------------------------------------------

	push de
	ld de,(Origin.X)
	or a
	sbc hl,de
	ex de,hl
	pop hl

; --------------------------------------------------------------------------
; Divide by 1024 (each block is 1024 units wide).
; --------------------------------------------------------------------------

	sra d
	sra d

; --------------------------------------------------------------------------
; Is the column outside the block map?
; --------------------------------------------------------------------------

	ld a,(Width)
	ld e,a
	cp d
	ret c

; --------------------------------------------------------------------------
; Offset Y by the origin.
; --------------------------------------------------------------------------

	ld bc,(Origin.Y)
	or a
	sbc hl,bc

; --------------------------------------------------------------------------
; Divide by 1024 (each block is 1024 units high).
; --------------------------------------------------------------------------

	sra h
	sra h

; --------------------------------------------------------------------------
; Is the row outside the block map?
; --------------------------------------------------------------------------

	ld a,(Height)
	cp h
	ret c
	
; --------------------------------------------------------------------------
; Calculate the index into the block map (row * width + column).
; --------------------------------------------------------------------------

	push de
	call Maths.Mul.U8U8
	pop de
	ld e,d
	ld d,0
	add hl,de

; --------------------------------------------------------------------------
; Each block map entry is 2 bytes long.
; --------------------------------------------------------------------------

	add hl,hl

; --------------------------------------------------------------------------
; Offset by the start of the block map.
; --------------------------------------------------------------------------

	ld de,(Grid)
	add hl,de

; --------------------------------------------------------------------------
; Read the pointer to the block map data.
; --------------------------------------------------------------------------

	ld e,(hl)
	inc hl
	ld d,(hl)

; --------------------------------------------------------------------------
; Clear the carry flag to denote success.
; --------------------------------------------------------------------------

	or a
	ret

.if Options.ReportModuleSizes \ .echoln strformat("BlockMap module: {0:N0} bytes.", $-Code) \ .endif
.endmodule