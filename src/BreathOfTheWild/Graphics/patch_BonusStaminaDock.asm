[BotW_BonusStaminaDock_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
; Anchor the MainScreen3D bonus stamina dock to Edge/Centered HUD.
; Correct the target and its distance/cache references, not world-following X.
; Native world projection, interpolation, Y, scale and shared globals untouched.
_bsEnabled:
.int (($width/$height) > ($gameWidth/$gameHeight)) * (($ultrawideHUDMode == 1) + ($ultrawideHUDMode == 2))
; Native dock X is -490 for both Y variants. Centered scales around X=0;
; Edge preserves the native 150-unit distance from the left edge (X=-640).
_bsCorrectedX:
.float (($ultrawideHUDMode == 1)*($gameWidth/2)-490.0)*(($gameWidth/$gameHeight)/($width/$height))-($ultrawideHUDMode == 1)*($gameWidth/2)

_bsDistanceX:
; Replay native load (including base update / paired lanes where applicable).
lfs f0, 0x18(r1)
stwu r1, -0x20(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r11, 16(r1)
lis r11, _bsEnabled@ha
lwz r0, _bsEnabled@l(r11)
cmpwi r0, 0
beq _bsDistanceXExit
; Match known native dock pairs; instance scope comes from the hook site.
lis r11, 0x1054
addi r11, r11, 0x1D40
cmpw r3, r11
beq _bsDistanceXPointerOK
addi r11, r11, 8
cmpw r3, r11
bne _bsDistanceXExit
_bsDistanceXPointerOK:
; Require the verified native X=-490 bit pattern; unexpected values pass through.
lwz r0, 0x38(r1)
lis r11, 0xC3F5
cmpw r0, r11
bne _bsDistanceXExit
lis r11, _bsCorrectedX@ha
lfs f0, _bsCorrectedX@l(r11)
_bsDistanceXExit:
lwz r11, 16(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x20
blr

_bsTargetX:
; Replay native load (including base update / paired lanes where applicable).
lwz r9, 0(r3)
stwu r1, -0x20(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r11, 16(r1)
lis r11, _bsEnabled@ha
lwz r0, _bsEnabled@l(r11)
cmpwi r0, 0
beq _bsTargetXExit
; Match known native dock pairs; instance scope comes from the hook site.
lis r11, 0x1054
addi r11, r11, 0x1D40
cmpw r3, r11
beq _bsTargetXPointerOK
addi r11, r11, 8
cmpw r3, r11
bne _bsTargetXExit
_bsTargetXPointerOK:
; Require the verified native X=-490 bit pattern; unexpected values pass through.
lwz r0, 0(r3)
lis r11, 0xC3F5
cmpw r0, r11
bne _bsTargetXExit
lis r11, _bsCorrectedX@ha
lwz r9, _bsCorrectedX@l(r11)
_bsTargetXExit:
lwz r11, 16(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x20
blr

_bsCompare0:
; Replay native load (including base update / paired lanes where applicable).
lfsu f10, 0x1D40(r12)
stwu r1, -0x20(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r11, 16(r1)
lis r11, _bsEnabled@ha
lwz r0, _bsEnabled@l(r11)
cmpwi r0, 0
beq _bsCompare0Exit
; Match known native dock pairs; instance scope comes from the hook site.
lis r11, 0x1054
addi r11, r11, 0x1D40
cmpw r12, r11
beq _bsCompare0PointerOK
addi r11, r11, 8
cmpw r12, r11
bne _bsCompare0Exit
_bsCompare0PointerOK:
; Require the verified native X=-490 bit pattern; unexpected values pass through.
lwz r0, 0(r12)
lis r11, 0xC3F5
cmpw r0, r11
bne _bsCompare0Exit
lis r11, _bsCorrectedX@ha
lfs f10, _bsCorrectedX@l(r11)
_bsCompare0Exit:
lwz r11, 16(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x20
blr

_bsCompare1:
; Replay native load (including base update / paired lanes where applicable).
lfsu f7, 0x1D48(r5)
stwu r1, -0x20(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r11, 16(r1)
lis r11, _bsEnabled@ha
lwz r0, _bsEnabled@l(r11)
cmpwi r0, 0
beq _bsCompare1Exit
; Match known native dock pairs; instance scope comes from the hook site.
lis r11, 0x1054
addi r11, r11, 0x1D40
cmpw r5, r11
beq _bsCompare1PointerOK
addi r11, r11, 8
cmpw r5, r11
bne _bsCompare1Exit
_bsCompare1PointerOK:
; Require the verified native X=-490 bit pattern; unexpected values pass through.
lwz r0, 0(r5)
lis r11, 0xC3F5
cmpw r0, r11
bne _bsCompare1Exit
lis r11, _bsCorrectedX@ha
lfs f7, _bsCorrectedX@l(r11)
_bsCompare1Exit:
lwz r11, 16(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x20
blr

; Four interception points within MainScreen3D bonus placement, not PauseMenu.
; Distance hook is AFTER the two world-following paths join.
0x02FB295C = bla _bsDistanceX
0x02FB29C8 = bla _bsTargetX
0x02FB2AC0 = bla _bsCompare0
0x02FB2AF8 = bla _bsCompare1
