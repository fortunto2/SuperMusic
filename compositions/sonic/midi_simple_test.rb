# Название: MIDI Simple Test
# Стиль: Тестовый пример для MIDI
# Дата создания: 2023-09-25
#
# Демонстрация отправки MIDI на несколько каналов с разными инструментами
# через порт iac_driver_bus_1

# Проверяем доступные MIDI порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настраиваем MIDI порт (обязательно с названием iac_driver_bus_1, строчными буквами)
use_midi_ports "iac_driver_bus_1", nil
use_bpm 90

# --- Функции для работы с MIDI ---

# Отправка MIDI Program Change (для установки инструментов)
define :set_instrument do |program, channel|
  midi_pc program, channel: channel
  puts "Instrument change: Program #{program} on channel #{channel}"
end

# Отправка MIDI ноты с заданной длительностью
define :play_midi_note do |note, channel=0, velocity=80, duration=1|
  midi note, vel: velocity, channel: channel
  sleep duration
  midi_note_off note, channel: channel
end

# --- Настраиваем инструменты на разных каналах ---

# Устанавливаем 5 разных инструментов на 5 каналов
set_instrument 0, 0   # Piano (канал 0)
set_instrument 24, 1  # Acoustic Guitar (канал 1)
set_instrument 32, 2  # Acoustic Bass (канал 2)
set_instrument 73, 3  # Flute (канал 3)
set_instrument 48, 4  # String Ensemble (канал 4)

# Даем системе время применить изменения
sleep 1

# --- Демонстрация игры на разных инструментах ---

# Функция для проигрывания простой мелодии на выбранном канале
define :play_demo_on_channel do |channel|
  puts "Playing demo on channel #{channel}"
  notes = (scale :c4, :major, num_octaves: 1)
  
  notes.each do |note|
    play_midi_note note, channel, 80, 0.25
  end
  
  # Играем аккорд тоники в конце
  chord_notes = chord(:c4, :major)
  chord_notes.each do |note|
    midi note, vel: 80, channel: channel
  end
  sleep 1
  chord_notes.each do |note|
    midi_note_off note, channel: channel
  end
end

# Простой цикл, который играет демо на каждом канале поочередно
live_loop :channel_demo do
  # Демонстрация каждого инструмента
  5.times do |channel|
    play_demo_on_channel channel
    sleep 0.5
  end
  
  # Для остановки цикла после одного проигрывания
  # закомментируйте следующую строку 
  stop
end

# --- Пример игры нескольких инструментов одновременно ---

# После окончания демонстрации отдельных инструментов, 
# запускаем простой пример с несколькими инструментами одновременно
live_loop :multi_instrument_demo do
  # Ждем завершения первого демо
  sleep 10
  
  puts "Playing multi-instrument demo"
  
  # Бас на канале 2
  in_thread do
    4.times do
      play_midi_note :c2, 2, 80, 0.5
      play_midi_note :g2, 2, 80, 0.5
      play_midi_note :c3, 2, 80, 0.5
      play_midi_note :g2, 2, 80, 0.5
    end
  end
  
  # Аккорды на канале 4 (струнные)
  in_thread do
    2.times do
      # C major
      chord(:c3, :major).each { |n| midi n, vel: 60, channel: 4 }
      sleep 2
      chord(:c3, :major).each { |n| midi_note_off n, channel: 4 }
      
      # G major
      chord(:g3, :major).each { |n| midi n, vel: 60, channel: 4 }
      sleep 2
      chord(:g3, :major).each { |n| midi_note_off n, channel: 4 }
    end
  end
  
  # Мелодия на канале 3 (флейта)
  in_thread do
    sleep 1
    play_midi_note :e4, 3, 70, 0.5
    play_midi_note :d4, 3, 70, 0.5
    play_midi_note :c4, 3, 70, 1
    play_midi_note :d4, 3, 70, 0.5
    play_midi_note :e4, 3, 70, 0.5
    play_midi_note :e4, 3, 70, 0.5
    play_midi_note :e4, 3, 70, 1
  end
  
  # Для остановки цикла после одного проигрывания
  sleep 8
  stop
end

puts "Тестовый MIDI пример запущен через iac_driver_bus_1"
puts "Откройте синтезатор/DAW и настройте его на прием MIDI с iac_driver_bus_1" 