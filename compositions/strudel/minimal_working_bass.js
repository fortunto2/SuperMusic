// "Minimal Bass Trap" @by rustam
// Simple trap beat that should work in most Strudel environments
setcps(90/60/2)

// Загружаем только 1 сэмпл для минимализма
samples({'808': 'https://cdn.freesound.org/previews/319/319434_5436764-lq.mp3'})

// Бас-линия
bass: note("<a0 c1 g0 a0>")
  .s('808')
  .gain(1.5)
  .shape(0.4)
  .lpf(90)

// Бочка
kick: s("bd")
  .struct("t ~ t ~")
  .gain(1.4)

// Снэйр
snare: s("sd")
  .struct("~ t ~ t")
  .gain(1.0)

// Хай-хэты
hats: s("hh*8")
  .gain(0.6)

// Синтезатор
synth: note(chord("<Am7 Gm7>"))
  .s('sawtooth')
  .struct("~ ~ <t ~> ~")
  .gain(0.7)
  .decay(0.3)
  .sustain(0.1) 