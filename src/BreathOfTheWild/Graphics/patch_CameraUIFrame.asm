[BotW_CameraUIFrame_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
_cameraUIIsCamera:
.int 0
_cameraUIFramePart:
.int 0
_cameraUIRatio:
.float (1280.0/720.0)/($width / $height)
_cameraUIMatteName:
.string "W_Shadow_00"
.align 4
_cameraUIMatteHeight:
.float 720.0
_cameraUIScreenName:
.string "AppCamera_00"
_cameraUIDecoName:
.string "Pa_Deco_00"
.align 4
_cameraUICompare:
lbz r11, 0(r9)
lbz r12, 0(r10)
cmpw r11, r12
bnelr
cmpwi r11, 0
beqlr
addi r9, r9, 1
addi r10, r10, 1
b _cameraUICompare

_cameraUIScreenHook:
stwu r1, -0x60(r1)
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
stfd f9, 48(r1)
mr r9, r24
lis r10, _cameraUIScreenName@ha
addi r10, r10, _cameraUIScreenName@l
bl _cameraUICompare
li r11, 0
bne _cameraUIStoreScreen
lis r11, _cameraStyleEnabled@ha
lwz r11, _cameraStyleEnabled@l(r11)
_cameraUIStoreScreen:
lis r10, _cameraUIIsCamera@ha
stw r11, _cameraUIIsCamera@l(r10)
li r11, 0
lis r10, _cameraUIFramePart@ha
stw r11, _cameraUIFramePart@l(r10)
lfd f0, 40(r1)
lfd f9, 48(r1)
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 16(r1)
.int 0x7C0FF120
lwz r0, 12(r1)
mtlr r0
lwz r0, 8(r1)
addi r1, r1, 0x60
mtctr r12
blr

_cameraUIPaneHook:
stwu r1, -0x60(r1)
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
stfd f9, 48(r1)
bne _cameraUIOriginalFallthrough
; Hook LR is original branch PC+4. Redirect return for original taken branch.
lwz r9, 12(r1)
addi r9, r9, 0x138
stw r9, 12(r1)
_cameraUIOriginalFallthrough:
lis r10, _cameraUIIsCamera@ha
lwz r11, _cameraUIIsCamera@l(r10)
cmpwi r11, 0
beq _cameraUIPaneExit
lis r10, _cameraLayoutState@ha
lwz r11, _cameraLayoutState@l(r10)
cmpwi r11, 2
bne _cameraUIPaneExit
; Leave Pa_ScanningLine_00 at the native/upstream full-width scale.
; Native bars, border artwork and controls now span the full Slate menu.
; Keep ONLY its Pa_Deco_00 glyph subpart at the previous net scale, so
; custom side-glyph placement remains aligned with unchanged Slate textures.
; Do not undo upstream scaling of nested controls: their parent is no longer
; confined. N_ModeCamera_00 / focus / capture guide are not changed here.
addi r9, r31, 0x80
lis r10, _cameraUIDecoName@ha
addi r10, r10, _cameraUIDecoName@l
bl _cameraUICompare
bne _cameraUIPaneExit
lis r10, _cameraUIRatio@ha
lfs f9, _cameraUIRatio@l(r10)
lfs f0, 0x34(r31)
fmuls f0, f0, f9
stfs f0, 0x34(r31)
_cameraUIPaneExit:
lfd f0, 40(r1)
lfd f9, 48(r1)
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 16(r1)
.int 0x7C0FF120
lwz r0, 12(r1)
mtlr r0
lwz r0, 8(r1)
addi r1, r1, 0x60
blr

; Linking hooks return through LR; pane hook replays original conditional flow.
; Follow the Graphics hook; no dependency on any quest or other HUD contribution.
0x03A3EDCC = bla _cameraUIScreenHook
0x03C496C0 = bla _cameraUIPaneHook

; Pane size is assigned AFTER the earlier scale hook. Limit this adjustment
; to AppCamera's original 1280x608 shadow window; never touch the aiming guide.
_cameraUIMatteHook:
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
stfd f10, 40(r1)
; Original assignment is always made, even when guard fails.
stfs f10, 0x40(r31)
lis r10, _cameraUIIsCamera@ha
lwz r9, _cameraUIIsCamera@l(r10)
cmpwi r9, 0
beq _cameraUIMatteExit
lis r10, _cameraLayoutState@ha
lwz r9, _cameraLayoutState@l(r10)
cmpwi r9, 2
bne _cameraUIMatteExit
lwz r9, 0x3C(r31)
lis r10, 0x44A0
cmpw r9, r10
bne _cameraUIMatteExit
lwz r9, 0x40(r31)
lis r10, 0x4418
cmpw r9, r10
bne _cameraUIMatteExit
addi r9, r31, 0x80
lis r10, _cameraUIMatteName@ha
addi r10, r10, _cameraUIMatteName@l
bl _cameraUICompare
bne _cameraUIMatteExit
lis r10, _cameraUIMatteHeight@ha
lfs f10, _cameraUIMatteHeight@l(r10)
stfs f10, 0x40(r31)
_cameraUIMatteExit:
lfd f10, 40(r1)
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
0x03C49808 = bla _cameraUIMatteHook
