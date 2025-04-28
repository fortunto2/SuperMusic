// "Phonk Dreams" @by rustam

// Темп 70 BPM (медленно)
setcps(70/60/2)

// Определяем фонк-паттерны
let phonkDist = x => x
  .distort(0.4)
  .shape(0.3)
  .sometimes(y => y.squiz(2))

// Глубокий 808 бас
let phonkBass = s("sine")
  .note("<a0 <a0 c1> g0 <e0 g0>>")
  .decay(2.2)
  .sustain(0.5)
  .attack(0.01)
  .shape(0.5)
  .gain(1.2)
  .lpf(80)
  .lpq(8)
  .struct("<t t ~ t t ~ t ~>")

// Мемфисские кауболлы в фонк-стиле
let cowbells = s("rave:5")
  .gain(0.65)
  .speed("<0.8 0.7 0.75>")
  .room(0.4)
  .struct("<~ t ~ t ~ t ~ t>")
  .n(run(3))
  .delay(0.25)
  .delaytime(0.125)
  .delayfeedback(0.3)

// Бочка с сильной атакой
let kicks = s("bd:0")
  .struct("t ~ ~ t ~ ~ t ~")
  .gain(1.4)
  .speed(0.8)
  .when("<0!7 1>", phonkDist)

// Снэйр с реверсом
let snares = stack(
  s("sd:3").gain(0.8).speed(0.9).room(0.3).struct("~ t ~ t"),
  s("sd:1").gain(0.7).speed(-1).room(0.6).struct("~ <~ t> ~ <t ~>")
).sometimes(x => x.crush(8))

// Типичные для фонка хэты
let hats = stack(
  s("hh*<4!3 8>").gain("<0.6 0.5 0.55>").speed("<1 1.2>"),
  s("oh").struct("[~ ~ ~ <t ~>]").gain(0.6)
).room(0.2)

// Джазовые/соул семплы в фонк-стиле
let jazzVox = s("speech")
  .n("<0 1 2>")
  .begin(sine.range(0, 0.7).slow(8))
  .end(sine.range(0.1, 0.8).slow(8))
  .gain(0.7)
  .speed("<0.8 0.7>")
  .crush(5)
  .mask("<0!16 1!16>")
  .room(0.5)
  .size(0.8)

// Мрачный атмосферный пэд
let darkPad = s("supersaw")
  .note(chord("<Am7 Gm7 Fm7>").voicing().add(-12))
  .gain(0.25)
  .cutoff(300)
  .room(0.9)
  .size(0.9)
  .mask("<0!32 1!16>")

// Основной микс
stack(
  // Бас и ритм-секция
  phonkBass,
  kicks,
  snares,
  
  // Перкуссия и эффекты
  hats.mask("<1!7 0>"),
  cowbells.mask("<0!16 1!16>"),
  
  // Атмосферные элементы
  jazzVox,
  darkPad
)
.out() 