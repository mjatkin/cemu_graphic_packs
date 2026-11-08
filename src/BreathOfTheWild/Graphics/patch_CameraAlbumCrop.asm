[BotW_CameraAlbumCapture_V208]
moduleMatches = 0x6267BFD0

.origin = codecave

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
