# Название: Interstellar Ambient MIDI
# Стиль: Амбиент, Ханс Циммер, Интерстеллар (MIDI версия)
# BPM: 60
# Дата создания: 2023-08-16
# 
# Используемые MIDI-инструменты:
# - Канал 0: Pad (Program Change 89) - органные аккорды
# - Канал 1: Organ (Program Change 19) - органный бас
# - Канал 2: Music Box (Program Change 10) - основная мелодия
# - Канал 3: Synth (Program Change 81) - арпеджио
# - Канал 4: Percussive (Program Change 47) - тиканье часов
# - Канал 5: SynthPad (Program Change 91) - нарастания напряжения
# - Канал 9: Percussion (GM Standard) - атмосферные удары
#
# Структура:
# - Минималистичные органные аккорды
# - Выразительная мелодия в стиле Ханса Циммера
# - Характерное тиканье часов (отсылка к фильму)
# - Атмосферные звуки и редкие низкие удары

# ПРАВИЛЬНЫЙ СПОСОБ УКАЗАНИЯ MIDI-ПОРТОВ В SONIC PI:
# Проверяем доступные MIDI порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настраиваем MIDI порт (используйте именно такое название, как показано в списке midi_available_ports)
use_midi_ports "IAC Driver Bus 1", nil
use_bpm 60

# --- Функции для работы с MIDI ---

# Отправка MIDI ноты с заданной длительностью
define :play_midi_note do |note, channel=0, velocity=80, duration=1|
  # Используем стандартный метод midi, который работает с настроенным MIDI-портом
  midi note, vel: velocity, channel: channel
  sleep duration
  midi_note_off note, channel: channel
end

# Отправка аккорда MIDI-нотами
define :play_midi_chord do |notes, channel=0, velocity=80, duration=1|
  notes.each do |note|
    midi note, vel: velocity, channel: channel
    sleep 0.01 # Небольшая задержка между нотами
  end
  sleep duration
  notes.each do |note|
    midi_note_off note, channel: channel
    sleep 0.01
  end
end

# Отправка непрерывной ноты (без выключения)
define :play_midi_sustained do |note, channel=0, velocity=80|
  midi note, vel: velocity, channel: channel
end

# Выключение ноты
define :stop_midi_note do |note, channel=0|
  midi_note_off note, channel: channel
end

# Смена инструмента на указанном канале (исправленный метод)
define :set_midi_instrument do |program, channel=0|
  # В Sonic Pi используется метод midi для Program Change
  midi_pc program, channel: channel
  puts "MIDI Program Change: #{program} на канале #{channel}"
end

# --- Инициализация инструментов ---
puts "Настройка MIDI-инструментов для Interstellar Ambient"

# Настройка инструментов для каждого канала
set_midi_instrument 89, 0  # Pad (Warm Pad)
set_midi_instrument 19, 1  # Church Organ
set_midi_instrument 10, 2  # Music Box
set_midi_instrument 81, 3  # Synth Lead
set_midi_instrument 47, 4  # Orchestral Harp
set_midi_instrument 91, 5  # SynthPad
sleep 1  # Даем системе время на применение изменений

# --- Основная структура ---

# Органные повторяющиеся аккорды
live_loop :organ_pattern do
  # Pad для аккордов
  notes = (ring [:c4, :e4, :g4], [:c4, :e4, :g4], [:g3, :b3, :d4], [:g3, :b3, :d4])
  times = (ring 1, 1, 1, 1)
  
  idx = tick
  play_midi_chord notes[idx], 0, 70, times[idx]
end

# Минималистичный органный бас
live_loop :bass_organ, sync: :organ_pattern do
  pattern = (ring :c2, :c2, :g1, :g1)
  sleeps = (ring 2, 2, 2, 2)
  
  idx = tick
  play_midi_note pattern[idx], 1, 60, sleeps[idx]
end

# Выразительная мелодия
live_loop :main_melody, sync: :organ_pattern do
  notes = (ring :g4, :c5, :e5, :g5, :e5, :c5)
  velocities = (ring 70, 70, 80, 70, 60, 70)
  sleeps = (ring 2, 2, 3, 3, 2, 4)
  
  idx = tick
  play_midi_note notes[idx], 2, velocities[idx], sleeps[idx]
end

# Медленные арпеджио
live_loop :slow_arps, sync: :organ_pattern do
  if one_in(3)  # Делаем арпеджио более случайными
    notes = (scale :c3, :minor, num_octaves: 3)
    
    4.times do
      n = notes.choose
      play_midi_note n, 3, rrand_i(50, 70), 1
    end
  else
    sleep 4
  end
end

# Характерное тиканье часов
live_loop :clock_ticks, sync: :organ_pattern do
  pattern = (ring 1, 0, 1, 0, 1, 0, 1, 0)
  8.times do |i|
    if pattern[i] == 1
      play_midi_note :e5, 4, 40, 0.1
    end
    sleep 0.5
  end
end

# Отдаленный атмосферный шум (через низкочастотные ноты)
live_loop :atmosphere, sync: :organ_pattern do
  notes = (ring :c2, :g2, :c3)
  note = notes.tick
  
  play_midi_note note, 5, 40, 8
  sleep 8
end

# Периодические нарастания громкости (tension builder)
live_loop :tension, sync: :organ_pattern do
  n = (ring :c3, :e3, :g2, :c2).tick
  
  # Crescendo эффект через MIDI Control Change
  16.times do |i|
    velocity = 30 + (i * 3)
    play_midi_note n, 5, velocity, 0.5
  end
  
  sleep 8
end

# Редкие низкие удары (как в сцене с волнами)
live_loop :deep_impact, sync: :organ_pattern do
  # Используем канал ударных
  midi 35, vel: 90, channel: 9  # Kick Drum 2
  sleep 0.2
  midi_note_off 35, channel: 9
  
  sleep 16
  
  midi 36, vel: 100, channel: 9  # Kick Drum 1
  sleep 0.2
  midi_note_off 36, channel: 9
  
  sleep 8
end

puts "Interstellar Ambient MIDI теперь играет через IAC Driver Bus 1"
puts "Откройте GarageBand для прослушивания!" 