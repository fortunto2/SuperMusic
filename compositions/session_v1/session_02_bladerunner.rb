# Название: Session 02 - Bladerunner
# Стиль: Ретровейв, синтвейв, мрачный эмбиент
# BPM: 85
# Дата создания: 2023-10-22
# 
# Используемые инструменты:
# - :dsaw (аналоговые басы)
# - :prophet (эмбиент пэды)
# - :tb303 (мелодии)
# - Ретро-ударные
# 
# Структура:
# - Минималистичный медленный ритм
# - Глубокие аналоговые басы
# - Атмосферные пэды
# - Эмбиентные текстуры в стиле Вангелиса

# Установка медленного темпа для ретровейв-атмосферы
use_bpm 85

# Функция для игры текущего типа ритма
define :play_rhythm do |type|
  case type
  when :basic
    sample :bd_tek, amp: 0.8
    sleep 1
    sample :sn_dolf, amp: 0.6
    sleep 1
    sample :bd_tek, amp: 0.8
    sleep 1
    sample :sn_dolf, amp: 0.6
    sleep 1
  when :breakbeat
    sample :bd_tek, amp: 0.8
    sleep 0.5
    sample :drum_cymbal_closed, amp: 0.4
    sleep 0.5
    sample :sn_dolf, amp: 0.6
    sleep 0.5
    sample :drum_cymbal_closed, amp: 0.4
    sleep 0.5
    sample :bd_tek, amp: 0.8
    sleep 0.5
    sample :drum_cymbal_closed, amp: 0.4
    sleep 0.5
    sample :sn_dolf, amp: 0.6
    sleep 0.5
    sample :drum_cymbal_closed, amp: 0.4
    sleep 0.5
  when :minimal
    sample :bd_tek, amp: 0.7
    sleep 2
    sample :sn_dolf, amp: 0.5
    sleep 2
  when :bladerunner
    sample :bd_tek, amp: 0.7, rate: 0.8
    sleep 1
    sample :drum_cymbal_closed, amp: 0.2, rate: 0.9
    sleep 1
    sample :sn_dolf, amp: 0.5, rate: 0.8
    sleep 1
    sample :drum_cymbal_closed, amp: 0.2, rate: 0.9
    sleep 1
  end
end

# Функция для игры текущего типа баса
define :play_bass do |type|
  case type
  when :simple
    use_synth :tb303
    play :c2, release: 0.3, cutoff: 70, amp: 0.6
    sleep 1
    play :c2, release: 0.1, cutoff: 70, amp: 0.6
    sleep 1
    play :e2, release: 0.3, cutoff: 70, amp: 0.6
    sleep 1
    play :e2, release: 0.1, cutoff: 70, amp: 0.6
    sleep 1
  when :walking
    use_synth :fm
    play :c2, release: 0.7, amp: 0.5
    sleep 1
    play :e2, release: 0.7, amp: 0.5
    sleep 1
    play :g2, release: 0.7, amp: 0.5
    sleep 1
    play :b2, release: 0.7, amp: 0.5
    sleep 1
  when :octaves
    use_synth :dsaw
    play :c2, release: 0.5, cutoff: 80, amp: 0.5
    sleep 2
    play :c3, release: 0.5, cutoff: 80, amp: 0.5
    sleep 2
  when :analog_retro
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
end

# Функция для игры текущего типа мелодии
define :play_melody do |type|
  case type
  when :arpeggio
    use_synth :blade
    play_pattern_timed chord(:c4, :minor), [0.25], amp: 0.4
    play_pattern_timed chord(:g3, :major), [0.25], amp: 0.4
    play_pattern_timed chord(:a3, :minor), [0.25], amp: 0.4
    play_pattern_timed chord(:f3, :major), [0.25], amp: 0.4
  when :chords
    use_synth :prophet
    play chord(:c4, :minor), release: 2, amp: 0.4
    sleep 2
    play chord(:f3, :major), release: 2, amp: 0.4
    sleep 2
  when :lead
    use_synth :dsaw
    use_synth_defaults amp: 0.4, cutoff: 85, release: 0.3
    play :e4
    sleep 0.5
    play :g4
    sleep 0.5
    play :a4
    sleep 0.5
    play :c5
    sleep 0.5
    play :a4
    sleep 0.5
    play :g4
    sleep 0.5
    play :e4
    sleep 1
  when :vangelis
    use_synth :prophet
    with_fx :echo, mix: 0.4, decay: 8, phase: 1 do
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
end

# Функция для игры дополнительных элементов
define :play_fx do |type|
  case type
  when :ambient
    with_fx :reverb, mix: 0.7 do
      sample :ambi_lunar_land, rate: 0.5, amp: 0.3
    end
  when :glitch
    sample [:glitch_perc1, :glitch_perc2].choose, amp: 0.3, rate: rrand(0.8, 1.2)
  when :sweep
    with_fx :echo, mix: 0.3, decay: 8 do
      sample :ambi_choir, rate: 0.5, amp: 0.3
    end
  when :bladerunner_city
    with_fx :reverb, mix: 0.8, room: 0.9 do
      with_fx :distortion, distort: 0.2 do
        sample [:ambi_dark_woosh, :ambi_haunted_hum].choose, rate: 0.5, amp: 0.3
      end
    end
    sleep 1
    with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
      sample :vinyl_hiss, rate: 0.7, amp: 0.2
    end
  end
end

# Добавляем новую функцию для мелодических фрагментов в стиле Вангелиса
define :play_vangelis_melody do
  use_synth :tb303
  use_synth_defaults cutoff: 80, res: 0.1, release: 1, amp: 0.4
  
  notes = (scale :c3, :minor_pentatonic)
  
  with_fx :echo, mix: 0.3, decay: 4 do
    with_fx :reverb, mix: 0.7, room: 0.8 do
      2.times do
        play notes.choose, cutoff: rrand(60, 90)
        sleep [1.5, 2, 2.5].choose
      end
    end
  end
end

# Текущие настройки - ретровейв версия
rhythm_type = :bladerunner
bass_type = :analog_retro
melody_type = :vangelis
fx_type = :bladerunner_city
use_fx = true

# Добавляем общий эффект реверберации
with_fx :reverb, mix: 0.5, room: 0.8 do
  with_fx :distortion, distort: 0.1 do
    
    # Основной цикл ритма
    live_loop :rhythm do
      play_rhythm rhythm_type
    end
    
    # Басовая линия
    live_loop :bass, sync: :rhythm do
      play_bass bass_type
    end
    
    # Мелодия
    live_loop :melody, sync: :rhythm do
      play_melody melody_type
    end
    
    # Дополнительные эффекты
    live_loop :fx_loop, sync: :rhythm do
      if use_fx
        play_fx fx_type
      end
      sleep 8
    end
    
    # Добавляем случайные мелодические фрагменты в стиле Вангелиса
    live_loop :vangelis_fragments, sync: :rhythm do
      # Иногда пропускаем для разреженности
      if one_in(3)
        sleep 16
      else
        sleep 4 # Ждем некоторое время перед началом
        play_vangelis_melody
        sleep 8 # Длинная пауза между фрагментами
      end
    end
    
  end
end 