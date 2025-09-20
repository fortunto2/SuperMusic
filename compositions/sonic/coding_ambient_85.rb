# Название: Coding Ambient
# Стиль: Эмбиент, минимализм
# BPM: 85
# Дата создания: 2023-10-05
# 
# Используемые инструменты:
# - :prophet (основные аккорды)
# - :blade (атмосферные пэды)
# - :fm (мелодические ноты)
# - :tb303 (басовая линия)
# 
# Эффекты:
# - :reverb (mix: 0.8, room: 0.9)
# - :echo (mix: 0.3, decay: 6)
# - :bitcrusher (для текстуры)
#
# Структура:
# - Минималистичные глубокие аккорды
# - Медленные мелодические пассажи
# - Атмосферные звуки и пэды
# - Редкие битовые элементы

# Спокойная музыка для кодинга с BPM 85
use_bpm 85

# Общие эффекты реверберации и эхо для создания атмосферы
with_fx :reverb, mix: 0.8, room: 0.9 do
  with_fx :echo, mix: 0.3, decay: 6, phase: 0.75 do
    
    # Глубокие атмосферные аккорды
    live_loop :deep_chords do
      use_synth :prophet
      
      # Прогрессия из 4 аккордов
      chords = [
        chord(:d2, :m9),
        chord(:a1, :m7),
        chord(:f2, :maj7),
        chord(:g2, '7')
      ]
      
      chords.each do |c|
        play c, release: 7.5, attack: 0.5, cutoff: rrand(70, 90), amp: 0.7
        sleep 8
      end
    end
    
    # Атмосферные пэды с долгим релизом
    live_loop :ambient_pads, sync: :deep_chords do
      use_synth :blade
      
      notes = [:d4, :a3, :f3, :g3]
      
      notes.each do |n|
        play n, release: 12, attack: 4, cutoff: 80, amp: 0.5
        sleep 8
      end
    end
    
    # Минималистичная басовая линия
    live_loop :minimal_bass, sync: :deep_chords do
      use_synth :tb303
      use_synth_defaults cutoff: 60, res: 0.2, release: 3.5, amp: 0.6
      
      pattern = [:d1, :r, :a0, :r, :f1, :r, :g1, :r]
      pattern.each do |n|
        play n if n != :r
        sleep 4
      end
    end
    
    # Редкая мелодическая линия
    live_loop :sparse_melody, sync: :deep_chords do
      use_synth :fm
      use_synth_defaults release: 4, amp: 0.4
      
      use_random_seed 1234
      
      notes = scale(:d3, :minor_pentatonic, num_octaves: 2).shuffle
      
      sleep 2 if one_in(3)
      
      4.times do
        play notes.tick, pan: rrand(-0.7, 0.7) if one_in(2)
        sleep [1, 2, 2, 3].choose
      end
    end
    
    # Очень редкие атмосферные звуки
    live_loop :atmosphere, sync: :deep_chords do
      with_fx :bitcrusher, bits: 12, sample_rate: 8000 do
        sample [:ambi_lunar_land, :ambi_dark_woosh, :ambi_choir].choose, 
          rate: rrand(0.5, 0.8), amp: 0.3
      end
      sleep [16, 24, 32].choose
    end
    
    # Минималистичные битовые элементы - очень тихие и редкие
    live_loop :minimal_beats, sync: :deep_chords do
      # Иногда пропускаем весь цикл для создания нерегулярности
      if one_in(3) 
        sleep 16
      else
        16.times do |i|
          sample :bd_haus, amp: 0.3, rate: 0.8 if i % 8 == 0
          sample :sn_dolf, amp: 0.15, rate: 0.7 if i % 8 == 4 and one_in(3)
          sample :drum_cymbal_closed, amp: 0.1, rate: 0.9 if i % 2 == 0 and one_in(2)
          
          sleep 1
        end
      end
    end
  end
end 