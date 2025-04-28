// "Glitch Shadow" @by rustam

samples('github:yaxu/clean-breaks')

// Темп 85 BPM
setcps(85/60/2)

// Определяем функцию рандомного искажения
let glitchify = x => x
  .sometimes(y => y.speed("<2 0.5>"))
  .sometimesBy(0.3, y => y.crush(4))
  .sometimesBy(0.2, y => y.coarse(8))

// Основной 808 бас
let deepBass = s("sine")
  .note("[<a1 a1 a1 c2> <~ a0 ~ ~>]")
  .decay(1.9)
  .sustain(0.3)
  .shape(0.6)
  .gain(1.1)
  .lpf(90)
  .lpq(12)

// Глитчевый бас
let glitchBass = s("bass:1")
  .note("<[a0 c1] [~ g0]>")
  .shape(0.5)
  .struct("<[t*2 t] [t(3,8) t]>")
  .jux(rev)
  .gain(1.2)
  .mul(speed("1, <1.005 1.001>/1.8"))
  .sometimes(x => x.delay(0.25).delaytime(0.125).delayfeedback(0.7))

// Бочка с эффектом сайдчейна
let kicks = s("bd:4")
  .struct("t(3,8,[0 2])")
  .gain(1.5)
  .room(0.1)
  .shape(0.3)

// Глитчевые перкуссии
let perc1 = s("[sd:2, perc:2]")
  .struct("[~ t ~ <t ~>]")
  .gain(0.8)
  .speed("<1 0.8 1.2>")
  .room(0.4)
  .hcutoff(2000)
  .when("<0!7 1>", glitchify)

// Основные хай-хэты
let hats = stack(
  s("hh*<8 16>").gain(0.6).speed("<1 1.5>"),
  s("oh").struct("[~ ~ ~ <t ~>]").gain(0.7).speed(0.9)
).room(0.3)

// Сэмплы с глитч-эффектами
let breaks = s("<breaks:2 breaks:4>")
  .fit(16)
  .splice(8, "[0 <1 2> 3 <4 5> 6 7]")
  .gain(0.7)
  .shape(0.2)
  .mask("<0!8 1!8>")
  .when("<0!7 1>", glitchify)

// Атмосферный пэд
let pad = s("supersaw")
  .note(chord("<Am7 Fm7>").voicing().add("<0 12>"))
  .gain(0.15)
  .room(0.9)
  .size(0.8)
  .lpf(sine.range(300, 1200).slow(12))
  .mask("<0!16 1!16>")

// Основная структура трека
x1: stack(
  // Бас-секция
  deepBass,
  glitchBass.mask("<1!12 0!4>"),
  
  // Ритм-секция
  kicks,
  perc1,
  hats.mask("<1!7 0>"),
  
  // Глитч-элементы и атмосфера
  breaks,
  pad
)
.out() 