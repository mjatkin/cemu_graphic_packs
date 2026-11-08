[BotW_CameraScissor_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
_cameraScissorBounds:
; The existing hook has already guarded camera state, target identity and viewport.
; This runs AFTER viewport dispatch, so only the subsequent scissor sees integers.
stwu r1, -0x30(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
lis r9, _cameraStyleEnabled@ha
lwz r9, _cameraStyleEnabled@l(r9)
cmpwi r9, 0
beq cameraScissorLeave
lwz r9, 0x54(r1)
lis r10, 0x03AA
ori r10, r10, 0xFDB0
cmpw r9, r10
beq cameraScissorCallerSelected
lis r10, 0x03AA
ori r10, r10, 0xFD8C
cmpw r9, r10
bne cameraScissorLeave
cameraScissorCallerSelected:
; Exact adjusted X/Y/width/height signature; inactive/unmodified calls pass through.
lwz r9, 0x38(r1)
lis r10, _cameraViewportX@ha
lwz r10, _cameraViewportX@l(r10)
cmpw r9, r10
bne cameraScissorLeave
lwz r9, 0x3C(r1)
cmpwi r9, 0
bne cameraScissorLeave
lwz r9, 0x40(r1)
lis r10, _cameraViewportWidth@ha
lwz r10, _cameraViewportWidth@l(r10)
cmpw r9, r10
bne cameraScissorLeave
lwz r9, 0x44(r1)
lis r10, 0x4434
cmpw r9, r10
bne cameraScissorLeave
; Symmetric outward integer bounds: floor(left), 1280 - 2*floor(left).
lis r9, _cameraScissorX@ha
lwz r9, _cameraScissorX@l(r9)
stw r9, 0x38(r1)
lis r9, _cameraScissorWidth@ha
lwz r9, _cameraScissorWidth@l(r9)
stw r9, 0x40(r1)
cameraScissorLeave:
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
lfs f2, 0x0C(r1)
blr

0x030C4534 = bla _cameraScissorBounds
