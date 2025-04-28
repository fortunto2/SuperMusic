// Title: Simple Trap Beat
// Style: Trap, Hip-hop
// BPM: 90
// Created: 2023-08-20

// Set BPM to 90
setcps(90/60/2)

// Main beat pattern
stack(
  // Bass pattern
  s("bass:1")
    .n("a1")
    .gain(1.3),
  
  // Kick drum pattern
  s("bd")
    .every(4, fast(2))
    .gain(1.2),
  
  // Snare pattern
  s("sd")
    .struct("~ t")
    .gain(0.9),
  
  // Hi-hat pattern
  s("hh*8")
    .gain(0.7)
)
.out() 