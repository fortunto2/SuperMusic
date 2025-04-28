// "Hardcore Bass Rap" @by rustam
// Based on hardcore trap style with heavy bass
setcps(90/60)

// Загружаем сэмплы 808 и баса
samples({
  'bass': {
    'sub': 'https://cdn.freesound.org/previews/319/319434_5436764-lq.mp3',
    'dist': 'https://cdn.freesound.org/previews/234/234264_4284968-lq.mp3'
  },
  'drums': {
    'kick': 'https://cdn.freesound.org/previews/521/521885_10386209-lq.mp3',
    'snare': 'https://cdn.freesound.org/previews/387/387186_7255534-lq.mp3',
    'hat': 'https://cdn.freesound.org/previews/315/315837_5436764-lq.mp3'
  }
})

// Специальная функция для разделения значений
const split = register('split', (deflt, callback, pat) => 
  callback(deflt.map((d,i) => pat.withValue((v) => 
    Array.isArray(v) ? (i < v.length ? v[i] : d) : (i == 0 ? v : d)
  )))
)

// Основная басовая партия с интенсивными 808
bass: "<0:.7@4 1:.9@4 2@4 3:.6@4>/16".split([0,1], (y) => y[0].pickRestart([
  // Интенсивные низкие ноты
  "<a0 a0 [a0 g0] a0>/4",
  // Более сложная партия с синкопами
  "<[a0@2 c1] [a0 a0*2 c1] [g0*2 a0] [c1 [a0 a0] g0]>/8",
  // Тяжелая ритмическая партия
  "<a0(5,8) g0(3,8) a0(3,8) [c1 a0]>/4",
  // Мелодичная вариация
  "<a0 [c1 g0] [a0 g0] [c1 c1 d1]>/4"
]).s('bass').sound('sub').begin(0).end(0.7).gain(1.5).shape(0.6).lpf(70).velocity(y[1]))

// Второй слой дисторшн-баса
dist: "<~@4 0:.8@2 ~@2 1:.7@4 2:.9@4>/16".split([0,1], (y) => y[0].pickRestart([
  // Короткие акценты на басовой партии
  "<~ [c1*2] ~ [a0 g0]>/4",
  // Чередование с основным басом
  "<~ ~ [a0*3 c1] [c1 g0*2]>/8",
  // Интенсивная вариация
  "<[a0 a0] [c1 c1*3] [g0 g0*2] [a0 c1 a0]>/4"
]).s('bass').sound('dist').begin(0).end(0.4).gain(1.2).shape(0.3).hpf(120).lpf(1000).velocity(y[1]))

// Тяжелая бочка для поддержки баса
kicks: "<t(5,8) [t*2 t t*2] [t*3 t]>/8"
  .s('drums').sound('kick').begin(0.01).end(0.5)
  .gain(1.6).shape(0.2).room(0.1)

// Снэйр с реверберацией для глубины
snares: "[~ t ~ t]*2"
  .s('drums').sound('snare').begin(0).end(0.4)
  .gain(1.1).room(0.4).size(0.6)

// Быстрые хай-хэты для добавления движения
hats: "<t*8 [t*4 t(3,8)] t*16 [t*4 t(5,8)]>/4"
  .s('drums').sound('hat').begin(0).end(0.1)
  .gain(function(time) { return Math.sin(time * 8) * 0.3 + 0.6; })
  .pan(function(time) { return Math.sin(time * 4) * 0.6; })

// Дополнительная ритм-секция для плотности звучания
$: s("<bd(5,8) bd(3,8)>/4").bank("RolandTR909").gain(0.9).shape(0.3)
$: s("<~ sd ~ [sd sd]>*2").bank("RolandTR909").gain(0.8).room(0.3)
$: s("<hh*8 [hh*4 hh(5,8)]>/2").bank("RolandTR909").gain(0.5).pan(perlin)

// Occasional synth stabs
synth: "<~@8 [<Gm7 Am7>]@4 ~@4 [<Fm7 Em7>]@4>/16"
  .voicing()
  .note()
  .s('supersaw')
  .attack(0.01)
  .decay(0.2)
  .sustain(0.1)
  .release(0.3)
  .gain(0.7)
  .cutoff(sine.range(500, 2000).slow(8))
  .room(0.6)
  .size(0.7) 