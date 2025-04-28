# Название: Drum & Bass MIDI
# Стиль: Drum & Bass, Electronic
# BPM: 160
# Дата создания: 2023-09-15
# 
# Используемые MIDI-инструменты:
# - Канал 0: Synth Bass (Program Change 38) - басовая линия
# - Канал 1: Synth Lead (Program Change 81) - синтезаторные элементы
# - Канал 2: Pad (Program Change 88) - атмосферные пэды
# - Канал 9: Drums (GM Standard) - ударные и перкуссия
#
# Структура:
# - Быстрый брейкбит на барабанах
# - Низкий вибрирующий бас на синтезаторе
# - Короткие синтезаторные элементы
# - Атмосферные пэды для создания глубины

# Проверяем доступные MIDI порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настраиваем MIDI порт 
use_midi_ports "IAC Driver Bus 1", nil
use_bpm 160

# --- Функции для работы с MIDI ---

# Отправка MIDI ноты с заданной длительностью
define :play_midi_note do |note, channel=0, velocity=80, duration=0.25|
  midi note, vel: velocity, channel: channel
  sleep duration
  midi_note_off note, channel: channel
end

# Отправка MIDI ноты без автоматического выключения
define :midi_note_start do |note, channel=0, velocity=80|
  midi note, vel: velocity, channel: channel
end

# Отправка MIDI ноты выключения
define :midi_note_end do |note, channel=0|
  midi_note_off note, channel: channel
end

# Смена инструмента на указанном канале
define :set_midi_instrument do |program, channel=0|
  midi_pc program, channel: channel
  puts "MIDI Program Change: #{program} на канале #{channel}"
end

# Отправка MIDI Control Change
define :send_midi_cc do |cc_num, value, channel=0|
  midi_cc cc_num, value, channel: channel
end

# --- Инициализация инструментов ---
puts "Настройка MIDI-инструментов для Drum & Bass"

# Настройка инструментов для каждого канала
set_midi_instrument 38, 0  # Synth Bass
set_midi_instrument 81, 1  # Synth Lead (Square Wave)
set_midi_instrument 88, 2  # Pad (Sweep Pad)
sleep 1  # Даем системе время на применение изменений

# --- Основная структура ---

# Функция для стандартного паттерна ударных в драм-н-бейс
define :drum_pattern_1 do
  # Kick drum (36), Snare (38), Closed HH (42), Open HH (46)
  patterns = {
    36 => (ring 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0),  # Бас-барабан
    38 => (ring 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0),  # Малый барабан
    42 => (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0),  # Закрытый хай-хэт
    46 => (ring 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)   # Открытый хай-хэт
  }
  
  16.times do |i|
    # Одновременно отправляем все активные ноты ударных
    patterns.each do |note, pattern|
      if pattern[i] == 1
        velocity = note == 38 ? 100 : 80  # Малый барабан громче
        play_midi_note note, 9, velocity, 0.06
      end
    end
    sleep 0.25
  end
end

# Функция для вариации паттерна ударных
define :drum_pattern_2 do
  # Kick drum (36), Snare (38), Closed HH (42), Open HH (46), Tom (45)
  patterns = {
    36 => (ring 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0),  # Бас-барабан
    38 => (ring 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0),  # Малый барабан
    42 => (ring 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),  # Закрытый хай-хэт
    46 => (ring 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),  # Открытый хай-хэт
    45 => (ring 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0)   # Том
  }
  
  16.times do |i|
    patterns.each do |note, pattern|
      if pattern[i] == 1
        velocity = case note
        when 38 then 100  # Малый барабан
        when 45 then 90   # Том
        else 80
        end
        play_midi_note note, 9, velocity, 0.06
      end
    end
    sleep 0.25
  end
end

# Басовая линия для драм-н-бейс
define :bass_pattern_1 do |root=:f1|
  pattern = [
    [root, 0.75],
    [root+12, 0.25],
    [root+5, 0.5],
    [root+2, 0.5],
    [root, 0.5],
    [root+7, 0.5],
    [root, 1.0]
  ]
  
  pattern.each do |note, duration|
    play_midi_note note, 0, 90, duration
  end
end

# Вариация басовой линии
define :bass_pattern_2 do |root=:f1|
  # Создаем патерн басовой линии с более интенсивным ритмом
  notes = (scale root, :minor_pentatonic, num_octaves: 2).take(5)
  
  2.times do
    play_midi_note notes[0], 0, 90, 0.5
    play_midi_note notes[1], 0, 85, 0.25
    play_midi_note notes[0], 0, 90, 0.25
  end
  
  play_midi_note notes[3], 0, 80, 0.5
  play_midi_note notes[2], 0, 85, 0.5
  
  play_midi_note notes[0], 0, 90, 1.0
  play_midi_note notes[4], 0, 80, 0.5
  play_midi_note notes[0], 0, 90, 0.5
end

# Синтезаторные вставки
define :synth_pattern do |root=:f3|
  notes = (scale root, :minor, num_octaves: 1)
  
  with_random_seed 1234 do
    4.times do
      4.times do
        if one_in(3)
          note = notes.choose
          play_midi_note note, 1, 70 + rand(30), 0.25
        else
          sleep 0.25
        end
      end
    end
  end
end

# Основная басовая линия
live_loop :bass do
  roots = (ring :f1, :d1, :a1, :e1)
  
  4.times do |i|
    if i % 2 == 0
      bass_pattern_1 roots[i]
    else
      bass_pattern_2 roots[i]
    end
  end
end

# Ударные
live_loop :drums, sync: :bass do
  16.times do |i|
    if one_in(8) # Иногда пропускаем удар для создания интереса
      sleep 4
    else
      # Чередуем паттерны ударных
      if i % 4 < 3
        drum_pattern_1
      else
        drum_pattern_2
      end
    end
  end
end

# Синтезаторные элементы
live_loop :synth_elements, sync: :bass do
  roots = (ring :f3, :d3, :a3, :e3)
  
  if one_in(4) # Иногда пропускаем для создания пространства
    sleep 4
  else
    idx = tick % 4
    synth_pattern roots[idx]
  end
end

# Атмосферные пэды
live_loop :pads, sync: :bass do
  chord_progression = (ring 
    chord(:f2, :minor),
    chord(:d2, :minor),
    chord(:a2, :minor),
    chord(:e2, :minor7)
  )
  
  idx = tick % 4
  current_chord = chord_progression[idx]
  
  # Отправляем ноты аккорда с перекрытием
  current_chord.each do |note|
    midi_note_start note, 2, 40
    sleep 0.1
  end
  
  sleep 3.5 # Держим аккорд почти весь такт
  
  # Выключаем все ноты аккорда
  current_chord.each do |note|
    midi_note_end note, 2
    sleep 0.05
  end
  
  sleep 0.25 # Небольшая пауза между аккордами
end

puts "Drum & Bass MIDI теперь играет через IAC Driver Bus 1"
puts "Откройте GarageBand для прослушивания!" 