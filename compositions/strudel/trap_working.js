// "Simple Working Trap" @by rustam

// Установка темпа (90 BPM)
setcps(90/60/2)

// Основная структура
stack(
  // 808 бас
  s("sine")
    .note("<a0 c1 g0 a0>")
    .decay(1.2)
    .sustain(0.2)
    .gain(1.3)
    .shape(0.4),

  // Бочка
  s("bd")
    .gain(1.4)
    .struct("t ~ t ~"),

  // Снэйр
  s("sd")
    .gain(1.0)
    .struct("~ t ~ t"),

  // Хэты
  s("hh*8")
    .gain(0.7)
    .pan(range(-0.5, 0.5))
)
.out(); 