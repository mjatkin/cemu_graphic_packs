[BotW_KorokChasing_V208]
moduleMatches = 0x6267BFD0

.origin = codecave
; --------------------------
; This set of patches fixes the speed with which hidden Koroks (shown as sparkles on the ground) move along their path
; In unpatched state, the speed would scale directly with FPS, so at 60 FPS the Koroks would move twice as fast

_constFloatTimestepKorok:
.float 30.0

0x0348ba3c = bla _HiddenKorokMoveCalcTimestep
_HiddenKorokMoveCalcTimestep:
; replaced instruction:
; 0348ba3c fdivs f25,f27,f13
; calculates:
; f25 = 1.0 / timeStepInSeconds
; available registers: r4, r12, cr0
;
; This function calculates the velocity that's needed to reach a target position within one frame.
; It's not only used by the hidden Koroks but by many other actors too, including the dragons.
; Dragons move towards a target that's already based on the real timestep, so the fixed 30.0 made them move at 30/FPS of their normal speed.
; So when this was called by the dragon movement function, keep using the original calculation.
lwz r4, 0x00(r1)					; Load the stack frame of 0x0344b168, which called this function...
lwz r4, 0x00(r4)					; ...and from that the stack frame of the function that called 0x0344b168
lwz r4, 0x04(r4)					; Load the address that 0x0344b168 will return to
lis r12, 0x0200						; Load 0x0200FD00 (the return address after the call at 0x0200FCFC in the dragon movement function)...
ori r12, r12, 0xFD00				; ...into r12
cmpw r4, r12
beq _HiddenKorokMoveCalcTimestepDragon
lis r4, _constFloatTimestepKorok@ha
lfs f25, _constFloatTimestepKorok@lo(r4)
blr

_HiddenKorokMoveCalcTimestepDragon:
fdivs f25, f27, f13					; Execute the original instruction
blr

; 0344acd8 ec 0d 58 24     fdivs      f0,f13,f11
; general korok move function? maybe should be patched too?

; Hidden korok rest time is measured in frames. Normally it also counts +1.0 each frame but we use a dynamic timestep instead
0x022ac944 = bla _HiddenKorokRestActionCalcTimestep
_HiddenKorokRestActionCalcTimestep:
; replaced instruction:
; 022ac944 fadds f0,f12,f0
; available registers: r3
lis r3, averageFPS1Inv@ha
lfs f0, averageFPS1Inv@lo(r3)
fadds f0, f12, f0
blr

