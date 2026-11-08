[BotW_CameraPreview_V208]
moduleMatches = 0x6267BFD0

.origin = codecave

; Camera-only16:9 projection and centered viewport; original controls stay full-width.
; Capture corrections are included in this pack; disable the separate crop pack.
; Mirror the game's IsOpenAppCamera setter without changing its behaviour.
_camera16StateHeader:
.int 0x4331364D
.int 1
.int 40
.int 0x6267BFD0
.int 0x0386D024
.int 0x030C451C
_camera16Active:
.int 0
_camera16Aspect:
.float (1280.0 / 720.0)
_camera16RootImage:
.int 0
_camera16ViewportAdjustments:
.int 0

_cameraViewportX:
.float (640.0 * (1.0 - ((1280.0 / 720.0) / ($width / $height))))
_cameraViewportWidth:
.float (1280.0 * ((1280.0 / 720.0) / ($width / $height)))
_cameraScissorX:
.float lo((640.0 * (1.0 - ((1280.0 / 720.0) / ($width / $height)))) * (($width * 9) > ($height * 16)))
_cameraScissorWidth:
.float (1280 - 2 * lo((640.0 * (1.0 - ((1280.0 / 720.0) / ($width / $height)))) * (($width * 9) > ($height * 16))))

_camera16RecordState:
stwu r1, -0x10(r1)
stw r12, 8(r1)
stw r3, 12(r1)
; Preset zero disables camera-only projection, viewport and heart adjustments.
lis r12, _cameraStyleEnabled@ha
lwz r12, _cameraStyleEnabled@l(r12)
mullw r3, r3, r12
lis r12, _camera16Active@ha
stw r3, _camera16Active@l(r12)
lwz r3, 12(r1)
lwz r12, 8(r1)
addi r1, r1, 0x10
mr r5, r4
; Non-linking entry hook preserves the original caller LR for the tail setter.
b 0x02E19488

_camera16Projection:
stwu r1, -0x20(r1)
stw r12, 8(r1)
stw r0, 0xC(r1)
.int 0x7C000026 ; mfcr r0 (Cemu assembler lacks this mnemonic)
stw r0, 0x10(r1)
lis r12, _camera16Active@ha
lwz r12, _camera16Active@l(r12)
cmpwi r12, 0
beq camera16KeepProjection
lis r12, _cameraLayoutState@ha
lwz r12, _cameraLayoutState@l(r12)
cmpwi r12, 2
bne camera16KeepProjection
lis r12, _camera16Aspect@ha
lfs f12, _camera16Aspect@l(r12)
camera16KeepProjection:
; Original write, after the Graphics pack has selected its aspect ratio.
stfs f12, 0xB4(r30)
lwz r0, 0x10(r1)
.int 0x7C0FF120 ; mtcrf 255,r0 (explicit PowerPC encoding)
lwz r0, 0xC(r1)
lwz r12, 8(r1)
addi r1, r1, 0x20
blr


; Guard resolved viewport arguments and the caller of the viewport helper.
; Root-only GPU stack arguments may change; shared game/input objects untouched.
_camera16DisplayCall:
stwu r1, -0x30(r1)
stw r0, 8(r1)
stw r9, 0xC(r1)
stw r10, 0x10(r1)
stw r11, 0x14(r1)
stw r12, 0x18(r1)
.int 0x7C000026 ; mfcr r0
stw r0, 0x1C(r1)
; Learn the live root COLOR IMAGE identity at frame setup, not object identity.
; Root and final color pass have different framebuffer objects sharing storage.
lwz r9, 0x54(r1)
lis r11, 0x03A1
ori r11, r11, 0x41F8
cmpw r9, r11
bne camera16ColorRootKnown
li r0, 0
lwz r11, 0x1C(r5)
cmpwi r11, 0
beq camera16ColorStoreRoot
lwz r0, 0xE0(r11)
camera16ColorStoreRoot:
lis r12, _camera16RootImage@ha
stw r0, _camera16RootImage@l(r12)
camera16ColorRootKnown:
lis r12, _camera16Active@ha
lwz r11, _camera16Active@l(r12)
cmpwi r11, 0
beq camera16RootLeaveArguments
lis r12, _cameraLayoutState@ha
lwz r11, _cameraLayoutState@l(r12)
cmpwi r11, 2
bne camera16RootLeaveArguments
; Only the observed late color output call and its static alternate branch.
; NOT all aliases: earlier HDR/postprocessing writes remain unchanged.
lis r11, 0x03AA
ori r11, r11, 0xFDB0
cmpw r9, r11
beq camera16ColorCallerSelected
lis r11, 0x03AA
ori r11, r11, 0xFD8C
cmpw r9, r11
bne camera16RootLeaveArguments
camera16ColorCallerSelected:
lwz r11, 0x1C(r5)
cmpwi r11, 0
beq camera16RootLeaveArguments
lwz r0, 0xD0(r11)
cmpwi r0, 0x19
bne camera16RootLeaveArguments
lwz r0, 0xC0(r11)
cmpwi r0, 1280
bne camera16RootLeaveArguments
lwz r0, 0xC4(r11)
cmpwi r0, 720
bne camera16RootLeaveArguments
lwz r0, 0xE0(r11)
lis r12, _camera16RootImage@ha
lwz r9, _camera16RootImage@l(r12)
cmpwi r9, 0
beq camera16RootLeaveArguments
cmpw r0, r9
bne camera16RootLeaveArguments
lwz r9, 0x38(r1)
cmpwi r9, 0
bne camera16RootLeaveArguments
lwz r9, 0x3C(r1)
cmpwi r9, 0
bne camera16RootLeaveArguments
lwz r9, 0x40(r1)
lis r11, 0x44A0
cmpw r9, r11
bne camera16RootLeaveArguments
lwz r9, 0x44(r1)
lis r11, 0x4434
cmpw r9, r11
bne camera16RootLeaveArguments
lis r9, _cameraViewportX@ha
lwz r9, _cameraViewportX@l(r9)
stw r9, 0x38(r1)
lis r9, _cameraViewportWidth@ha
lwz r9, _cameraViewportWidth@l(r9)
stw r9, 0x40(r1)
lis r12, _camera16ViewportAdjustments@ha
lwz r9, _camera16ViewportAdjustments@l(r12)
addi r9, r9, 1
stw r9, _camera16ViewportAdjustments@l(r12)
camera16RootLeaveArguments:
lwz r0, 0x1C(r1)
.int 0x7C0FF120 ; mtcrf 255,r0
lwz r0, 8(r1)
lwz r9, 0xC(r1)
lwz r10, 0x10(r1)
lwz r11, 0x14(r1)
lwz r12, 0x18(r1)
addi r1, r1, 0x30
lfs f1, 8(r1)
blr

; Original mr r5,r4; surrounding setter and callers remain intact.
0x02E19484 = ba _camera16RecordState
; Original stfs f12,0xB4(r30); does not replace Graphics' two instructions.
0x0386D024 = bla _camera16Projection

; Original lfs f1,8(r1), just before platform viewport dispatch.
0x030C451C = bla _camera16DisplayCall
