[BotW_AspectRatio_Shared]
moduleMatches = 0xD91A406D,0x0F748D9C,0x9A61FF4C,0x8E3324A9,0xD71D859D,0x6FD41A61,0x9A2CA0C7,0x29DBB52A,0xFD091F9F,0xD472D8A5,0x6267BFD0

.origin = codecave

aspectRatio:
.float ($width/$height)

grassCulling: ; The grass is calculated in a weird way, but this fix seems to work. So for safety, only enable it for ultrawide resolutions.
.float (($ultrawideHUDMode != 0)*(($gameWidth/$gameHeight) / ($width/$height))) + (($ultrawideHUDMode == 0)*1.0)


[BotW_AspectRatio_V208]
moduleMatches = 0x6267BFD0

; rodata constants
0x101BF8E8 = .float ($width/$height)
0x1030A57C = .float ($width/$height)
0x1036DD4C = .float ($width/$height)

; 3D Rendering In Inventory (calculated every load)
0x02E2C564 = lis r9, aspectRatio@ha
0x02E2C578 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x0386D01C = lis r28, aspectRatio@ha
0x0386D020 = lfs f12, aspectRatio@l(r28)

; Grass Culling (calculated every frame)
0x035b0a30 = lis r5, grassCulling@ha
0x035b0a38 = lfs f11, grassCulling@l(r5)

; 2nd Type Of Grass Culling (calculated every frame)
; Still kinda unsure how this should be calculated but it works
0x1047BFB8 = .float (($ultrawideHUDMode != 0)*(120*0.5) + (($ultrawideHUDMode == 0)*(120)))



; ------------------------------------------------------------------------------------------
; Camera projection, photo capture and final-color viewport/scissor
.origin = codecave

; CameraPreview
.align 4
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

; CameraAlbumCrop
.align 4
; Album capture correction derives its aspect directly from Graphics.
; Original capture draw takes scale in r6 and offset in r7. Enlarge the
; horizontally squeezed source about its centre; destination viewport clips it.
; Retain the original target dimensions and JPEG encoder. Compendium untouched.
_cameraAlbumDrawScale:
.float (($width / $height) / (1280.0 / 720.0))
.float 1.0

; Offset is in source-image pixels, not normalized texture coordinates.
_cameraAlbumCenterCoefficient:
.float (1.0 - (($width / $height) / (1280.0 / 720.0))) * 0.5
.align 8
_cameraAlbumUnsignedBias:
.int 0x43300000
.int 0x00000000 ; IEEE-754 double 2^52, for unsigned integer conversion

_cameraAlbumCropDraw:
mflr r0
stwu r1, -0x30(r1)
stw r0, 0x34(r1)

lis r12, _cameraCaptureEnabled@ha
lwz r12, _cameraCaptureEnabled@l(r12)
cmpwi r12, 0
beq cameraAlbumNativeDraw
; The original helper uses sampler+0xC4 as source width (clamped to >=1).
lwz r12, 0xC4(r4)
cmpwi r12, 1
bge cameraAlbumWidthValid
li r12, 1
cameraAlbumWidthValid:
stw r12, 0x24(r1)
lis r12, 0x4330
stw r12, 0x20(r1)
lfd f0, 0x20(r1)
lis r12, _cameraAlbumUnsignedBias@ha
lfd f1, _cameraAlbumUnsignedBias@l(r12)
fsub f0, f0, f1
lis r12, _cameraAlbumCenterCoefficient@ha
lfs f1, _cameraAlbumCenterCoefficient@l(r12)
fmuls f0, f0, f1
lfs f1, 0(r7)
fadds f0, f0, f1
stfs f0, 0x10(r1)
lfs f0, 4(r7)
stfs f0, 0x14(r1)

lis r6, _cameraAlbumDrawScale@ha
addi r6, r6, _cameraAlbumDrawScale@l
addi r7, r1, 0x10
; Keep the local offset vector alive throughout the original draw call.
cameraAlbumNativeDraw:
lis r12, 0x03AC
ori r12, r12, 0x5E84
mtctr r12
bctrl
lwz r0, 0x34(r1)
mtlr r0
addi r1, r1, 0x30
blr

; Original: bl 0x03AC5E84 (0x48B7FE01).
; Camera capture path: 854x480 target, before album JPEG encoding.
0x02F46084 = bla _cameraAlbumCropDraw

; CameraCompendiumCrop
.align 4
; Compendium-only call-site correction; native shader parameter retained.
; Keep the game's subject-specific UV crop (r6/r7) unchanged. Adjust the
; draw geometry (r8/r9) to counter aspect compression around image centre.
_cameraCompendiumDrawScale:
.float (($width / $height) / (1280.0 / 720.0))
.float 1.0
_cameraCompendiumCenterCoefficient:
.float (1.0 - (($width / $height) / (1280.0 / 720.0))) * 0.5
.align 8
_cameraCompendiumUnsignedBias:
.int 0x43300000
.int 0x00000000

_cameraCompendiumCropDraw:
mflr r0
stwu r1, -0x40(r1)
stw r0, 0x44(r1)
; Unlike the album helper, this helper consumes f1 as a shader parameter.
stfd f1, 0x30(r1)
lis r12, _cameraCaptureEnabled@ha
lwz r12, _cameraCaptureEnabled@l(r12)
cmpwi r12, 0
beq cameraCompendiumNativeDraw
lwz r12, 0xC4(r4)
cmpwi r12, 1
bge cameraCompendiumWidthValid
li r12, 1
cameraCompendiumWidthValid:
stw r12, 0x24(r1)
lis r12, 0x4330
stw r12, 0x20(r1)
lfd f0, 0x20(r1)
lis r12, _cameraCompendiumUnsignedBias@ha
lfd f1, _cameraCompendiumUnsignedBias@l(r12)
fsub f0, f0, f1
lis r12, _cameraCompendiumCenterCoefficient@ha
lfs f1, _cameraCompendiumCenterCoefficient@l(r12)
fmuls f0, f0, f1
lfs f1, 0(r9)
fadds f0, f0, f1
stfs f0, 0x10(r1)
lfs f0, 4(r9)
stfs f0, 0x14(r1)
lis r8, _cameraCompendiumDrawScale@ha
addi r8, r8, _cameraCompendiumDrawScale@l
addi r9, r1, 0x10
lfd f1, 0x30(r1)
cameraCompendiumNativeDraw:
lis r12, 0x03AC
ori r12, r12, 0x6578
mtctr r12
bctrl
lwz r0, 0x44(r1)
mtlr r0
addi r1, r1, 0x40
blr

; Original: bl 0x03AC6578 (0x48B803B5).
; Subject-specific Compendium capture, separate from the album capture call.
0x02F461C4 = bla _cameraCompendiumCropDraw

; CameraScissor
.align 4
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

[BotW_AspectRatio_V176V192]
moduleMatches = 0xFD091F9F,0xD472D8A5

; rodata constants
0x101BF878 = .float $width/$height
0x1030A3F4 = .float $width/$height
0x1036DBDC = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02E2BFC8 = lis r9, aspectRatio@ha
0x02E2BFDC = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x0386C314 = lis r28, aspectRatio@ha
0x0386C318 = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V160]
moduleMatches = 0x9A2CA0C7

; rodata constants
0x101A8A70 = .float $width/$height
0x102ECF88 = .float $width/$height
0x1034F684 = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02D53CF4 = lis r9, aspectRatio@ha
0x02D53D08 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x0375AFF4 = lis r28, aspectRatio@ha
0x0375AFF8 = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V144]
moduleMatches = 0x9A2CA0C7

; rodata constants
0x101A8A70 = .float $width/$height
0x102ECFD0 = .float $width/$height
0x1034F6CC = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02D53CF4 = lis r9, aspectRatio@ha
0x02D53D08 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x0375B128 = lis r28, aspectRatio@ha
0x0375B12C = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V112]
moduleMatches = 0x6FD41A61

; rodata constants
0x1019F9A8 = .float $width/$height
0x102DFB38 = .float $width/$height
0x103414D4 = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02D2F404 = lis r9, aspectRatio@ha
0x02D2F418 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x03726E18 = lis r28, aspectRatio@ha
0x03726E1C = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V97]
moduleMatches = 0xD71D859D

; rodata constants
0x1019F980 = .float $width/$height
0x102DF8A0 = .float $width/$height
0x1034122C = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02D2E65C = lis r9, aspectRatio@ha
0x02D2E670 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x03725CE8 = lis r28, aspectRatio@ha
0x03725CEC = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V80]
moduleMatches = 0x8E3324A9

; rodata constants
0x1019A5A8 = .float $width/$height
0x102D4E30 = .float $width/$height
0x103391B4 = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02D056C8 = lis r9, aspectRatio@ha
0x02D056DC = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x036D0324 = lis r28, aspectRatio@ha
0x036D0328 = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V64]
moduleMatches = 0x9A61FF4C

; rodata constants
0x10198250 = .float $width/$height
0x102CD450 = .float $width/$height
0x1033182C = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02CFD900 = lis r9, aspectRatio@ha
0x02CFD914 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x036AEF04 = lis r28, aspectRatio@ha
0x036AEF08 = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V48]
moduleMatches = 0x0F748D9C

; rodata constants
0x10197FC0 = .float $width/$height
0x102CCFC8 = .float $width/$height
0x103313A4 = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02CFC2CC = lis r9, aspectRatio@ha
0x02CFC2E0 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x036AD81C = lis r28, aspectRatio@ha
0x036AD820 = lfs f12, aspectRatio@l(r28)

[BotW_AspectRatio_V33]
moduleMatches = 0xD91A406D

; rodata constants
0x10197FC0 = .float $width/$height
0x102CCFC0 = .float $width/$height
0x10331374 = .float $width/$height

; 3D Rendering In Inventory (calculated every load)
0x02CFC260 = lis r9, aspectRatio@ha
0x02CFC274 = lfs f4, aspectRatio@l(r9)

; 3D Rendering (calculated every frame)
0x036AD410 = lis r28, aspectRatio@ha
0x036AD414 = lfs f12, aspectRatio@l(r28)