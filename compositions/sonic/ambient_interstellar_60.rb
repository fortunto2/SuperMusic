# Название: Interstellar Ambient
# Стиль: Амбиент, Ханс Циммер, Интерстеллар
# BPM: 60
# Дата создания: 2023-08-15
# 
# Используемые инструменты:
# - :blade (органные аккорды)
# - :hollow (органный бас)
# - :pretty_bell (основная мелодия)
# - :prophet (арпеджио)
# - :beep (тиканье часов)
# - :dark_ambience (нарастания напряжения)
# 
# Эффекты:
# - :reverb (mix: 0.9, room: 0.95)
# - :echo (mix: 0.4, decay: 12)
# - :slicer (для мелодии и нарастаний)
#
# Структура:
# - Минималистичные органные аккорды
# - Выразительная мелодия в стиле Ханса Циммера
# - Характерное тиканье часов (отсылка к фильму)
# - Атмосферные звуки и редкие низкие удары

# Интерстеллар-вдохновленная амбиентная композиция
# В стиле Ханса Циммера - с улучшенным балансом

use_bpm 60

# Основная структура
with_fx :reverb, mix: 0.9, room: 0.95 do
  with_fx :echo, mix: 0.4, decay: 12, phase: 1.5 do
    
    # Органные повторяющиеся аккорды - уменьшаем громкость
    live_loop :organ_pattern do
      use_synth :blade
      use_synth_defaults release: 8, sustain: 4, attack: 0.5
      
      notes = (ring :c4, :c4, :g3, :g3)
      times = (ring 1, 1, 1, 1)
      
      play notes.tick, amp: 0.4  # Уменьшили с 0.6 до 0.4
      sleep times.look
    end
    
    # Минималистичный органный бас - тоже уменьшаем
    live_loop :bass_organ, sync: :organ_pattern do
      use_synth :hollow
      use_synth_defaults release: 6, sustain: 3, attack: 0.5
      
      pattern = (ring :c2, :c2, :g1, :g1)
      sleeps = (ring 2, 2, 2, 2)
      
      play pattern.tick, amp: 0.35  # Уменьшили с 0.5 до 0.35
      sleep sleeps.look
    end
    
    # Добавляем более выразительную мелодию
    live_loop :main_melody, sync: :organ_pattern do
      use_synth :pretty_bell  # Более яркий синтезатор
      notes = (ring :g4, :c5, :e5, :g5, :e5, :c5)
      amps = (ring 0.7, 0.7, 0.8, 0.7, 0.6, 0.7)
      sleeps = (ring 2, 2, 3, 3, 2, 4)
      
      with_fx :slicer, phase: 0.5, mix: 0.2, wave: 1 do
        idx = tick
        play notes[idx], amp: amps[idx], attack: 0.1, sustain: 1, release: sleeps[idx]
        sleep sleeps[idx]
      end
    end
    
    # Медленные арпеджио - делаем более заметными
    live_loop :slow_arps, sync: :organ_pattern do
      use_synth :prophet
      use_synth_defaults cutoff: 85, release: 4, amp: 0.6  # Увеличили громкость и яркость
      
      notes = (scale :c3, :minor, num_octaves: 3)
      
      4.times do
        play notes.choose, pan: (rrand -0.7, 0.7)
        sleep 1
      end
    end
    
    # Нарастающие тиканья часов (характерный звук) - делаем более тихими
    live_loop :clock_ticks, sync: :organ_pattern do
      use_synth :beep
      
      pattern = (ring 1, 0, 1, 0, 1, 0, 1, 0)
      8.times do |i|
        play :e5, release: 0.1, amp: 0.15 * pattern[i]  # Уменьшили с 0.2 до 0.15
        sleep 0.5
      end
    end
    
    # Отдаленный атмосферный шум
    live_loop :atmosphere, sync: :organ_pattern do
      s = (ring :ambi_lunar_land, :ambi_drone, :ambi_glass_hum).tick
      sample s, rate: 0.5, amp: 0.25  # Уменьшили с 0.3 до 0.25
      sleep 16
    end
    
    # Периодические нарастания громкости (tension builder)
    live_loop :tension, sync: :organ_pattern do
      use_synth :dark_ambience
      
      n = (ring :c3, :e3, :g2, :c2).tick
      
      with_fx :slicer, phase: 4, wave: 0, invert_wave: 1 do
        play n, attack: 2, sustain: 6, release: 2, amp: 0.4  # Уменьшили с 0.5 до 0.4
      end
      
      sleep 8
    end
    
    # Редкие низкие удары (как в сцене с волнами)
    live_loop :deep_impact, sync: :organ_pattern do
      sample :bd_boom, rate: 0.5, amp: 0.6  # Уменьшили с 0.7 до 0.6
      sleep 16
      
      sample :bd_boom, rate: 0.4, amp: 0.7  # Уменьшили с 0.9 до 0.7
      sleep 8
    end
  end
end 