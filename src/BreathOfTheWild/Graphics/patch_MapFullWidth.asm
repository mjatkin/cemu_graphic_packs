[BotW_MapFullWidth_V208]
moduleMatches = 0x6267BFD0
.origin = codecave

; Presentation only; stack on the map-culling correction in Graphics.
; One effective-aspect endpoint feeds animation and shadow. Do not shrink
; native coverage or change minimap endpoints. No presets/resources changed.
_mapFullWidthTarget:
.float $gameHeight * ($width/$height)
_mapFullWidthEnabled:
.int (($width/$height) > ($gameWidth/$gameHeight)) * (($gameHeight * ($width/$height)) > 1500) * (($ultrawideHUDMode == 1) + ($ultrawideHUDMode == 2))

; Runs after the native transform store (and the existing shrine hook).
; r27=target, r7=byte offset, r30=pane, r29=translation base,
; r31=FLPA tag, r28=current track-offset entry. Replay lbz r8,0x44(r30).
; Preserve scratch GPR/CR and both double-precision lanes of f0/f9.
_mapWideAnimationHook:
stwu r1, -0x50(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stw r11, 24(r1)
stw r12, 28(r1)
stfd f0, 32(r1)
stfd f9, 40(r1)
.int 0x100004A0 ; ps_merge10 f0,f0,f0
stfd f0, 48(r1)
.int 0x11294CA0 ; ps_merge10 f9,f9,f9
stfd f9, 56(r1)
lis r10, _mapFullWidthEnabled@ha
lwz r9, _mapFullWidthEnabled@l(r10)
cmpwi r9, 0
beq mapWideExit
cmpwi r27, 8
bne mapWideExit
cmpwi r7, 32
bne mapWideExit
addi r9, r30, 0x1C
cmpw r9, r29
bne mapWideExit
addi r9, r30, 0x80
mapWideTry0:
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4375
cmpw r10, r11
bne mapWideTry1
lwz r10, 4(r9)
lis r11, 0x745F
ori r11, r11, 0x3030
cmpw r10, r11
bne mapWideTry1
lbz r10, 8(r9)
cmplwi r10, 0
bne mapWideTry1
lwz r9, 0x0C(r30)
cmpwi r9, 0
beq mapWideExit
addi r9, r9, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x496E
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x4F75
ori r11, r11, 0x745F
cmpw r10, r11
bne mapWideExit
lhz r10, 8(r9)
cmplwi r10, 12336
bne mapWideExit
lbz r10, 10(r9)
cmplwi r10, 0
bne mapWideExit
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne mapWideExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 8
bne mapWideExit
lbz r10, 2(r9)
cmpwi r10, 2
bne mapWideExit
lhz r10, 4(r9)
cmpwi r10, 2
bne mapWideExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapWideExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 16(r9)
lis r11, 0x4326
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lis r12, _mapWideFactors0@ha
addi r12, r12, _mapWideFactors0@l
b mapWideApply
mapWideTry1:
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4361
cmpw r10, r11
bne mapWideTry2
lwz r10, 4(r9)
lis r11, 0x7074
ori r11, r11, 0x7572
cmpw r10, r11
bne mapWideTry2
lwz r10, 8(r9)
lis r11, 0x655F
ori r11, r11, 0x3030
cmpw r10, r11
bne mapWideTry2
lbz r10, 12(r9)
cmplwi r10, 0
bne mapWideTry2
lwz r9, 0x0C(r30)
cmpwi r9, 0
beq mapWideExit
addi r9, r9, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4375
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x745F
ori r11, r11, 0x3030
cmpw r10, r11
bne mapWideExit
lbz r10, 8(r9)
cmplwi r10, 0
bne mapWideExit
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne mapWideExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 8
bne mapWideExit
lbz r10, 2(r9)
cmpwi r10, 2
bne mapWideExit
lhz r10, 4(r9)
cmpwi r10, 3
bne mapWideExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapWideExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 16(r9)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapWideExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 24(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 28(r9)
lis r11, 0x4340
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 32(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lis r12, _mapWideFactors1@ha
addi r12, r12, _mapWideFactors1@l
b mapWideApply
mapWideTry2:
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4375
cmpw r10, r11
bne mapWideTry3
lwz r10, 4(r9)
lis r11, 0x745F
ori r11, r11, 0x3031
cmpw r10, r11
bne mapWideTry3
lbz r10, 8(r9)
cmplwi r10, 0
bne mapWideTry3
lwz r9, 0x0C(r30)
cmpwi r9, 0
beq mapWideExit
addi r9, r9, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x496E
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x4F75
ori r11, r11, 0x745F
cmpw r10, r11
bne mapWideExit
lhz r10, 8(r9)
cmplwi r10, 12336
bne mapWideExit
lbz r10, 10(r9)
cmplwi r10, 0
bne mapWideExit
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne mapWideExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 8
bne mapWideExit
lbz r10, 2(r9)
cmpwi r10, 2
bne mapWideExit
lhz r10, 4(r9)
cmpwi r10, 2
bne mapWideExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapWideExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 16(r9)
lis r11, 0x4352
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lis r12, _mapWideFactors2@ha
addi r12, r12, _mapWideFactors2@l
b mapWideApply
mapWideTry3:
lwz r10, 0(r9)
lis r11, 0x505F
ori r11, r11, 0x4D61
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x7043
ori r11, r11, 0x6170
cmpw r10, r11
bne mapWideExit
lwz r10, 8(r9)
lis r11, 0x7475
ori r11, r11, 0x7265
cmpw r10, r11
bne mapWideExit
lwz r10, 12(r9)
lis r11, 0x5F30
ori r11, r11, 0x3000
cmpw r10, r11
bne mapWideExit
lwz r9, 0x0C(r30)
cmpwi r9, 0
beq mapWideExit
addi r9, r9, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4375
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x745F
ori r11, r11, 0x3031
cmpw r10, r11
bne mapWideExit
lbz r10, 8(r9)
cmplwi r10, 0
bne mapWideExit
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne mapWideExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 8
bne mapWideExit
lbz r10, 2(r9)
cmpwi r10, 2
bne mapWideExit
lhz r10, 4(r9)
cmpwi r10, 3
bne mapWideExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 4(r9)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapWideExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 16(r9)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapWideExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 24(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 28(r9)
lis r11, 0x4340
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lwz r10, 32(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne mapWideExit
lis r12, _mapWideFactors3@ha
addi r12, r12, _mapWideFactors3@l
b mapWideApply
mapWideApply:
; Native interpolator already wrote the width; do not modify f1 or any key data.
lwz r9, 0x3C(r30)
lwz r10, 0(r12)
cmplw r9, r10
ble mapWideExit
lis r10, 0x44BB
ori r10, r10, 0x8000
cmplw r9, r10
bgt mapWideExit
beq mapWideFullEndpoint
; Compute (T-m)/(1500-m) from the one shared endpoint, then remap
; w' = m + (w-m)*factor. SP+64 holds a temporary factor, not global state.
lis r10, _mapFullWidthTarget@ha
lfs f0, _mapFullWidthTarget@l(r10)
lfs f9, 0(r12)
fsubs f0, f0, f9
lfs f9, 4(r12)
fdivs f0, f0, f9
stfs f0, 64(r1)
lfs f0, 0x3C(r30)
lfs f9, 0(r12)
fsubs f0, f0, f9
lfs f9, 64(r1)
fmuls f0, f0, f9
lfs f9, 0(r12)
fadds f0, f0, f9
stfs f0, 0x3C(r30)
b mapWideExit
mapWideFullEndpoint:
; Store the exact shared float endpoint, avoiding accumulated rounding.
lis r10, _mapFullWidthTarget@ha
lwz r9, _mapFullWidthTarget@l(r10)
stw r9, 0x3C(r30)
mapWideExit:
lfd f0, 48(r1)
.int 0x10000420 ; ps_merge00 f0,f0,f0
lfd f9, 56(r1)
.int 0x11294C20 ; ps_merge00 f9,f9,f9
lfd f0, 32(r1)
lfd f9, 40(r1)
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r12, 28(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x50
; Preserve original instruction and the adjacent shrine hook.
lbz r8, 0x44(r30)
blr
0x03C4629C = bla _mapWideAnimationHook
_mapWideFactors0:
.float 166.0
.float 1334.0
_mapWideFactors1:
.float 192.0
.float 1308.0
_mapWideFactors2:
.float 210.0
.float 1290.0
_mapWideFactors3:
.float 192.0
.float 1308.0

; Shadow size is assigned after the early Graphics pane hook. Adjust it here,
; after native size initialization, scoped by existing Graphics screen context.
; No private recorder/cached pane pointer. Reuse the same-pack screen strings
; and comparison helper. Context timing/nested construction needs validation.
; Preserve all scratch state; replay ori r0,r0,0x10 on every path.
_mapFullWidthShadow:
stwu r1, -0x30(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r5, 16(r1)
stw r9, 20(r1)
stw r10, 24(r1)
stw r11, 28(r1)
stw r12, 32(r1)
mflr r0
stw r0, 36(r1)
lis r10, _mapFullWidthEnabled@ha
lwz r9, _mapFullWidthEnabled@l(r10)
cmpwi r9, 0
beq mapShadowExit
lis r5, copyScreenString@ha
addi r5, r5, copyScreenString@l
lis r10, scr_AppMap_00@ha
addi r10, r10, scr_AppMap_00@l
bla _compareString
bne mapShadowExit
addi r9, r31, 0x80
lwz r10, 0(r9)
lis r11, 0x575F
ori r11, r11, 0x5368
cmpw r10, r11
bne mapShadowExit
lwz r10, 4(r9)
lis r11, 0x6164
ori r11, r11, 0x6F77
cmpw r10, r11
bne mapShadowExit
lwz r10, 8(r9)
lis r11, 0x5F30
ori r11, r11, 0x3000
cmpw r10, r11
bne mapShadowExit
lwz r10, 0x3C(r31)
lis r11, 0x44BB
ori r11, r11, 0x8000
cmpw r10, r11
bne mapShadowExit
lwz r10, 0x40(r31)
lis r11, 0x4418
cmpw r10, r11
bne mapShadowExit
lwz r10, 0x34(r31)
lis r11, 0x3F80
cmpw r10, r11
bne mapShadowExit
lwz r10, 0x38(r31)
cmpw r10, r11
bne mapShadowExit
lis r10, _mapFullWidthTarget@ha
lwz r9, _mapFullWidthTarget@l(r10)
stw r9, 0x3C(r31)
mapShadowExit:
lwz r0, 36(r1)
mtlr r0
lwz r5, 16(r1)
lwz r9, 20(r1)
lwz r10, 24(r1)
lwz r11, 28(r1)
lwz r12, 32(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
ori r0, r0, 0x10
blr
0x03C49854 = bla _mapFullWidthShadow
