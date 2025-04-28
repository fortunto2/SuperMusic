# Название: Retrowave Ambient with Rhythmic Patterns
# Стиль: Retrowave, Ambient, Synthwave
# BPM: 85
# Дата создания: 2023-09-30
# 
# Используемые MIDI-инструменты:
# - Канал 0: Synth Pad (Program Change 90) - основные пэды
# - Канал 1: Bass (Program Change 38) - ретро-бас
# - Канал 2: Synth Lead (Program Change 81) - ведущий синтезатор
# - Канал 3: E-Piano (Program Change 5) - электрическое пианино
# - Канал 9: Drums (GM Standard) - ритмические элементы
#
# Структура:
# - Медленно разворачивающиеся пэды с долгим релизом
# - Пульсирующий синтезаторный бас в стиле 80-х
# - Арпеджио и мелодия с ретро-эффектами
# - Разнообразные ритмические паттерны

# Проверяем доступные MIDI порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настраиваем MIDI порт
use_midi_ports "iac_driver_bus_1", nil
use_bpm 85

# --- Функции для работы с MIDI ---

# Отправка MIDI Program Change
define :set_instrument do |program, channel|
  midi_pc program, channel: channel
  puts "MIDI Program Change: #{program} на канале #{channel}"
end

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
    sleep 0.02 # Небольшая задержка между нотами
  end
  sleep duration
  notes.each do |note|
    midi_note_off note, channel: channel
    sleep 0.02
  end
end

# Отправка аккорда MIDI-нотами с арпеджио
define :play_midi_arpeggio do |notes, channel=0, velocity=80, division=0.25, times=4|
  times.times do
    notes.each do |note|
      midi note, vel: velocity, channel: channel
      sleep division
      midi_note_off note, channel: channel
    end
  end
end

# Отправка MIDI Control Change
define :send_midi_cc do |cc_num, value, channel=0|
  midi_cc cc_num, value, channel: channel
end

# --- Инициализация инструментов ---
puts "Настройка MIDI-инструментов для Retrowave Ambient"

# Настройка инструментов для каждого канала
set_instrument 90, 0  # Pad (Warm Pad)
set_instrument 38, 1  # Synth Bass
set_instrument 81, 2  # Synth Lead
set_instrument 5, 3   # Electric Piano
sleep 1  # Даем системе время на применение изменений

# --- Ритмические паттерны ---

# Определяем несколько ритмических паттернов для разнообразия
drum_patterns = {
  # Простой паттерн с бочкой и закрытым хай-хэтом
  simple: {
    36 => (ring 1, 0, 0, 0, 1, 0, 0, 0),  # Kick
    42 => (ring 1, 1, 1, 1, 1, 1, 1, 1),  # Closed HH
    44 => (ring 0, 0, 1, 0, 0, 0, 1, 0)   # Pedal HH
  },
  
  # Более выразительный паттерн с малым барабаном и акцентами
  dynamic: {
    36 => (ring 1, 0, 0, 0, 1, 0, 0, 0),  # Kick
    38 => (ring 0, 0, 1, 0, 0, 0, 1, 0),  # Snare
    42 => (ring 1, 1, 1, 1, 1, 1, 1, 1),  # Closed HH
    46 => (ring 0, 0, 0, 0, 0, 0, 0, 1)   # Open HH
  },
  
  # Минималистичный паттерн с акцентами на 2 и 4
  minimal: {
    36 => (ring 1, 0, 0, 0, 0, 0, 0, 0),  # Kick
    42 => (ring 0, 0, 1, 0, 0, 0, 1, 0)   # Closed HH
  },
  
  # Атмосферный паттерн с редкими перкуссионными элементами
  ambient: {
    36 => (ring 1, 0, 0, 0, 0, 0, 0, 0),  # Kick
    44 => (ring 0, 0, 0, 0, 1, 0, 0, 0),  # Pedal HH
    53 => (ring 0, 0, 0, 0, 0, 0, 0, 1)   # Ride Bell
  },
  
  # Синкопированный паттерн для разнообразия
  syncopated: {
    36 => (ring 1, 0, 0, 1, 0, 1, 0, 0),  # Kick
    38 => (ring 0, 0, 1, 0, 0, 0, 1, 0),  # Snare
    42 => (ring 1, 0, 1, 0, 1, 0, 1, 0)   # Closed HH
  }
}

# Функция для проигрывания ритм-паттерна
define :play_drum_pattern do |pattern_key, repeats=2|
  pattern = drum_patterns[pattern_key]
  
  repeats.times do
    8.times do |i|
      # Проигрываем все активные ноты в паттерне
      pattern.each do |note, steps|
        if steps[i] == 1
          velocity = (note == 36) ? 90 : 70  # Бочка громче
          play_midi_note note, 9, velocity, 0.05
        end
      end
      sleep 0.25
    end
  end
end

# --- Аккордовые последовательности ---

# Основные аккордовые последовательности ретровейв
chord_progressions = [
  [chord(:e3, :minor7), chord(:c3, :major7), chord(:a2, :minor7), chord(:b2, :dominant7)],
  [chord(:g3, :minor7), chord(:eb3, :major7), chord(:f3, :major9), chord(:bb2, :dominant7)],
  [chord(:a3, :minor7), chord(:f3, :major7), chord(:d3, :minor7), chord(:e3, :dominant7)]
]

# --- Основная композиция ---

# Функция для плавного изменения CC параметра
define :smooth_cc_change do |cc_number, start_val, end_val, steps, channel, sleep_time|
  step_size = (end_val - start_val) / steps.to_f
  
  steps.times do |i|
    val = start_val + (step_size * i)
    send_midi_cc cc_number, val.to_i, channel
    sleep sleep_time
  end
end

# Основная аккордовая лупа с пэдами
live_loop :pad_chords do
  progression = chord_progressions.choose
  
  progression.each do |chord|
    # Отправляем MIDI CC для создания эволюции звука
    send_midi_cc 74, 50 + rand(40), 0  # Яркость фильтра
    
    # Играем аккорд
    play_midi_chord chord, 0, 60, 4
    
    # Плавно меняем фильтр на протяжении аккорда
    in_thread do
      smooth_cc_change 74, 70, 40, 16, 0, 0.25
    end
  end
end

# Простая басовая линия
live_loop :bass_line, sync: :pad_chords do
  progression = chord_progressions[0]  # Используем первую прогрессию для баса
  
  progression.each do |chord|
    root = chord[0] - 12  # Опускаем на октаву ниже
    
    # Создаем типичный ретро-бас паттерн
    2.times do
      play_midi_note root, 1, 90, 0.75
      play_midi_note root + 7, 1, 70, 0.25
      play_midi_note root, 1, 80, 0.5
      play_midi_note root + 7, 1, 60, 0.25
      play_midi_note root + 5, 1, 70, 0.25
    end
  end
end

# Арпеджио на синтезаторе
live_loop :synth_arp, sync: :pad_chords do
  progression = chord_progressions.choose
  
  if one_in(3)  # Иногда пропускаем для создания пространства
    sleep 16
  else
    progression.each do |chord|
      # Добавляем октаву выше к аккорду для арпеджио
      arp_notes = chord + [chord[0] + 12, chord[1] + 12]
      
      # Случайно выбираем направление арпеджио
      direction = [:up, :down, :random].choose
      
      case direction
      when :up
        notes = arp_notes.sort
      when :down
        notes = arp_notes.sort.reverse
      when :random
        notes = arp_notes.shuffle
      end
      
      # Играем арпеджио с разной скоростью
      division = [0.25, 0.125, 0.5].choose
      times = (4.0 / division).to_i
      
      play_midi_arpeggio notes, 2, 70, division, times
    end
  end
end

# Простая мелодия на электропиано
live_loop :piano_melody, sync: :pad_chords do
  # Играем мелодию только в 40% случаев
  if one_in(5)
    progression = chord_progressions.choose
    
    progression.each do |chord|
      # Создаем мелодию из нот аккорда и гаммы
      scale_notes = (scale chord[0], :minor_pentatonic, num_octaves: 1)
      melody_notes = (chord + scale_notes).uniq
      
      4.times do
        note = melody_notes.choose
        duration = [0.5, 0.75, 1.0].choose
        play_midi_note note, 3, 70, duration
        
        # Небольшая случайная пауза между нотами
        sleep [0.25, 0.5].choose
      end
    end
  else
    sleep 16  # Пропускаем цикл, если не играем мелодию
  end
end

# Ритмическая петля с различными паттернами
live_loop :drum_patterns, sync: :pad_chords do
  # Случайно выбираем паттерн
  pattern_keys = drum_patterns.keys
  pattern = pattern_keys.choose
  
  # Иногда полностью пропускаем барабаны для создания пространства
  if one_in(4)
    puts "Pausing drums for breath..."
    sleep 8
  else
    puts "Playing drum pattern: #{pattern}"
    
    # Проигрываем выбранный паттерн
    repeats = [2, 4, 8].choose
    play_drum_pattern pattern, repeats
  end
end

# Ритмическая модуляция для пэдов
live_loop :pad_modulation, sync: :pad_chords do
  # Отправляем различные CC для создания движения в звуке
  16.times do |i|
    if i % 4 == 0
      # Случайные изменения в фильтре и модуляции
      send_midi_cc 1, 40 + rand(40), 0   # Модуляция
      send_midi_cc 7, 100 - rand(20), 0  # Громкость
    end
    sleep 1
  end
end

puts "Retrowave Ambient теперь играет через iac_driver_bus_1"
puts "Откройте синтезатор или DAW и настройте его на прием MIDI с iac_driver_bus_1" 