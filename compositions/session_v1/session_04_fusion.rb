# Название: Session 04 - Fusion
# Стиль: Кинематографический ретровейв с массивными пространствами
# BPM: 82
# Дата создания: 2023-10-28
# 
# Используемые инструменты:
# - :prophet (атмосферные пэды)
# - :dsaw (аналоговые басы)
# - :tb303 (кислотные мелодии)
# - :pretty_bell (эфирные акценты)
# 
# Эффекты:
# - Комбинация массивных реверберов в стиле Supermassive
# - Длинные эхо в стиле Вангелиса
# - Минималистичные ритмы
# - Глубокие текстуры с модуляцией

# Средний темп между двумя композициями
use_bpm 82

####################
# Эффекты из Massive Reverb
####################

# Эффект массивного космического реверба 
define :massive_reverb do |sound_block|
  with_fx :reverb, mix: 0.9, room: 1, pre_amp: 1.5 do
    with_fx :echo, mix: 0.7, decay: 12, phase: 0.75, max_phase: 4 do
      with_fx :flanger, mix: 0.3, depth: 5, delay: 5, decay: 5 do
        sound_block.call
      end
    end
  end
end

# Эффект глубокого эха
define :deep_space_echo do |sound_block|
  with_fx :reverb, mix: 0.8, room: 0.95 do
    with_fx :echo, mix: 0.8, decay: 8, phase: 0.5, max_phase: 8 do
      with_fx :distortion, mix: 0.1, distort: 0.1 do
        sound_block.call
      end
    end
  end
end

# Вангелис-стиль эхо из Bladerunner
define :vangelis_echo do |sound_block|
  with_fx :echo, mix: 0.4, decay: 8, phase: 1 do
    with_fx :reverb, mix: 0.6, room: 0.8 do
      sound_block.call
    end
  end
end

####################
# Музыкальные элементы
####################

# Аналоговые басы из Bladerunner
define :play_analog_bass do
  use_synth :dsaw
  with_fx :lpf, cutoff: 75 do
    play :c2, release: 3.5, sustain: 1, amp: 0.6
    sleep 4
    play :a1, release: 3.5, sustain: 1, amp: 0.6
    sleep 4
    play :f1, release: 3.5, sustain: 1, amp: 0.6
    sleep 4
    play :g1, release: 3.5, sustain: 1, amp: 0.6
    sleep 4
  end
end

# Минималистичный ритм из Bladerunner с модификациями
define :play_minimal_drums do
  if one_in(3)
    # Иногда играем ритм Bladerunner
    sample :bd_tek, amp: 0.7, rate: 0.8
    sleep 1
    sample :drum_cymbal_closed, amp: 0.2, rate: 0.9
    sleep 1
    sample :sn_dolf, amp: 0.5, rate: 0.8
    sleep 1
    sample :drum_cymbal_closed, amp: 0.2, rate: 0.9
    sleep 1
  else
    # В остальное время играем разреженный ритм из Massive Reverb
    sample :bd_tek, amp: 0.7, rate: 0.7
    sleep 2
    with_fx :echo, mix: 0.4, decay: 4 do
      sample :sn_dolf, amp: 0.4, rate: 0.6
    end
    sleep 2
  end
end

# Эмбиентные пэды в стиле Вангелиса
define :play_vangelis_pads do
  use_synth :prophet
  
  # Аккорды в стиле Bladerunner
  vangelis_echo do
    play chord(:c3, :minor7), release: 8, attack: 0.7, amp: 0.4, cutoff: 85
    sleep 4
    play chord(:a2, :minor7), release: 8, attack: 0.7, amp: 0.4, cutoff: 85
    sleep 4
    play chord(:f2, :major7), release: 8, attack: 0.7, amp: 0.4, cutoff: 85
    sleep 4
    play chord(:g2, :dom7), release: 8, attack: 0.7, amp: 0.4, cutoff: 85
    sleep 4
  end
end

# Фрагменты мелодий из TB303
define :play_tb303_fragments do
  use_synth :tb303
  use_synth_defaults cutoff: 80, res: 0.2, release: 1.5, amp: 0.4
  
  # Минорная пентатоника из Bladerunner
  notes = (scale :c3, :minor_pentatonic)
  
  if one_in(2)
    # Иногда играем отдельную ноту
    play notes.choose, cutoff: rrand(60, 90)
    sleep [1.5, 2, 2.5].choose
  else
    # Иногда играем несколько нот подряд
    3.times do
      play notes.choose, cutoff: rrand(60, 100)
      sleep 0.5
    end
    sleep 0.5
  end
end

# Редкие колокольчики с большим ревербом
define :play_bell_accents do
  use_synth :pretty_bell
  use_synth_defaults release: 8, amp: 0.2
  
  notes = (scale :c4, :minor_pentatonic)
  
  # Играем 1 или 2 ноты с разным панорамированием
  1.times do
    play notes.choose, pan: rrand(-0.7, 0.7)
    sleep [2, 3, 4].choose
  end
end

# Атмосферные звуки объединенные из обеих композиций
define :play_atmospherics do
  # Выбираем между звуками из Bladerunner и Massive Reverb
  atmosphere_sample = [:ambi_dark_woosh, :ambi_haunted_hum, :ambi_lunar_land, :ambi_choir].choose
  
  with_fx :reverb, mix: 0.8, room: 0.9 do
    with_fx :distortion, distort: 0.2 do
      sample atmosphere_sample, rate: rrand(0.3, 0.6), amp: 0.3
    end
  end
  
  if one_in(3)
    # Иногда добавляем эффект винилового шума
    with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
      sample :vinyl_hiss, rate: 0.7, amp: 0.15
    end
  end
end

####################
# Запуск музыкальных циклов
####################

# Общий эффект для всей композиции - смесь из обеих сессий
with_fx :reverb, mix: 0.4, room: 0.8 do
  with_fx :distortion, distort: 0.05 do
    
    # Глубокий пульсирующий бас
    live_loop :bass_foundation do
      play_analog_bass
    end
    
    # Минималистичный ритм
    live_loop :minimal_rhythm, sync: :bass_foundation do
      play_minimal_drums
    end
    
    # Медленные пэды в стиле Вангелиса в огромном реверб-пространстве
    live_loop :vangelis_atmosphere, sync: :bass_foundation do
      massive_reverb do
        play_vangelis_pads
      end
    end
    
    # TB303 фрагменты с глубоким эхом
    live_loop :tb303_elements, sync: :bass_foundation do
      # Иногда пропускаем для разреженности
      if one_in(3)
        sleep 8
      else
        sleep 2 # Небольшая задержка перед началом
        deep_space_echo do
          play_tb303_fragments
        end
        sleep [2, 4, 6].choose # Случайная пауза после фрагмента
      end
    end
    
    # Колокольчики с массивным ревербом
    live_loop :bell_textures, sync: :bass_foundation do
      # Очень часто пропускаем для редкости звуков
      if one_in(2)
        sleep 8
      else
        massive_reverb do
          play_bell_accents
        end
        sleep [6, 8, 12].choose # Длинные паузы между звуками
      end
    end
    
    # Атмосферные звуки
    live_loop :atmosphere_textures, sync: :bass_foundation do
      play_atmospherics
      sleep [16, 24, 32].choose
    end
    
  end
end 