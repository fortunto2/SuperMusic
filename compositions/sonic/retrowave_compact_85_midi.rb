# Название: Compact Retrowave MIDI
# Стиль: Retrowave, Ambient
# BPM: 85
# Дата создания: 2023-10-01

# Проверяем и настраиваем MIDI порт
use_midi_ports "iac_driver_bus_1", nil
use_bpm 85

# --- Базовые функции ---
define :note_on do |n, ch=0, vel=80|
  midi n, vel: vel, channel: ch
end

define :note_off do |n, ch=0|
  midi_note_off n, channel: ch
end

define :pc do |prog, ch=0|
  midi_pc prog, channel: ch
end

define :cc do |num, val, ch=0|
  midi_cc num, val, channel: ch
end

# Установка инструментов
pc 90, 0  # Pad
pc 38, 1  # Bass
pc 81, 2  # Lead
pc 5, 3   # Piano
sleep 1

# --- Аккорды и паттерны ---
chords = [
  chord(:e3, :minor7), chord(:c3, :major7), 
  chord(:a2, :minor7), chord(:b2, '7')
]

# Простой барабанный паттерн
define :drums do
  8.times do |i|
    note_on 36, 9, 90 if i % 4 == 0  # Kick
    note_on 42, 9, 60 if i % 2 == 0  # Closed HH
    note_on 38, 9, 80 if i % 4 == 2  # Snare
    sleep 0.25
    note_off 36, 9
    note_off 42, 9
    note_off 38, 9
  end
end

# --- Основная композиция ---

# Пэды
live_loop :pads do
  chords.each do |c|
    # CC модуляция
    cc 74, 60 + rand(30), 0
    
    # Проигрываем аккорд
    c.each do |n|
      note_on n, 0, 60
    end
    
    sleep 4
    
    c.each do |n|
      note_off n, 0
    end
  end
end

# Бас
live_loop :bass, sync: :pads do
  chords.each do |chord|
    root = chord[0] - 12
    
    2.times do
      note_on root, 1, 90
      sleep 0.75
      note_off root, 1
      
      note_on root + 7, 1, 70
      sleep 0.25
      note_off root + 7, 1
      
      note_on root, 1, 80
      sleep 0.5
      note_off root, 1
      
      note_on root + 7, 1, 60
      sleep 0.25
      note_off root + 7, 1
      
      note_on root + 5, 1, 70
      sleep 0.25
      note_off root + 5, 1
    end
  end
end

# Арпеджио
live_loop :arp, sync: :pads do
  use_random_seed 42  # Для стабильности паттерна
  
  chords.each do |chord|
    if one_in(3)
      sleep 4
    else
      # Добавляем ноты сверху и сортируем для арпеджио
      notes = (chord + [chord[0] + 12]).sort
      
      # Играем арпеджио
      8.times do
        idx = rand_i(notes.length)
        note_on notes[idx], 2, 70
        sleep 0.25
        note_off notes[idx], 2
        
        # Иногда делаем паузу
        sleep 0.25 if one_in(6)
      end
    end
  end
end

# Барабаны
live_loop :drums_loop, sync: :pads do
  if one_in(4)
    sleep 4
  else
    drums
  end
end

# Меняем контроллеры периодически для движения звука
live_loop :controllers, sync: :pads do
  sleep 4
  16.times do
    cc 1, 40 + rand(40), 0 if one_in(3)
    sleep 0.25
  end
end

puts "Retrowave компактный пример играет через iac_driver_bus_1" 