// "Dark Trapper" @by rustam
// Темп 90 BPM
setcps(90/60)

// Загружаем специальные сэмплы
samples({
  '808': {
    'kick': 'https://cdn.freesound.org/previews/448/448003_7732281-lq.mp3',
    'bass': 'https://cdn.freesound.org/previews/319/319434_5436764-lq.mp3',
    'snare': 'https://cdn.freesound.org/previews/387/387186_7255534-lq.mp3',
    'hat': 'https://cdn.freesound.org/previews/315/315837_5436764-lq.mp3'
  }
})

// Вспомогательная функция для распределения параметров по массиву
const split = register('split', (deflt, callback, pat) => 
  callback(deflt.map((d,i) => pat.withValue((v) => 
    Array.isArray(v) ? (i < v.length ? v[i] : d) : (i == 0 ? v : d)
  )))
)

// Основная бас-линия
bass: "<0@2 1@6 0@2 2@6>/16".split([0, 1], (y) => y[0].pickRestart([
  "<a0 [a0 c1] a0 [a0 g0]>/4",
  "<a0(3,8) [c1 a0*2 c1] [d1 d1 d1*2]>/8",
  "<a0 [a0 c1 a0] g0 [a0 c1 g0]>/4"
]).s('808').sound('bass').begin(0).end(0.5).gain(1.3).shape(0.4).room(0.5).velocity(y[1]))

// Ударные - бочка
kicks: "<t(3,8) [t t*2 t] [t*2 t t]>/8"
  .s('808').sound('kick').begin(0.01).end(0.4)
  .gain(1.4).shape(0.2).room(0.1)

// Снэйр
snares: "[~ t ~ t]*2"
  .s('808').sound('snare').begin(0.02).end(0.4)
  .gain(1.0).room(0.3)

// Хай-хэты
hats: "<t*8 [t*4 t(3,8)] t*8 [t*6 t*2]>/4"
  .s('808').sound('hat').begin(0).end(0.15)
  .gain(function(time) { return Math.sin(time * 8) * 0.25 + 0.5; })
  .pan(function(time) { return Math.sin(time * 4) * 0.5; })

// Добавляем простой ритм-секцию для сложности
$: s("<bd(3,8) bd(5,8)>/4").bank("RolandTR707").gain(0.8).room(0.2)
$: s("<~ sd:1 ~ sd:2>*2").bank("RolandTR707").gain(0.7).room(0.3)
$: s("<hh*4 [hh*2 hh(3,8)]>/2").bank("RolandTR707").gain(0.5).room(0.1)

// Простые синтетические стабы
stabs: "<[~ ~ <Am7 Gm7>] ~ ~ <Fm7 Em7>>/8"
  .voicing()
  .note()
  .s('supersaw')
  .attack(0.01)
  .decay(0.3)
  .sustain(0.1)
  .release(0.5)
  .gain(0.6)
  .room(0.7)
  .lpf(sine.range(400, 1200).slow(8)) 