[BotW_CameraSidePanels_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
_cameraGlyphRight:
.float (360 * $width / $height - 8)
_cameraGlyphLeft:
.float (0 - (360 * $width / $height - 8))
_cameraGlyphWidth:
.float (360 * $width / $height - 656)

_cameraPanelHeader:
.int 0x43504E4C
.int 1
_cameraPanelChanges:
.int 0
_cameraPanelHook:
stwu r1, -0x30(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stw r11, 24(r1)
stw r12, 28(r1)
lis r9, _cameraStyleEnabled@ha
lwz r9, _cameraStyleEnabled@l(r9)
cmpwi r9, 0
bne cameraPanel16Mode
; Cemu mounts content independently of presets. Hide ONLY the fourteen added
; P_C16Slate[L/R]_0[0..6] panes in unchanged-view mode. No native panes
; or native glyphs are modified. Exact names including NUL; no animation
; targets these custom panes, so constructor alpha remains zero.
lwz r9, 0x80(r31)
lis r10, 0x505F
ori r10, r10, 0x4331
cmpw r9, r10
bne cameraPanelExit
lwz r9, 0x84(r31)
lis r10, 0x3653
ori r10, r10, 0x6C61
cmpw r9, r10
bne cameraPanelExit
lhz r9, 0x88(r31)
cmpwi r9, 0x7465
bne cameraPanelExit
lbz r9, 0x8A(r31)
cmpwi r9, 76
beq cameraPanelHideSuffix
cmpwi r9, 82
bne cameraPanelExit
cameraPanelHideSuffix:
lbz r9, 0x8B(r31)
cmpwi r9, 95
bne cameraPanelExit
lbz r9, 0x8C(r31)
cmpwi r9, 48
bne cameraPanelExit
lbz r9, 0x8D(r31)
cmpwi r9, 48
blt cameraPanelExit
cmpwi r9, 54
bgt cameraPanelExit
lbz r9, 0x8E(r31)
cmpwi r9, 0
bne cameraPanelExit
li r9, 0
stw r9, 8(r1)
b cameraPanelExit
cameraPanel16Mode:
lis r10, _cameraUIIsCamera@ha
lwz r9, _cameraUIIsCamera@l(r10)
cmpwi r9, 0
beq cameraPanelExit
lis r10, _cameraLayoutState@ha
lwz r9, _cameraLayoutState@l(r10)
cmpwi r9, 2
bne cameraPanelExit
; Only the native 300x720, alpha-32 decorative text panes.
lwz r9, 8(r1)
cmpwi r9, 32
bne cameraPanelExit
lwz r9, 0x3C(r31)
lis r10, 0x4396
cmpw r9, r10
bne cameraPanelExit
lwz r9, 0x40(r31)
lis r10, 0x4434
cmpw r9, r10
bne cameraPanelExit
; Exact names T_DecoL_00/01 or T_DecoR_00/01, including terminator.
lwz r9, 0x80(r31)
lis r10, 0x545F
ori r10, r10, 0x4465
cmpw r9, r10
bne cameraPanelExit
lhz r9, 0x84(r31)
cmpwi r9, 0x636F
bne cameraPanelExit
lbz r9, 0x87(r31)
cmpwi r9, 95
bne cameraPanelExit
lhz r9, 0x88(r31)
cmpwi r9, 0x3030
beq cameraPanelSuffixValid
cmpwi r9, 0x3031
bne cameraPanelExit
cameraPanelSuffixValid:
lbz r9, 0x8A(r31)
cmpwi r9, 0
bne cameraPanelExit
lbz r12, 0x86(r31)
cmpwi r12, 76
beq cameraPanelLeft
cmpwi r12, 82
bne cameraPanelExit
lwz r9, 0x1C(r31)
lis r10, 0x4422
ori r10, r10, 0xC000
cmpw r9, r10
bne cameraPanelExit
lis r11, _cameraGlyphRight@ha
lwz r11, _cameraGlyphRight@l(r11)
b cameraPanelApply
cameraPanelLeft:
lwz r9, 0x1C(r31)
lis r10, 0xC422
ori r10, r10, 0x4000
cmpw r9, r10
bne cameraPanelExit
lis r11, _cameraGlyphLeft@ha
lwz r11, _cameraGlyphLeft@l(r11)
cameraPanelApply:
stw r11, 0x1C(r31)
lis r9, _cameraGlyphWidth@ha
lwz r9, _cameraGlyphWidth@l(r9)
stw r9, 0x3C(r31)
; Retain native colours/font/animation; modestly increase decorative opacity.
li r9, 80
stw r9, 8(r1)
lis r10, _cameraPanelChanges@ha
lwz r9, _cameraPanelChanges@l(r10)
addi r9, r9, 1
stw r9, _cameraPanelChanges@l(r10)
cameraPanelExit:
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r12, 28(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
; Replay alpha assignment; next native instruction copies same alpha globally.
stb r0, 0x45(r31)
blr
0x03C49810 = bla _cameraPanelHook
