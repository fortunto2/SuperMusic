# Sonic Pi Code - отправка MIDI в GarageBand через IAC Driver
# Убедитесь, что IAC Driver активирован в Audio MIDI Setup
# и GarageBand настроен на прием MIDI с IAC Driver

# Настраиваем порт MIDI вывода (IAC Driver Bus 1)
use_midi_defaults port: "IAC Driver Bus 1", channel: 0

# Функция для игры отдельных нот через MIDI
define :play_midi_note do |note, velocity = 80, duration = 1|
  midi_note_on note, velocity
  sleep duration
  midi_note_off note, velocity
end

# Функция для игры аккорда через MIDI
define :play_midi_chord do |notes, velocity = 80, duration = 1|
  notes.each do |note|
    midi_note_on note, velocity
    sleep 0.01 # Небольшая задержка между нотами
  end
  sleep duration
  notes.each do |note|
    midi_note_off note, velocity
    sleep 0.01
  end
end

# Функция для смены инструмента
define :change_midi_instrument do |program|
  midi_program_change program
  puts "MIDI Program Change: #{program}"
end

# Проверка доступности MIDI-портов
puts "Доступные MIDI-порты:"
puts midi_available_ports

# -------------------------------
# ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ
# -------------------------------

# Пример 1: Простая мелодия
puts "Пример 1: Простая мелодия (Piano)"
change_midi_instrument 0 # Grand Piano
sleep 1

play_midi_note 60, 100, 0.5  # C4
play_midi_note 64, 100, 0.5  # E4
play_midi_note 67, 100, 0.5  # G4
play_midi_note 72, 100, 1.0  # C5

sleep 1

# Пример 2: Прогрессия аккордов 
puts "Пример 2: Прогрессия аккордов (Strings)"
change_midi_instrument 48 # String Ensemble
sleep 1

# C Major
play_midi_chord [60, 64, 67], 70, 1.0
# G Major
play_midi_chord [67, 71, 74], 70, 1.0
# A Minor
play_midi_chord [69, 72, 76], 70, 1.0
# F Major
play_midi_chord [65, 69, 72], 70, 1.0

sleep 1

# Пример 3: Арпеджио
puts "Пример 3: Арпеджио (Electric Piano)"
change_midi_instrument 4 # Electric Piano
sleep 1

4.times do
  [60, 64, 67, 72, 67, 64].each do |note|
    play_midi_note note, 90, 0.25
  end
end

sleep 1

# Пример 4: Басовая линия 
puts "Пример 4: Басовая линия (Synth Bass)"
change_midi_instrument 38 # Synth Bass
sleep 1

bass_line = [36, 36, 43, 41, 36, 36, 43, 45]
bass_durations = [0.5, 0.5, 0.25, 0.75, 0.5, 0.5, 0.25, 0.75]

bass_line.each_with_index do |note, idx|
  play_midi_note note, 100, bass_durations[idx]
end

puts "Готово! Проверьте звучание в GarageBand." 