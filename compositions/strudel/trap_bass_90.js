// Title: Dark Trap Beat
// Style: Trap, Hip-hop
// BPM: 90
// Created: 2023-08-20
//
// Instruments:
// - 808 bass
// - Kicks
// - Hi-hats
// - Snares
// - Percussion
//
// Effects:
// - Distortion
// - Reverb
// - Filter

// Set BPM to 90
setcps(90/60/2)

// Main beat pattern
stack(
  // Heavy 808 bass pattern
  s("bass:1")
    .n("<[a1 a1 a1 c2] [~ a0 a0 ~]>")
    .struct("t(3,8)")
    .gain(1.3)
    .lpf(sine.range(80, 120).slow(8))
    .lpq(10)
    .shape(0.3),
  
  // Subby 808 bass
  s("bass:0")
    .n("<[a0 ~ ~ ~] [~ ~ a0 ~]>")
    .gain(1.5)
    .shape(0.5),
  
  // Kick drum pattern
  s("bd")
    .struct("t(3,8,[0 2])")
    .gain(1.4)
    .room(0.1),
  
  // Snare/clap pattern
  s("cp sd:3")
    .struct("[~ t]*2")
    .gain(0.9)
    .room(0.3),
  
  // Hi-hat patterns
  stack(
    s("hh*8").gain("<0.7 0.6 0.7 0.5>"),
    s("oh").struct("[~ ~ ~ t]*2").gain(0.8)
  ).room(0.2),
  
  // Occasional percussion
  s("perc:3")
    .struct("~ ~ ~ t")
    .gain(0.7)
    .speed(0.9)
    .delay(0.5)
    .delaytime(0.125)
    .delayfeedback(0.4)
    .room(0.4),
  
  // Dark synthesizer stabs
  s("supersaw")
    .n(note("<Am7 FM7>").add("<0 7 12>").scale("minor"))
    .struct("[~ ~ t ~]*2")
    .sustain(0.1)
    .gain(0.6)
    .room(0.7)
    .cutoff(sine.range(400, 1200).slow(16))
)
.out() 