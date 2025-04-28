// "Dark Trap Dreams" @by rustam

// Устанавливаем темп
setcps(90/60/2)

// Определяем басовые партии
let mainBass = s("bass:1")
  .n("<[a1 a1 a1 c2] [~ a0 a0 ~]>")
  .struct("<[t(3,8)] [t*2 t(3,8)]>")
  .gain(1.3)
  .shape(0.4)
  .lpf(sine.range(80, 120).slow(8))
  .lpq(10)

let subBass = s("bass:0")
  .n("<[a0 ~ ~ c1] [~ ~ g0 ~]>")
  .gain(1.5)
  .shape("<.5 .3 .5 .4>")
  .lpf(60)

// Барабанные партии
let kicks = s("bd")
  .struct("t(3,8,[0 2])")
  .gain(1.4)
  .room(0.1)

let snares = s("sd:3")
  .struct("[~ t]*2")
  .gain(0.9)
  .room(0.3)
  .sometimes(x => x.delay(0.5).delaytime(0.125).delayfeedback(0.4))

// Хай-хэты и перкуссия
let hats = stack(
  s("hh*8").gain("<0.7 0.6 0.7 0.5>").speed("<1 1.1 0.9 1.05>"),
  s("oh").struct("[~ ~ ~ t]*2").gain(0.8)
).room(0.2)

let perc = s("perc:3")
  .struct("<~ ~ ~ t> <t ~ ~ ~>")
  .gain(0.7)
  .speed("<0.9 0.8>")
  .delay(0.5)
  .delaytime(0.125)
  .delayfeedback(0.4)
  .room(0.4)

// Синтезаторные стабы
let synth = s("supersaw")
  .n(note("<Am7 FM7>").add("<0 7 12>").scale("minor"))
  .struct("[~ ~ t ~]*2")
  .sustain(0.1)
  .gain(0.6)
  .room(0.7)
  .cutoff(sine.range(400, 1200).slow(16))

// Применяем эффекты фазировки с помощью разных скоростей
let distBass = mainBass
  .mul(speed("1, <1.005 1.003 1.001>/2"))
  .jux(rev)
  .when("<0!12 1!4>", x => x.ply(2))

// Основной микс
stack(
  // Басовые партии
  distBass,
  subBass.mask("<1!8 0!8 1!16>"),
  
  // Ударные
  kicks,
  snares,
  hats.mask("<1!7 0>"),
  
  // Перкуссия и синт
  perc.mask("<0!12 1!4 0!16 1!8>"),
  synth.mask("<0!16 1!8 0!8>")
)
.out() 