# Название: Dreamscape Ambient MIDI
# Стиль: Эмбиент, Атмосферный, Медитативный
# BPM: 90
# Дата создания: 2023-09-10
# 
# Используемые MIDI-инструменты:
# - Канал 0: Pad (Program Change 88) - фоновые пэды
# - Канал 1: Electric Piano (Program Change 4) - мелодические элементы
# - Канал 2: Synth Lead (Program Change 80) - плавающая мелодия
# - Канал 3: Bass (Program Change 38) - глубокий бас
# - Канал 4: Crystal (Program Change 98) - атмосферные акценты
# - Канал 9: Percussion (GM Standard) - мягкие ударные
#
# Структура:
# - Плавные атмосферные пэды
# - Минималистичная мелодия на электропиано
# - Периодически появляющиеся синтезаторные элементы
# - Глубокий редкий бас
# - Кристальные звуки для создания глубины

# Проверяем доступные MIDI порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настраиваем MIDI порт 
use_midi_ports "IAC Driver Bus 1", nil
use_bpm 90

# --- Функции для работы с MIDI ---

# Отправка MIDI ноты с заданной длительностью
define :play_midi_note do |note, channel=0, velocity=80, duration=1|
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

# Отправка MIDI Control Change
define :send_midi_cc do |cc_num, value, channel=0|
  midi_cc cc_num, value, channel: channel
end

# Смена инструмента на указанном канале
define :set_midi_instrument do |program, channel=0|
  midi_pc program, channel: channel
  puts "MIDI Program Change: #{program} на канале #{channel}"
end

# --- Инициализация инструментов ---
puts "Настройка MIDI-инструментов для Dreamscape Ambient"

# Настройка инструментов для каждого канала
set_midi_instrument 88, 0  # Pad (Sweep Pad)
set_midi_instrument 4, 1   # Electric Piano
set_midi_instrument 80, 2  # Synth Lead
set_midi_instrument 38, 3  # Synth Bass
set_midi_instrument 98, 4  # Crystal
sleep 1  # Даем системе время на применение изменений

# --- Основная структура ---

# Медленно меняющиеся аккорды пэдов
live_loop :pads do
  chords = (ring 
    chord(:d3, :minor7), 
    chord(:a3, :minor7), 
    chord(:f3, :major7), 
    chord(:g3, '7')
  )
  
  idx = tick
  current_chord = chords[idx]
  
  play_midi_chord current_chord, 0, 60, 8
end

# Минималистичная мелодия электропиано
live_loop :piano_melody, sync: :pads do
  if one_in(3) # Иногда пропускаем цикл для создания пространства
    sleep 8
  else
    notes = (ring :d4, :a4, :f4, :e4, :d5, :a4)
    sleeps = (ring 2, 1, 1, 2, 1, 1)
    velocities = (ring 65, 55, 60, 70, 60, 50)
    
    4.times do |i|
      idx = i % notes.length
      play_midi_note notes[idx], 1, velocities[idx], sleeps[idx]
    end
  end
end

# Синтезаторная мелодия
live_loop :synth_elements, sync: :pads do
  if one_in(2) # 50% шанс проигрывания в этом цикле
    notes = (scale :d4, :minor_pentatonic, num_octaves: 2).shuffle.take(4)
    velocities = (range 50, 70, step: 5).shuffle.take(4)
    sleeps = [0.5, 0.5, 1, 2]
    
    4.times do |i|
      play_midi_note notes[i], 2, velocities[i], sleeps[i]
    end
  else
    sleep 4
  end
end

# Глубокий бас
live_loop :deep_bass, sync: :pads do
  pattern = (ring :d2, :a1, :f1, :g1)
  sleeps = (ring 2, 2, 2, 2)
  
  idx = tick
  play_midi_note pattern[idx], 3, 70, sleeps[idx]
end

# Кристальные звуки
live_loop :crystal_sounds, sync: :pads do
  if one_in(4) # Редкие появления для создания интереса
    notes = (scale :d5, :minor, num_octaves: 1).shuffle.take(3)
    
    3.times do |i|
      play_midi_note notes[i], 4, 40 + rand(20), 0.25
    end
  end
  
  sleep 2
end

# Мягкие перкуссионные элементы
live_loop :soft_percussion, sync: :pads do
  pattern = (ring 
    [42, 0.5], # Closed Hi-Hat
    [38, 0.5], # Snare 
    [42, 0.5], # Closed Hi-Hat
    [nil, 0.5],
    [42, 0.5], # Closed Hi-Hat
    [38, 0.5], # Snare
    [46, 0.5], # Open Hi-Hat
    [nil, 0.5]
  )
  
  8.times do |i|
    if pattern[i][0]
      play_midi_note pattern[i][0], 9, 40, 0.1
    end
    sleep pattern[i][1]
  end
end

# Изменения параметров для создания динамики
live_loop :parameter_control, sync: :pads do
  # Плавное изменение фильтра (Control Change 74 - Brightness)
  16.times do |i|
    val = 60 + (Math.sin(i/16.0 * Math::PI) * 40).to_i
    send_midi_cc 74, val, 0
    sleep 0.5
  end
end

puts "Dreamscape Ambient MIDI теперь играет через IAC Driver Bus 1"
puts "Откройте GarageBand для прослушивания!" 