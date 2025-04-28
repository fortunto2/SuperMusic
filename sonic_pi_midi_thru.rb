# Sonic Pi MIDI проигрыватель и форвардер
# Этот код позволяет проигрывать MIDI-последовательности в Sonic Pi и одновременно
# пересылать их в GarageBand через IAC Driver

# Настройка MIDI-выхода
use_midi_defaults port: "IAC Driver Bus 1", channel: 0

# --- Основные функции работы с MIDI ---

# Отправить ноту через MIDI
define :send_note do |note, velocity=80, channel=0|
  midi_note_on note, velocity, port: "IAC Driver Bus 1", channel: channel
end

# Отключить ноту через MIDI
define :release_note do |note, channel=0|
  midi_note_off note, port: "IAC Driver Bus 1", channel: channel
end

# Отправить смену программы (инструмента)
define :change_program do |program, channel=0|
  midi_program_change program, port: "IAC Driver Bus 1", channel: channel
  puts "MIDI Program Change: #{program} на канале #{channel}"
end

# --- Функции для проигрывания последовательностей ---

# Проиграть ритмический узор из нот
define :play_pattern_midi do |notes, durations, velocity=80, channel=0|
  raise "Списки должны иметь одинаковую длину" if notes.length != durations.length
  
  notes.each_with_index do |note, idx|
    send_note note, velocity, channel
    sleep durations[idx]
    release_note note, channel
  end
end

# --- Пример простой перкуссионной партии ---
define :play_drum_pattern do |pattern, duration=0.25, channel=9|
  pattern.each do |drum|
    send_note drum, 100, channel
    sleep duration
  end
end

# --- Простой арпеджиатор ---
define :play_arp do |root_note, mode=:major, steps=8, direction=:up, channel=0|
  notes = scale(root_note, mode, num_octaves: 2)
  
  if direction == :up
    seq = notes[0...steps]
  elsif direction == :down
    seq = notes[0...steps].reverse
  elsif direction == :updown
    seq = notes[0...steps] + notes[0...steps].reverse[1..-2]
  else # :random
    seq = []
    steps.times { seq << notes.choose }
  end
  
  seq.each do |n|
    send_note n, 80, channel
    sleep 0.125
    release_note n, channel
  end
end

# --- MIDI-через для живого выступления ---

# Эта функция выполняет настройку необходимых инструментов
define :setup_instruments do
  # Настраиваем разные инструменты для разных каналов
  change_program 0, 0   # Piano на канале 0
  change_program 32, 1  # Bass на канале 1
  change_program 48, 2  # Strings на канале 2
  change_program 81, 3  # Pad на канале 3
  change_program 0, 9   # GM Drums на канале 9 (стандартный канал ударных)
end

# Отображаем доступные MIDI-порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настройка инструментов
setup_instruments

# --- Примеры использования ---

# Пример 1: Простая мелодическая линия фортепиано
puts "Пример 1: Мелодия фортепиано"
change_program 0, 0  # Grand Piano

# Мажорная гамма вверх и вниз
play_pattern_midi [60, 62, 64, 65, 67, 69, 71, 72, 71, 69, 67, 65, 64, 62, 60],
                  [0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.4]

sleep 1

# Пример 2: Басовая линия
puts "Пример 2: Басовая линия"
change_program 33, 1  # Finger Bass

# Простая басовая линия
4.times do
  play_pattern_midi [36, 36, 43, 36, 41, 43, 36, 43], 
                    [0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, 0.5], 
                    100, 1
end

sleep 1

# Пример 3: Ударные
puts "Пример 3: Ударные"
4.times do
  play_drum_pattern [36, 42, 38, 42], 0.25, 9  # Бочка, Hi-Hat, Snare, Hi-Hat
end

sleep 1

# Пример 4: Арпеджио
puts "Пример 4: Арпеджио"
change_program 4, 0  # Electric Piano

play_arp :c3, :major, 8, :up, 0
play_arp :c3, :major, 8, :down, 0
play_arp :c3, :major, 12, :updown, 0
play_arp :c3, :major, 8, :random, 0

# Финал - аккорд через несколько каналов
puts "Финальный аккорд"
change_program 48, 2  # Strings
change_program 73, 3  # Flute

# Играем До-мажорный аккорд на разных инструментах
notes = [60, 64, 67, 72]
send_note notes[0], 90, 0  # C на фортепиано
send_note notes[1], 70, 2  # E на струнных
send_note notes[2], 70, 2  # G на струнных
send_note notes[3], 80, 3  # C на флейте

sleep 4

notes.each_with_index do |note, idx|
  release_note note, idx % 4
end

puts "Демонстрация завершена!" 