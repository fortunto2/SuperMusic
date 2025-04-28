// "Dark Trap Dreams Fixed" @by rustam

// Установка темпа (90 BPM)
setcps(90/60/2)

// Басовая партия
let bass = stack(
  // Основной бас
  s("bass:1")
    .note("<a1 a1 a1 c2>")
    .gain(1.3)
    .shape(0.4)
    .lpf(sine.range(80, 120).slow(8)),
  
  // Суб-бас
  s("bass:0")
    .note("<a0 ~ c1 g0>")
    .gain(1.5)
    .shape(0.5)
    .lpf(60)
);

// Ударные
let drums = stack(
  // Бочка
  s("bd")
    .struct("t ~ t ~")
    .gain(1.4),
  
  // Снэйр
  s("sd:3")
    .struct("~ t ~ t")
    .gain(0.9)
    .room(0.3),
  
  // Хай-хэты
  s("hh*8")
    .gain(0.7)
    .pan(range(-0.5, 0.5))
);

// Перкуссия и эффекты
let percFx = s("perc:3")
  .struct("~ ~ ~ t")
  .gain(0.7)
  .room(0.4);

// Финальный микс
stack(
  bass,
  drums,
  percFx
)
.out(); 