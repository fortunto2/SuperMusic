# Название: Session 03 - Massive Reverb
# Стиль: Эмбиент, космический
# BPM: 80
# Дата создания: 2023-10-25
# 
# Используемые инструменты:
# - :prophet (гладкие пэды)
# - :dtri (мягкие синты)
# - :pretty_bell (колокольчики)
# 
# Эффекты:
# - :reverb (для пространства)
# - :echo (для больших дилеев)
# - :flanger (для текстуры)
# - :slicer (для модуляции)
#
# Структура:
# - Минималистичные мелодические фрагменты
# - Массивные реверберации
# - Длинные эхо-хвосты
# - Медленные модуляции

# Установка спокойного темпа для эмбиентной музыки
use_bpm 80

# Имитация режима "Andromeda" из Valhalla Supermassive
define :massive_reverb do |sound_block|
  with_fx :reverb, mix: 0.9, room: 1, pre_amp: 1.5 do
    with_fx :echo, mix: 0.7, decay: 12, phase: 0.75, max_phase: 4 do
      with_fx :flanger, mix: 0.3, depth: 5, delay: 5, decay: 5 do
        sound_block.call
      end
    end
  end
end

# Имитация режима "Great Annihilator" из Valhalla Supermassive
define :deep_space_echo do |sound_block|
  with_fx :reverb, mix: 0.8, room: 0.95 do
    with_fx :echo, mix: 0.8, decay: 8, phase: 0.5, max_phase: 8 do
      with_fx :distortion, mix: 0.1, distort: 0.1 do
        sound_block.call
      end
    end
  end
end

# Имитация режима "Sagittarius" из Valhalla Supermassive
define :massive_delay do |sound_block|
  with_fx :echo, mix: 0.9, decay: 10, phase: 1, max_phase: 4 do
    with_fx :reverb, mix: 0.6, room: 0.9 do
      with_fx :slicer, mix: 0.2, phase: 4, wave: 1, pulse_width: 0.9 do
        sound_block.call
      end
    end
  end
end

# Ноты для мелодических фрагментов
define :play_sparse_notes do |synth_name|
  use_synth synth_name
  
  notes = (scale :c3, :minor_pentatonic)
  
  # Играем случайную ноту с долгим релизом
  play notes.choose, release: 8, amp: 0.4, cutoff: rrand(60, 90), attack: 0.5
  
  # Длинная пауза между нотами
  sleep [6, 8, 10].choose
end

# Долгие аккорды с медленной атакой
define :play_slow_chords do |synth_name|
  use_synth synth_name
  
  chords = [
    chord(:c3, :minor7),
    chord(:g2, :major7),
    chord(:a2, :minor7),
    chord(:f2, :major7)
  ]
  
  # Играем один долгий аккорд
  play chords.choose, release: 12, amp: 0.3, attack: 2
  
  # Долгая пауза перед следующим аккордом
  sleep 16
end

# Очень тихие мелодические элементы
define :play_quiet_melody do |synth_name|
  use_synth synth_name
  use_synth_defaults release: 4, amp: 0.2
  
  # Выбираем мелодический паттерн
  melody = [:c4, :g3, :c4, :e4, :d4, :g3]
  
  # Играем несколько нот с большими паузами
  2.times do |i|
    play melody[i], pan: rrand(-0.5, 0.5)
    sleep [3, 4, 5].choose
  end
end

# Запускаем композицию с тремя слоями эффектов
# Первый слой - огромный реверб
live_loop :massive_space do
  massive_reverb do
    # Проигрываем редкие ноты на Prophet
    play_sparse_notes :prophet
  end
end

# Второй слой - глубокие эхо
live_loop :deep_echoes, sync: :massive_space do
  deep_space_echo do
    # Долгие аккорды на синте dtri
    play_slow_chords :dtri
  end
end

# Третий слой - длинные дилеи
live_loop :delay_texture, sync: :massive_space do
  massive_delay do
    # Тихие мелодические фрагменты на колокольчиках
    play_quiet_melody :pretty_bell
  end
end

# Добавим атмосферный шум для текстуры
live_loop :atmosphere, sync: :massive_space do
  sample [:ambi_lunar_land, :ambi_choir, :ambi_dark_woosh].choose, 
    rate: rrand(0.3, 0.6), amp: 0.2
  
  sleep [16, 24, 32].choose
end

# Очень редкие и тихие ритмические элементы
live_loop :sparse_beats, sync: :massive_space do
  # Иногда пропускаем цикл для разреженности
  if one_in(3)
    sleep 16
  else
    sleep 4
    
    with_fx :reverb, mix: 0.8, room: 0.9 do
      with_fx :echo, mix: 0.6, decay: 6 do
        sample :bd_tek, amp: 0.15, rate: 0.7
      end
    end
    
    sleep 12
  end
end 