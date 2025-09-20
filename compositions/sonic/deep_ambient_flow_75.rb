# Название: Deep Ambient Flow
# Стиль: Глубокий эмбиент, дроун
# BPM: 75
# Дата создания: 2023-10-10
# 
# Используемые инструменты:
# - :dsaw (глубокие басы и дроны)
# - :hollow (атмосферные пэды)
# - :growl (текстурные элементы)
# - :cnoise (шумовые текстуры)
# 
# Эффекты:
# - :reverb (mix: 0.85, room: 0.95)
# - :echo (mix: 0.4, decay: 8)
# - :slicer (для пульсации)
# - :lpf (для глубины баса)
#
# Структура:
# - Длинные атмосферные пассажи
# - Глубокие пульсирующие басы
# - Перекрещивающиеся минималистичные ритмы
# - Шумовые текстуры для глубины

# Глубокий эмбиент с 75 BPM
use_bpm 75

# Мастер эффекты для общей атмосферы
with_fx :reverb, mix: 0.85, room: 0.95 do
  with_fx :echo, mix: 0.4, decay: 8, phase: 1.5 do
    
    # Основной дрон
    live_loop :deep_drone do
      use_synth :hollow
      
      root_notes = [:c2, :g1, :a1, :f1]
      
      root_notes.each do |n|
        play n, attack: 6, release: 12, amp: 0.6, cutoff: 80
        sleep 16
      end
    end
    
    # Глубокий пульсирующий бас
    live_loop :deep_bass, sync: :deep_drone do
      with_fx :lpf, cutoff: 65 do
        use_synth :dsaw
        
        bass_notes = [:c1, :g0, :a0, :f0]
        
        bass_notes.each do |n|
          # Создаем пульсацию
          with_fx :slicer, phase: 4, wave: 1, mix: 0.3 do
            play n, attack: 3, sustain: 12, release: 4, amp: 0.8, cutoff: 60
          end
          sleep 16
        end
      end
    end
    
    # Длинные минималистичные ритмы - очень тихие
    live_loop :long_rhythms, sync: :deep_drone do
      if one_in(4)
        sleep 32  # Иногда пропускаем для разнообразия
      else
        32.times do |i|
          # Различные ритмические паттерны, которые появляются и пропадают
          sample :bd_tek, amp: 0.15, rate: 0.6 if i % 16 == 0
          sample :bd_haus, amp: 0.1, rate: 0.7 if i % 8 == 4 and one_in(2)
          
          # Очень редкие хай-хэты
          sample :drum_cymbal_soft, amp: 0.05, rate: 0.8 if i % 4 == 2 and one_in(3)
          
          # Длинные паузы между элементами ритма
          sleep 1
        end
      end
    end
    
    # Медленные гармонические переходы
    live_loop :harmonic_swells, sync: :deep_drone do
      use_synth :growl
      use_synth_defaults attack: 4, sustain: 4, release: 8, amp: 0.4
      
      chords = [
        chord(:c3, :m9),
        chord(:g2, '7sus4'),
        chord(:a2, :m11),
        chord(:f2, :maj9)
      ]
      
      # Случайно выбираем и играем аккорд с большими интервалами между ними
      play chords.choose, cutoff: rrand(70, 90)
      sleep [16, 24, 32].choose
    end
    
    # Атмосферные шумовые текстуры
    live_loop :noise_textures, sync: :deep_drone do
      with_fx :hpf, cutoff: 60 do
        use_synth :cnoise
        
        # Играем шум с различными параметрами
        play 60, attack: 8, sustain: 8, release: 16, cutoff: rrand(60, 90), 
          res: 0.3, amp: 0.2, pan: rrand(-0.7, 0.7)
        
        # Длинные паузы между шумовыми текстурами
        sleep [32, 48, 64].choose
      end
    end
    
    # Редкие мелодические элементы
    live_loop :sparse_melody, sync: :deep_drone do
      use_synth :blade
      use_synth_defaults release: 6, amp: 0.3
      
      # Редкие ноты из минорной пентатоники
      notes = scale(:c3, :minor_pentatonic, num_octaves: 2)
      
      sleep [4, 8, 12].choose # Случайные паузы перед нотами
      
      if one_in(3)
        # Иногда играем несколько нот подряд
        3.times do
          play notes.choose, pan: rrand(-0.5, 0.5)
          sleep [4, 6, 8].choose
        end
      else
        # Иногда только одну ноту
        play notes.choose, pan: rrand(-0.5, 0.5)
        sleep [12, 16, 24].choose
      end
    end
    
    # Очень редкие атмосферные сэмплы
    live_loop :rare_atmospherics, sync: :deep_drone do
      # Выбираем один из атмосферных сэмплов
      sample [:ambi_drone, :ambi_haunted_hum, :ambi_glass_hum, :ambi_dark_woosh].choose,
        rate: rrand(0.4, 0.7), amp: 0.25
      
      # Очень длинные паузы между атмосферными сэмплами
      sleep [48, 64, 96].choose
    end
  end
end 