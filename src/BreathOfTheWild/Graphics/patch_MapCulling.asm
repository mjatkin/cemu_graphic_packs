[BotW_MapCulling_V208]
moduleMatches = 0x6267BFD0

.origin = codecave

; Full-map culling must cover the horizontal region exposed by the Graphics
; aspect correction. Minimap, native/narrower aspects and disabled HUD fixes
; retain their original bounds. No map geometry or global dimensions change.
; Native MapMgr+0x640 owns full-map/minimap state. Read it after confirming
; manager identity; do not mirror it in a separate hook or retain pointers.
; Native setter 0x02EA8DC0 stores r4 here before the GUI position hook runs.
_mapCullFactor:
.float ($width/$height)/($gameWidth/$gameHeight)
_mapCullEnabled:
.int (($width/$height) > ($gameWidth/$gameHeight)) * (($ultrawideHUDMode == 1) + ($ultrawideHUDMode == 2))

; Late visibility: r29 manager component, native width at caller SP+0x60.
; Preserve scratch GPRs/CR and both Espresso FPR lanes; replay lwz r3,0(r29).
; Explicit ps_merge encodings (not supported as pack-assembler mnemonics).
; Secondary lanes are saved as doubles to avoid narrowing their payload.
_mapCullSize:
stwu r1, -0x40(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stw r11, 24(r1)
stfd f0, 32(r1)
stfd f1, 40(r1)
.int 0x100004A0 ; ps_merge10 f0,f0,f0
stfd f0, 48(r1)
.int 0x10210CA0 ; ps_merge10 f1,f1,f1
stfd f1, 56(r1)
lis r10, _mapCullEnabled@ha
lwz r9, _mapCullEnabled@l(r10)
cmpwi r9, 0
beq mapCullExit
; Only the active singleton's tile manager, not another renderer/context.
lis r10, 0x1047
lwz r10, -0x6708(r10)
cmpwi r10, 0
beq mapCullExit
lwz r9, 0(r29)
cmpw r9, r10
bne mapCullExit
lwz r9, 0x640(r10)
cmpwi r9, 1
bne mapCullExit
; Require the native base dimensions; adjust only the fresh local width.
lis r10, 0x1053
lwz r9, -0x43B4(r10)
lis r0, 0x44A0
cmpw r9, r0
bne mapCullExit
lwz r9, -0x43B0(r10)
lis r0, 0x4434
cmpw r9, r0
bne mapCullExit
; Positive finite width below 524288; excludes zero/negative/NaN/Inf.
lwz r9, 0xA0(r1)
cmplwi r9, 0
beq mapCullExit
lis r10, 0x4900
cmplw r9, r10
bge mapCullExit
lfs f0, 0xA0(r1)
lis r11, _mapCullFactor@ha
lfs f1, _mapCullFactor@l(r11)
fmuls f0, f0, f1
stfs f0, 0xA0(r1)
mapCullExit:
lfd f0, 48(r1)
.int 0x10000420 ; ps_merge00 f0,f0,f0
lfd f1, 56(r1)
.int 0x10210C20 ; ps_merge00 f1,f1,f1
lfd f0, 32(r1)
lfd f1, 40(r1)
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x40
lwz r3, 0(r29)
blr
; Earlier eligibility pass: fresh width at SP+0x58, manager component in r30.
_mapCullLoadSize:
stwu r1, -0x40(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stw r11, 24(r1)
stfd f0, 32(r1)
stfd f1, 40(r1)
.int 0x100004A0 ; ps_merge10 f0,f0,f0
stfd f0, 48(r1)
.int 0x10210CA0 ; ps_merge10 f1,f1,f1
stfd f1, 56(r1)
lis r10, _mapCullEnabled@ha
lwz r9, _mapCullEnabled@l(r10)
cmpwi r9, 0
beq mapCullLoadExit
; Only the active singleton's tile manager, not another renderer/context.
lis r10, 0x1047
lwz r10, -0x6708(r10)
cmpwi r10, 0
beq mapCullLoadExit
lwz r9, 0(r30)
cmpw r9, r10
bne mapCullLoadExit
lwz r9, 0x640(r10)
cmpwi r9, 1
bne mapCullLoadExit
; Require the native base dimensions; adjust only the fresh local width.
lis r10, 0x1053
lwz r9, -0x43B4(r10)
lis r0, 0x44A0
cmpw r9, r0
bne mapCullLoadExit
lwz r9, -0x43B0(r10)
lis r0, 0x4434
cmpw r9, r0
bne mapCullLoadExit
; Positive finite width below 524288; excludes zero/negative/NaN/Inf.
lwz r9, 0x98(r1)
cmplwi r9, 0
beq mapCullLoadExit
lis r10, 0x4900
cmplw r9, r10
bge mapCullLoadExit
lfs f0, 0x98(r1)
lis r11, _mapCullFactor@ha
lfs f1, _mapCullFactor@l(r11)
fmuls f0, f0, f1
stfs f0, 0x98(r1)
mapCullLoadExit:
lfd f0, 48(r1)
.int 0x10000420 ; ps_merge00 f0,f0,f0
lfd f1, 56(r1)
.int 0x10210C20 ; ps_merge00 f1,f1,f1
lfd f0, 32(r1)
lfd f1, 40(r1)
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x40
lwz r3, 0(r30)
blr
0x02EFA710 = bla _mapCullSize
0x02EFA058 = bla _mapCullLoadSize

; Full-map labels use the rectangular path (not the minimap circle).
; Preserve native height/center and the original f12 load on every path.
_mapLabelRectHook:
; Replay original native half-width load before guarded scaling.
lfs f12, -0x658C(r7)
stwu r1, -0x30(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stfd f0, 24(r1)
.int 0x100004A0 ; ps_merge10 f0,f0,f0
stfd f0, 32(r1)
lis r10, _mapCullEnabled@ha
lwz r9, _mapCullEnabled@l(r10)
cmpwi r9, 0
beq mapLabelRectExit
cmpwi r31, 0
beq mapLabelRectExit
lis r10, 0x1047
lwz r9, -0x6708(r10)
cmpw r9, r31
bne mapLabelRectExit
lwz r9, 0x640(r31)
cmpwi r9, 1
bne mapLabelRectExit
; Require unchanged native width constant 740.0.
lwz r9, -0x658C(r7)
lis r10, 0x4439
cmpw r9, r10
bne mapLabelRectExit
lis r10, _mapCullFactor@ha
lfs f0, _mapCullFactor@l(r10)
fmuls f12, f12, f0
mapLabelRectExit:
lfd f0, 32(r1)
.int 0x10000420 ; ps_merge00 f0,f0,f0
lfd f0, 24(r1)
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
blr
0x02EA3FA8 = bla _mapLabelRectHook

; Crossing-edge fallback: early native five-point test found no point in tile.
; Corner/centre sampling alone misses overlapping rectangles when neither
; contains the other's sampled points. Test interval overlap in both passes;
; widening visibility alone cannot recover a tile rejected for eligibility.
; r10 = current tile; r25 = tile array; r26 = native transformed corners.
; Only zero-rotation full map. Retain original corner path for other contexts.
_mapCullCrossEarly:
stwu r1, -0x30(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stw r11, 24(r1)
stw r12, 28(r1)
mflr r0
stw r0, 32(r1)
lis r11, _mapCullEnabled@ha
lwz r9, _mapCullEnabled@l(r11)
cmpwi r9, 0
beq mapCullCrossEarlyExit
lis r11, 0x1047
lwz r11, -0x6708(r11)
cmpwi r11, 0
beq mapCullCrossEarlyExit
lwz r12, -0x14(r25)
cmpw r12, r11
bne mapCullCrossEarlyExit
lwz r12, 0x640(r11)
cmpwi r12, 1
bne mapCullCrossEarlyExit
; Native full-map rotation must be +0 or -0; do not alter rotated minimaps.
lwz r12, 0x664(r11)
rlwinm r12, r12, 0, 1, 31
cmpwi r12, 0
bne mapCullCrossEarlyExit
; Match the existing width hooks' native-dimension guard.
lis r12, 0x1053
lwz r9, -0x43B4(r12)
lis r0, 0x44A0
cmpw r9, r0
bne mapCullCrossEarlyExit
lwz r9, -0x43B0(r12)
lis r0, 0x4434
cmpw r9, r0
bne mapCullCrossEarlyExit
lwz r9, 0(r26)
lwz r11, 16(r26)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossEarlyExit
cmpwi r12, 0
bge mapCullCrossEarlyExit
lwz r9, 4(r26)
lwz r11, 20(r26)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossEarlyExit
cmpwi r12, 0
bge mapCullCrossEarlyExit
lwz r9, 8(r10)
lwz r11, 16(r26)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossEarlyExit
cmpwi r12, 0
bgt mapCullCrossEarlyExit
lwz r9, 16(r10)
lwz r11, 0(r26)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossEarlyExit
cmpwi r12, 0
blt mapCullCrossEarlyExit
lwz r9, 12(r10)
lwz r11, 20(r26)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossEarlyExit
cmpwi r12, 0
bgt mapCullCrossEarlyExit
lwz r9, 20(r10)
lwz r11, 4(r26)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossEarlyExit
cmpwi r12, 0
blt mapCullCrossEarlyExit
lwz r0, 32(r1)
mtlr r0
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r12, 28(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
b 0x02EFA2B8
mapCullCrossEarlyExit:
lwz r0, 32(r1)
mtlr r0
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r12, 28(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
li r5, 8
blr
0x02EFA300 = bla _mapCullCrossEarly

; Crossing-edge fallback: late native five-point test found no point in tile.
; Reuse native transformed corners and branch to native visibility acceptance;
; non-overlaps and unsupported contexts continue the original corner tests.
; r10 = current tile; r26 = tile array; r27 = native transformed corners.
; Only zero-rotation full map. Retain original corner path for other contexts.
_mapCullCrossLate:
stwu r1, -0x30(r1)
stw r0, 8(r1)
.int 0x7C000026
stw r0, 12(r1)
stw r9, 16(r1)
stw r10, 20(r1)
stw r11, 24(r1)
stw r12, 28(r1)
mflr r0
stw r0, 32(r1)
lis r11, _mapCullEnabled@ha
lwz r9, _mapCullEnabled@l(r11)
cmpwi r9, 0
beq mapCullCrossLateExit
lis r11, 0x1047
lwz r11, -0x6708(r11)
cmpwi r11, 0
beq mapCullCrossLateExit
lwz r12, -0x14(r26)
cmpw r12, r11
bne mapCullCrossLateExit
lwz r12, 0x640(r11)
cmpwi r12, 1
bne mapCullCrossLateExit
; Native full-map rotation must be +0 or -0; do not alter rotated minimaps.
lwz r12, 0x664(r11)
rlwinm r12, r12, 0, 1, 31
cmpwi r12, 0
bne mapCullCrossLateExit
; Match the existing width hooks' native-dimension guard.
lis r12, 0x1053
lwz r9, -0x43B4(r12)
lis r0, 0x44A0
cmpw r9, r0
bne mapCullCrossLateExit
lwz r9, -0x43B0(r12)
lis r0, 0x4434
cmpw r9, r0
bne mapCullCrossLateExit
lwz r9, 0(r27)
lwz r11, 16(r27)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossLateExit
cmpwi r12, 0
bge mapCullCrossLateExit
lwz r9, 4(r27)
lwz r11, 20(r27)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossLateExit
cmpwi r12, 0
bge mapCullCrossLateExit
lwz r9, 8(r10)
lwz r11, 16(r27)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossLateExit
cmpwi r12, 0
bgt mapCullCrossLateExit
lwz r9, 16(r10)
lwz r11, 0(r27)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossLateExit
cmpwi r12, 0
blt mapCullCrossLateExit
lwz r9, 12(r10)
lwz r11, 20(r27)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossLateExit
cmpwi r12, 0
bgt mapCullCrossLateExit
lwz r9, 20(r10)
lwz r11, 4(r27)
bl mapCullCompareFinite
cmpwi r12, 2
beq mapCullCrossLateExit
cmpwi r12, 0
blt mapCullCrossLateExit
lwz r0, 32(r1)
mtlr r0
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r12, 28(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
b 0x02EFA9C4
mapCullCrossLateExit:
lwz r0, 32(r1)
mtlr r0
lwz r9, 16(r1)
lwz r10, 20(r1)
lwz r11, 24(r1)
lwz r12, 28(r1)
lwz r0, 12(r1)
.int 0x7C0FF120
lwz r0, 8(r1)
addi r1, r1, 0x30
li r5, 8
blr
0x02EFAA14 = bla _mapCullCrossLate

; Compare finite float bit patterns without touching ANY FPR/FPSCR state.
; Inputs r9/r11; output r12=-1/0/+1, or 2 for NaN/Inf. Clobbers r0/r9/r11/CR0.
; Canonicalize signed zero, then map IEEE floats to unsigned ordered keys.
mapCullCompareFinite:
lis r12, 0x7F80
rlwinm r0, r9, 0, 1, 31
cmplw r0, r12
bge mapCullCompareInvalid
cmpwi r0, 0
bne mapCullCompareLeftNonzero
li r9, 0
mapCullCompareLeftNonzero:
rlwinm r0, r11, 0, 1, 31
cmplw r0, r12
bge mapCullCompareInvalid
cmpwi r0, 0
bne mapCullCompareRightNonzero
li r11, 0
mapCullCompareRightNonzero:
cmpwi r9, 0
bge mapCullCompareLeftPositive
nor r9, r9, r9
b mapCullCompareLeftReady
mapCullCompareLeftPositive:
xoris r9, r9, 0x8000
mapCullCompareLeftReady:
cmpwi r11, 0
bge mapCullCompareRightPositive
nor r11, r11, r11
b mapCullCompareRightReady
mapCullCompareRightPositive:
xoris r11, r11, 0x8000
mapCullCompareRightReady:
cmplw r9, r11
blt mapCullCompareLess
bgt mapCullCompareGreater
li r12, 0
blr
mapCullCompareLess:
li r12, -1
blr
mapCullCompareGreater:
li r12, 1
blr
mapCullCompareInvalid:
li r12, 2
blr
