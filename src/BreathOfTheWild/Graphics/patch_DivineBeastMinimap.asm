[BotW_DivineBeastMinimapEdge_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
; Keep the Divine Beast minimap aligned with Edge HUD.
; Match only its native X animation; no dependency on other map patches.
; Visible subtree lies under N_Born_00's existing aspect correction.
; Preserve X=0 full-map endpoint and DeviceSize parent's independent offsets.
; Do not move offscreen capture-source panes without evidence they need it.
_dbMiniEnabled:
.int (($ultrawideHUDMode == 1) * (($width/$height) > ($gameWidth/$gameHeight)))
_dbMiniEndpoint:
.float 410.0 + (($gameHeight * ($width/$height) - $gameWidth) / 2)
_dbMiniSlope:
.float (410.0 + (($gameHeight * ($width/$height) - $gameWidth) / 2)) / 410.0
_dbMiniHook:
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
.int 0x100004A0
stfd f0, 48(r1)
.int 0x11294CA0
stfd f9, 56(r1)
lis r10, _dbMiniEnabled@ha
lwz r9, _dbMiniEnabled@l(r10)
cmpwi r9, 0
beq dbMiniExit
cmpwi r27, 0
bne dbMiniExit
cmpwi r7, 0
bne dbMiniExit
addi r9, r30, 0x1C
cmpw r9, r29
bne dbMiniExit
mr r12, r30
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4D69
cmpw r10, r11
bne dbMiniExit
lwz r10, 4(r9)
lis r11, 0x6E69
ori r11, r11, 0x4D61
cmpw r10, r11
bne dbMiniExit
lwz r10, 8(r9)
lis r11, 0x705F
ori r11, r11, 0x3030
cmpw r10, r11
bne dbMiniExit
lbz r10, 12(r9)
cmplwi r10, 0
bne dbMiniExit
lwz r12, 0x0C(r12)
cmpwi r12, 0
beq dbMiniExit
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x4D69
cmpw r10, r11
bne dbMiniExit
lwz r10, 4(r9)
lis r11, 0x6E69
ori r11, r11, 0x4D61
cmpw r10, r11
bne dbMiniExit
lwz r10, 8(r9)
lis r11, 0x7050
ori r11, r11, 0x6F73
cmpw r10, r11
bne dbMiniExit
lwz r10, 12(r9)
lis r11, 0x5F30
ori r11, r11, 0x3000
cmpw r10, r11
bne dbMiniExit
lwz r12, 0x0C(r12)
cmpwi r12, 0
beq dbMiniExit
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x496E
cmpw r10, r11
bne dbMiniExit
lwz r10, 4(r9)
lis r11, 0x4F75
ori r11, r11, 0x745F
cmpw r10, r11
bne dbMiniExit
lhz r10, 8(r9)
cmplwi r10, 12336
bne dbMiniExit
lbz r10, 10(r9)
cmplwi r10, 0
bne dbMiniExit
lwz r12, 0x0C(r12)
cmpwi r12, 0
beq dbMiniExit
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x426F
cmpw r10, r11
bne dbMiniExit
lwz r10, 4(r9)
lis r11, 0x726E
ori r11, r11, 0x5F30
cmpw r10, r11
bne dbMiniExit
lhz r10, 8(r9)
cmplwi r10, 12288
bne dbMiniExit
lwz r12, 0x0C(r12)
cmpwi r12, 0
beq dbMiniExit
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x526F
ori r11, r11, 0x6F74
cmpw r10, r11
bne dbMiniExit
lwz r10, 4(r9)
lis r11, 0x5061
ori r11, r11, 0x6E65
cmpw r10, r11
bne dbMiniExit
lbz r10, 8(r9)
cmplwi r10, 0
bne dbMiniExit
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne dbMiniExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 0
bne dbMiniExit
lbz r10, 2(r9)
cmpwi r10, 2
bne dbMiniExit
lhz r10, 4(r9)
cmpwi r10, 3
bne dbMiniExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 4(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 16(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 24(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 28(r9)
lis r11, 0x43CD
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
lwz r10, 32(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dbMiniExit
; Accept only finite positive native X up to410. Zero/full map untouched.
lwz r9, 0x1C(r30)
cmplwi r9, 0
beq dbMiniExit
lis r10, 0x43CD
cmplw r9, r10
bgt dbMiniExit
beq dbMiniEndpoint
lfs f0, 0x1C(r30)
lis r10, _dbMiniSlope@ha
lfs f9, _dbMiniSlope@l(r10)
fmuls f0, f0, f9
stfs f0, 0x1C(r30)
b dbMiniExit
dbMiniEndpoint:
lis r10, _dbMiniEndpoint@ha
lwz r9, _dbMiniEndpoint@l(r10)
stw r9, 0x1C(r30)
dbMiniExit:
lfd f0, 48(r1)
.int 0x10000420
lfd f9, 56(r1)
.int 0x11294C20
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
; Replay exact original. Does not overlap shrine or map-full-width hooks.
ori r0, r8, 0x10
blr
0x03C462A0 = bla _dbMiniHook
