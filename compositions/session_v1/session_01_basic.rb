# Название: Session 01 - Basic
# Стиль: Минимал-электро
# BPM: 100
# Дата создания: 2023-10-20
# 
# Используемые инструменты:
# - :tb303 (бас)
# - :blade (арпеджио)
# - Базовые ударные
# 
# Структура:
# - Базовый ритм
# - Простая басовая линия
# - Арпеджио мелодия
# - Амбиентные эффекты

# Установка базового темпа
use_bpm 100

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
  end
end

# Текущие настройки - базовая версия
rhythm_type = :basic
bass_type = :simple
melody_type = :arpeggio
fx_type = :ambient
use_fx = true

# Добавляем общий эффект реверберации
with_fx :reverb, mix: 0.3, room: 0.7 do
  
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
  
end 