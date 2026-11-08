[BotW_CameraCompendiumCapture_V208]
moduleMatches = 0x6267BFD0

.origin = codecave

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
