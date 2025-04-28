# Название: Dark Freestyle Trap Beat
# Стиль: Дарк трэп, хип-хоп, фристайл
# BPM: 75
# Дата создания: 2023-08-17
# 
# Используемые инструменты:
# - :tb303 (бас)
# - :prophet (атмосферные пэды)
# - :dsaw (мелодические элементы)
# - Сэмплы ударных (bd_haus, bd_tek, etc.)
# 
# Эффекты:
# - :reverb (mix: 0.4, room: 0.8)
# - :distortion (distort: 0.3)
# - :slicer (для создания ритмического эффекта)
#
# Структура:
# - Тяжелый 808 бас с дисторшном
# - Медленные мрачные пэды и атмосфера
# - Трэповые хай-хэты и сложные ритмы
# - Минималистичная мелодия с темным настроением

use_bpm 75

# Глобальные настройки
set :bar_length, 4

# Шум и атмосфера для создания мрачной атмосферы
with_fx :reverb, mix: 0.7, room: 0.9 do
  live_loop :atmosphere do
    use_synth :prophet
    notes = (ring :g1, :g2, :ds2, :c2)
    with_fx :lpf, cutoff: 80 do
      play notes.tick, attack: 1, release: 8, amp: 0.3
    end
    sleep 8
  end
end

# Основной бит
live_loop :beat do
  stop if get(:stop_loops)
  
  # Основная бочка
  sample :bd_haus, amp: 1.5, rate: 0.7
  sleep 1
  
  # Слабая доля с бочкой и снейром
  sample :bd_tek, amp: 1.0, rate: 0.9
  sample :sn_dolf, amp: 0.8, rate: 0.7
  sleep 1
  
  # Третья доля - только бочка
  sample :bd_haus, amp: 1.5, rate: 0.7
  sleep 0.5
  sample :bd_tek, amp: 0.8, rate: 0.9
  sleep 0.5
  
  # Четвертая доля - слабая с снейром
  sample :sn_dolf, amp: 0.8, rate: 0.7
  sleep 1
end

# 808 бас с дисторшном и тремя разными нотами
with_fx :distortion, distort: 0.3 do
  with_fx :reverb, mix: 0.2, room: 0.3 do
    live_loop :dark_bass, sync: :beat do
      stop if get(:stop_loops)
      
      use_synth :tb303
      use_synth_defaults cutoff: 80, res: 0.2, attack: 0.01, release: 0.8, sustain: 0.2
      
      bass_pattern = (ring :g1, :g1, :ds1, :c1)
      rhythm = (ring 1.5, 0.5, 1, 1)
      
      4.times do
        play bass_pattern.tick, amp: 0.8
        sleep rhythm.look
      end
    end
  end
end

# Трэповые хай-хэты с изменяющимся паттерном
live_loop :hats, sync: :beat do
  stop if get(:stop_loops)
  
  hat_pattern = (ring 
    [1, 0, 0.5, 0, 1, 0, 0.5, 0],
    [1, 0, 0.7, 0, 1, 0, 0.7, 0.2],
    [1, 0.3, 0.5, 0.3, 1, 0, 0.5, 0.3],
    [1, 0, 0.5, 0.3, 1, 0.2, 0.6, 0.2]
  ).tick
  
  8.times do |i|
    sample :drum_cymbal_closed, rate: 1.2, amp: hat_pattern[i] * 0.7 if hat_pattern[i] > 0
    sleep 0.25
  end
end

# Минималистичная мрачная мелодия
with_fx :slicer, phase: 0.5, mix: 0.3, wave: 1 do
  with_fx :reverb, mix: 0.6, room: 0.8, damp: 0.5 do
    live_loop :dark_melody, sync: :beat do
      stop if get(:stop_loops)
      
      use_synth :dsaw
      use_synth_defaults attack: 0.05, release: 0.3, cutoff: 80, amp: 0.5
      
      melody = (ring :g3, :ds4, :g4, :c4, :ds4, :g3, :ds4, :as3)
      sleeps = (ring 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 1.0)
      
      amps = (ring 0.6, 0.5, 0.4, 0.6, 0.5, 0.4, 0.5, 0.6)
      
      # Играем мелодию только в одном из четырех тактов
      if one_in(4)
        8.times do |i|
          play melody[i], amp: amps[i], pan: (range -0.5, 0.5).tick
          sleep sleeps[i]
        end
      else
        sleep 4 # Ждем один такт
      end
    end
  end
end

# Периодический 808 том для создания драматизма
live_loop :toms, sync: :beat do
  stop if get(:stop_loops)
  
  sleep 4 # Пропускаем один такт
  
  if one_in(2) # 50% шанс исполнения
    2.times do
      sample :drum_tom_lo_soft, amp: 0.7, rate: 0.6
      sleep 0.25
      sample :drum_tom_mid_soft, amp: 0.5, rate: 0.7
      sleep 0.25
    end
    sleep 3 # Оставшееся время такта
  else
    sleep 4 # Пропускаем еще один такт
  end
end 