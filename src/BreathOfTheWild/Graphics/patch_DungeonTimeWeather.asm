[BotW_DungeonTimeWeather_V208]
moduleMatches = 0x6267BFD0
.origin = codecave
; Keep dungeon clock/weather displacement consistent with the corrected HUD.
; Correct only the native 174-unit movement, around each pane's own base.
_dtwEnabled:
.int (($width/$height) > ($gameWidth/$gameHeight)) * (($ultrawideHUDMode == 1) + ($ultrawideHUDMode == 2))
_dtwRatio:
.float ($gameWidth/$gameHeight)/($width/$height)
_dtwBaseWeather:
.float 0.0
.float 174.0
_dtwBaseTime:
.float 342.0
.float 516.0
_dtwHook:
; Replay native dirty-bit store once; preserve preceding animation hooks.
stb r0, 0x44(r30)
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
lis r10, _dtwEnabled@ha
lwz r9, _dtwEnabled@l(r10)
cmpwi r9, 0
beq dtwExit
cmpwi r27, 0
bne dtwExit
cmpwi r7, 0
bne dtwExit
addi r9, r30, 0x1C
cmpw r9, r29
bne dtwExit
lwz r12, 0x0C(r30)
cmpwi r12, 0
beq dtwExit
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x4E5F
ori r11, r11, 0x416C
cmpw r10, r11
bne dtwExit
lwz r10, 4(r9)
lis r11, 0x6C5F
ori r11, r11, 0x3030
cmpw r10, r11
bne dtwExit
lbz r10, 8(r9)
cmplwi r10, 0
bne dtwExit
lwz r12, 0x0C(r12)
cmpwi r12, 0
beq dtwExit
addi r9, r12, 0x80
lwz r10, 0(r9)
lis r11, 0x526F
ori r11, r11, 0x6F74
cmpw r10, r11
bne dtwExit
lwz r10, 4(r9)
lis r11, 0x5061
ori r11, r11, 0x6E65
cmpw r10, r11
bne dtwExit
lbz r10, 8(r9)
cmplwi r10, 0
bne dtwExit
addi r9, r30, 0x80
lwz r10, 0(r9)
lis r11, 0x5061
ori r11, r11, 0x5F57
cmpw r10, r11
bne dtwTime
lwz r10, 4(r9)
lis r11, 0x6561
ori r11, r11, 0x7468
cmpw r10, r11
bne dtwTime
lwz r10, 8(r9)
lis r11, 0x6572
ori r11, r11, 0x5F30
cmpw r10, r11
bne dtwTime
lhz r10, 12(r9)
cmplwi r10, 12288
bne dtwTime
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne dtwExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 0
bne dtwExit
lbz r10, 2(r9)
cmpwi r10, 2
bne dtwExit
lhz r10, 4(r9)
cmpwi r10, 3
bne dtwExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 4(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 16(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 24(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 28(r9)
lis r11, 0x432E
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 32(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lis r12, _dtwBaseWeather@ha
addi r12, r12, _dtwBaseWeather@l
b dtwApply
dtwTime:
addi r9, r30, 0x80
lwz r10, 0(r9)
lis r11, 0x5061
ori r11, r11, 0x5F54
cmpw r10, r11
bne dtwExit
lwz r10, 4(r9)
lis r11, 0x696D
ori r11, r11, 0x655F
cmpw r10, r11
bne dtwExit
lhz r10, 8(r9)
cmplwi r10, 12336
bne dtwExit
lbz r10, 10(r9)
cmplwi r10, 0
bne dtwExit
mr r9, r31
lwz r10, 0(r9)
lis r11, 0x464C
ori r11, r11, 0x5041
cmpw r10, r11
bne dtwExit
lwz r9, 0(r28)
add r9, r31, r9
lbz r10, 1(r9)
cmpwi r10, 0
bne dtwExit
lbz r10, 2(r9)
cmpwi r10, 2
bne dtwExit
lhz r10, 4(r9)
cmpwi r10, 3
bne dtwExit
lwz r10, 8(r9)
add r9, r9, r10
lwz r10, 0(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 4(r9)
lis r11, 0x43AB
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 8(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 12(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 16(r9)
lis r11, 0x43AB
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 20(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 24(r9)
lis r11, 0x3F80
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 28(r9)
lis r11, 0x4401
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lwz r10, 32(r9)
lis r11, 0x0000
ori r11, r11, 0x0000
cmpw r10, r11
bne dtwExit
lis r12, _dtwBaseTime@ha
addi r12, r12, _dtwBaseTime@l
b dtwApply
dtwApply:
; Unsigned float-bit range guard excludes NaN/Inf/negative inputs.
lwz r9, 0x1C(r30)
lwz r10, 0(r12)
cmplw r9, r10
ble dtwExit
lwz r10, 4(r12)
cmplw r9, r10
bgt dtwExit
lfs f0, 0x1C(r30)
lfs f9, 0(r12)
fsubs f0, f0, f9
lis r10, _dtwRatio@ha
lfs f9, _dtwRatio@l(r10)
fmuls f0, f0, f9
lfs f9, 0(r12)
fadds f0, f0, f9
stfs f0, 0x1C(r30)
dtwExit:
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
blr
0x03C462A4 = bla _dtwHook
