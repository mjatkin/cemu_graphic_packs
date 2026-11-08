[BotW_CameraHearts_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
.int 0x48313654
.int 1
_heartBuildingMain:
.int 0
_heartMainRoot:
.int 0
_heartPadding:
.float 640.0*(1.0-((1280.0/720.0)/($width / $height)))
_heartForceCount:
.int 0
_heartShiftCount:
.int 0

_heartScreen:
stwu r1, -0x40(r1)
stw r0, 8(r1)
mflr r0
stw r0, 12(r1)
.int 0x7C000026
stw r0, 16(r1)
stw r9, 20(r1)
stw r10, 24(r1)
stw r11, 28(r1)
stw r12, 32(r1)
lis r12, _heartBuildingMain@ha
li r9, 0
stw r9, _heartBuildingMain@l(r12)
lwz r10, 0(r24)
lis r11, 0x4D61
ori r11, r11, 0x696E
cmpw r10, r11
bne heartScreenExit
lwz r10, 4(r24)
lis r11, 0x5363
ori r11, r11, 0x7265
cmpw r10, r11
bne heartScreenExit
lwz r10, 8(r24)
lis r11, 0x656E
ori r11, r11, 0x5F30
cmpw r10, r11
bne heartScreenExit
lbz r10, 12(r24)
cmpwi r10, 48
bne heartScreenExit
lbz r10, 13(r24)
cmpwi r10, 0
bne heartScreenExit
li r9, 1
stw r9, _heartBuildingMain@l(r12)
lis r12, _heartMainRoot@ha
li r9, 0
stw r9, _heartMainRoot@l(r12)
heartScreenExit:
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 16(r1)
.int 0x7C0FF120
lwz r0, 12(r1)
mtlr r0
lwz r0, 8(r1)
addi r1, r1, 0x40
mr r3, r30
blr

_heartCaptureRoot:
stwu r1, -0x40(r1)
stw r0, 8(r1)
mflr r0
stw r0, 12(r1)
.int 0x7C000026
stw r0, 16(r1)
stw r9, 20(r1)
stw r10, 24(r1)
stw r11, 28(r1)
stw r12, 32(r1)
lis r12, _heartBuildingMain@ha
lwz r9, _heartBuildingMain@l(r12)
cmpwi r9, 0
beq heartCaptureExit
lis r12, _heartMainRoot@ha
lwz r9, _heartMainRoot@l(r12)
cmpwi r9, 0
bne heartCaptureExit
addi r9, r31, 0x80
lwz r10, 0(r9)
lis r11, 0x526F
ori r11, r11, 0x6F74
cmpw r10, r11
bne heartCaptureExit
lwz r10, 4(r9)
lis r11, 0x5061
ori r11, r11, 0x6E65
cmpw r10, r11
bne heartCaptureExit
lbz r10, 8(r9)
cmpwi r10, 0
bne heartCaptureExit
stw r31, _heartMainRoot@l(r12)
heartCaptureExit:
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 16(r1)
.int 0x7C0FF120
lwz r0, 12(r1)
mtlr r0
lwz r0, 8(r1)
addi r1, r1, 0x40
lbz r0, 0(r28)
blr

; Current pane only; retained root pointer is compared, never dereferenced.
; Return r9=1 only for N_State_00 -> N_All_00 -> captured MainScreen root.
_heartMatches:
addi r9, r28, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x5374
cmpw r10, r11
bne heartNoMatch
lwz r10, 4(r9)
lis r11, 0x6174
ori r11, r11, 0x655F
cmpw r10, r11
bne heartNoMatch
lbz r10, 8(r9)
cmpwi r10, 48
bne heartNoMatch
lbz r10, 9(r9)
cmpwi r10, 48
bne heartNoMatch
lbz r10, 10(r9)
cmpwi r10, 0
bne heartNoMatch
lwz r12, 0x0C(r28)
cmpwi r12, 0
beq heartNoMatch
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x416C
cmpw r10, r11
bne heartNoMatch
lwz r10, 4(r9)
lis r11, 0x6C5F
ori r11, r11, 0x3030
cmpw r10, r11
bne heartNoMatch
lbz r10, 8(r9)
cmpwi r10, 0
bne heartNoMatch
lwz r9, 0x0C(r12)
cmpwi r9, 0
beq heartNoMatch
lis r10, _heartMainRoot@ha
lwz r11, _heartMainRoot@l(r10)
cmpw r9, r11
bne heartNoMatch
li r9, 1
blr
heartNoMatch:
li r9, 0
blr

_heartForceMatrix:
stwu r1, -0x40(r1)
stw r0, 8(r1)
mflr r0
stw r0, 12(r1)
.int 0x7C000026
stw r0, 16(r1)
stw r9, 20(r1)
stw r10, 24(r1)
stw r11, 28(r1)
stw r12, 32(r1)
; Centered HUD already uses the native inset; only Edge needs cache refresh.
li r9, $ultrawideHUDMode
cmpwi r9, 1
bne heartForceUnmatched
lis r9, _cameraStyleEnabled@ha
lwz r9, _cameraStyleEnabled@l(r9)
cmpwi r9, 0
beq heartForceUnmatched
bl _heartMatches
cmpwi r9, 0
beq heartForceUnmatched
; Force recomputation in BOTH modes, so exit cannot retain a shifted cache.
li r6, 0x10
lis r10, _heartForceCount@ha
lwz r9, _heartForceCount@l(r10)
addi r9, r9, 1
stw r9, _heartForceCount@l(r10)
b heartForceExit
heartForceUnmatched:
lwz r0, 8(r1)
rlwinm r6, r0, 0, 27, 27
heartForceExit:
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 16(r1)
.int 0x7C0FF120
lwz r0, 12(r1)
mtlr r0
lwz r0, 8(r1)
addi r1, r1, 0x40
rlwinm. r6, r6, 0, 27, 27
blr

_heartMatrixX:
stwu r1, -0x40(r1)
stw r0, 8(r1)
mflr r0
stw r0, 12(r1)
.int 0x7C000026
stw r0, 16(r1)
stw r9, 20(r1)
stw r10, 24(r1)
stw r11, 28(r1)
stw r12, 32(r1)
stfd f0, 40(r1)
lfs f29, 0x1C(r28)
lis r10, _camera16Active@ha
lwz r9, _camera16Active@l(r10)
cmpwi r9, 0
beq heartMatrixExit
lis r10, _cameraLayoutState@ha
lwz r9, _cameraLayoutState@l(r10)
cmpwi r9, 2
bne heartMatrixExit
; Remove only the Edge anchoring displacement; preserve native Centered X.
li r9, $ultrawideHUDMode
cmpwi r9, 1
bne heartMatrixExit
bl _heartMatches
cmpwi r9, 0
beq heartMatrixExit
lis r10, _heartPadding@ha
lfs f0, _heartPadding@l(r10)
fadds f29, f29, f0
lis r10, _heartShiftCount@ha
lwz r9, _heartShiftCount@l(r10)
addi r9, r9, 1
stw r9, _heartShiftCount@l(r10)
heartMatrixExit:
lfd f0, 40(r1)
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 16(r1)
.int 0x7C0FF120
lwz r0, 12(r1)
mtlr r0
lwz r0, 8(r1)
addi r1, r1, 0x40
blr

; Follow existing Graphics/quest/UI hooks without replacing them.
0x03A3EDD0 = bla _heartScreen
0x03C4980C = bla _heartCaptureRoot
; Matrix calculation: only force fresh evaluation, adjust temporary X register.
0x03C4A24C = bla _heartForceMatrix
0x03C4A3C0 = bla _heartMatrixX
