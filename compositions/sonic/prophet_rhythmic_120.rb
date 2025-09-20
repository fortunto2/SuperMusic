# Название: Prophet Rhythmic Patterns
# Стиль: Rhythmic, Electronic
# BPM: 120
# Дата создания: 2023-12-11
# 
# Используемые инструменты:
# - :prophet (басовые ноты)
# - :tb303 (мелодический слой)
# - :beep (перкуссионные элементы)
# 
# Эффекты:
# - :reverb (mix: 0.5, room: 0.6)
# - :distortion (distort: 0.3)
# - :bitcrusher (bits: 12, sample_rate: 8000)
#
# Структура:
# - Ритмичный паттерн с нотами D1, G1, A1
# - Пульсирующие элементы и грув
# - Варьирующиеся параметры для создания движения
# - Синхронизированные ритмические слои

# Основные настройки
use_bpm 120

# Переменные для удобного управления
main_amp = 0.65      # Общая громкость (0.0-1.0)
distortion = 0.3     # Искажение (0.0-0.5)
bit_crush = 12       # Биткрашер (8-16)
synth_cutoff = 90    # Срез синтезатора (50-110)
release_short = 0.5  # Короткое время затухания (0.1-1.0)
release_long = 4     # Длинное время затухания (2-8)

# Основной эффект для всех циклов
with_fx :reverb, mix: 0.5, room: 0.6 do
  with_fx :distortion, distort: distortion do
    with_fx :bitcrusher, bits: bit_crush, sample_rate: 8000 do
      
      # Основной ритмический паттерн с D1
      live_loop :rhythmic_d do
        use_synth :prophet
        play :d1, release: release_short, amp: main_amp, 
          cutoff: synth_cutoff + (range -10, 10).tick
        sleep [0.5, 0.25, 0.5, 0.75].ring.look
      end
      
      # Ритмический паттерн с G1
      live_loop :rhythmic_g do
        sync :rhythmic_d
        use_synth :prophet
        sleep 0.75
        play :g1, release: release_short, amp: main_amp * 0.8, 
          cutoff: synth_cutoff, pan: rrand(-0.3, 0.3)
        sleep 1.25
      end
      
      # Длинная нота A1 с сэмплом
      live_loop :long_a do
        sync :rhythmic_d
        sample :loop_garzul, rate: [0.5, 1, 1.5].choose, 
          amp: main_amp * 0.5, beat_stretch: 8
        
        4.times do
          use_synth :tb303
          play :a2, release: release_long, amp: main_amp * 0.4, 
            cutoff: synth_cutoff + rrand(-20, 20), res: 0.7
          sleep 2
        end
      end
      
      # Перкуссионный элемент с :beep
      live_loop :beep_percussion do
        sync :rhythmic_d
        pattern = (ring 1, 0, 0.7, 0, 0.5, 0, 0.7, 0)
        
        8.times do |i|
          use_synth :beep
          play :e4, release: 0.1, amp: pattern[i] * main_amp * 0.4,
            cutoff: 110 if pattern[i] > 0
          sleep 0.25
        end
      end
    end
  end
end 