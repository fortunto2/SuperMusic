# Sonic Pi - Живое выступление с отправкой MIDI в GarageBand
# Автор: Claude AI для проекта SuperMusic

# Настройка MIDI-порта (IAC Driver Bus 1)
use_midi_defaults port: "IAC Driver Bus 1", channel: 0

# --- Определение музыкальных данных ---

# Ноты в форме хеша для легкого поиска
NOTES = {
  c: 60, cs: 61, d: 62, ds: 63, e: 64, f: 65, 
  fs: 66, g: 67, gs: 68, a: 69, as: 70, b: 71
}

# Прогрессии аккордов для разных частей
CHORD_PROGRESSIONS = {
  intro: [[:c, :major], [:g, :major], [:a, :minor], [:f, :major]],
  verse: [[:c, :major7], [:e, :minor7], [:f, :major7], [:g, :dominant]],
  chorus: [[:a, :minor], [:f, :major], [:c, :major], [:g, :major]],
  bridge: [[:d, :minor7], [:g, :dominant], [:e, :minor7], [:a, :minor7]]
}

# Функция для получения нот аккорда
define :chord_notes do |root, type|
  root_note = NOTES[root] || 60
  
  case type
  when :major
    [root_note, root_note + 4, root_note + 7]
  when :minor
    [root_note, root_note + 3, root_note + 7]
  when :major7
    [root_note, root_note + 4, root_note + 7, root_note + 11]
  when :minor7
    [root_note, root_note + 3, root_note + 7, root_note + 10]
  when :dominant
    [root_note, root_note + 4, root_note + 7, root_note + 10]
  else
    [root_note, root_note + 4, root_note + 7]
  end
end

# --- Функции для работы с MIDI ---

# Отправить сообщение смены инструмента
define :change_instrument do |program, chan = 0|
  midi_program_change program, port: "IAC Driver Bus 1", channel: chan
  puts "MIDI Program Change: #{program} на канале #{chan}"
end

# Сыграть MIDI-ноту
define :play_midi_note do |note, vel = 80, dur = 1, chan = 0|
  midi_note_on note, vel, port: "IAC Driver Bus 1", channel: chan
  sleep dur
  midi_note_off note, port: "IAC Driver Bus 1", channel: chan
end

# Сыграть аккорд
define :play_midi_chord do |notes, vel = 80, dur = 1, chan = 0|
  notes.each do |note|
    midi_note_on note, vel, port: "IAC Driver Bus 1", channel: chan
    sleep 0.01
  end
  sleep dur
  notes.each do |note|
    midi_note_off note, port: "IAC Driver Bus 1", channel: chan
    sleep 0.01
  end
end

# --- Управление живым выступлением ---
define :start_section do |section_name, bpm_val = 120|
  use_bpm bpm_val
  set :current_section, section_name
  puts "Начинаем секцию: #{section_name} (BPM: #{bpm_val})"
end

# --- Настройка переменных для живого кодирования ---
set :play_chords, true
set :play_bass, true
set :play_melody, true
set :improvise, false
set :current_section, :intro
set :current_bar, 0
set :bpm, 120

# Проверка доступности MIDI-портов
puts "Доступные MIDI-порты:"
puts midi_available_ports

use_bpm get(:bpm)

# --- Живые петли ---

# Петля аккордов
live_loop :chords do
  if get(:play_chords)
    section = get(:current_section)
    progression = CHORD_PROGRESSIONS[section]
    
    # Выбираем аккорд в зависимости от текущего такта
    current_chord_idx = get(:current_bar) % progression.length
    chord_sym, chord_type = progression[current_chord_idx]
    
    # Получаем ноты аккорда
    notes = chord_notes(chord_sym, chord_type)
    
    # Отправляем через MIDI
    puts "Playing chord: #{chord_sym} #{chord_type} - #{notes}"
    
    # Разные инструменты для разных секций
    case section
    when :intro
      change_instrument 0, 0  # Piano
      play_midi_chord notes, 70, 4, 0
    when :verse
      change_instrument 48, 0  # Strings
      play_midi_chord notes, 60, 4, 0
    when :chorus
      change_instrument 52, 0  # Choir
      play_midi_chord notes, 80, 4, 0
    when :bridge
      change_instrument 89, 0  # Pad
      play_midi_chord notes, 60, 4, 0
    end
  else
    sleep 4
  end
end

# Басовая линия
live_loop :bass do
  sync :chords
  
  if get(:play_bass)
    section = get(:current_section)
    progression = CHORD_PROGRESSIONS[section]
    
    # Выбираем аккорд в зависимости от текущего такта
    current_chord_idx = get(:current_bar) % progression.length
    chord_sym, chord_type = progression[current_chord_idx]
    
    # Получаем основную ноту (бас)
    root_note = NOTES[chord_sym] - 24  # 2 октавы ниже
    
    # Отправляем через MIDI
    change_instrument 33, 1  # Finger Bass на канале 1
    
    # Различные басовые паттерны в зависимости от секции
    case section
    when :intro
      play_midi_note root_note, 100, 1, 1
      sleep 1
      play_midi_note root_note, 80, 0.5, 1
      sleep 0.5
      play_midi_note root_note + 7, 80, 0.5, 1
      sleep 0.5
      play_midi_note root_note + 12, 80, 1.5, 1
    when :verse
      4.times do
        play_midi_note root_note, 100, 0.75, 1
        sleep 0.75
        play_midi_note root_note + 7, 80, 0.25, 1
      end
    when :chorus
      notes = [root_note, root_note+7, root_note+5, root_note]
      durations = [1, 1, 1, 1]
      notes.each_with_index do |n, i|
        play_midi_note n, 90, durations[i], 1
      end
    when :bridge
      notes = [root_note, root_note, root_note+7, root_note+12]
      notes.each do |n|
        play_midi_note n, 85, 0.5, 1
        sleep 0.5
      end
      sleep 2
    end
  else
    sleep 4
  end
end

# Счетчик тактов
live_loop :bar_counter do
  sync :chords
  current_bar = get(:current_bar)
  set :current_bar, current_bar + 1
  puts "Такт: #{current_bar + 1}"
  sleep 4
end

# --- Пример управления живым выступлением ---

# Начинаем композицию
puts "Запуск живого выступления!"
sleep 2  # Ожидаем 2 секунды перед началом

# Вступление
start_section :intro, 100
sleep 16  # 4 такта

# Куплет
start_section :verse, 110
sleep 16  # 4 такта

# Припев
start_section :chorus, 120
sleep 16  # 4 такта

# Снова куплет
start_section :verse, 110
sleep 16  # 4 такта

# Бридж
start_section :bridge, 100
sleep 16  # 4 такта

# Финальный припев
start_section :chorus, 120
sleep 16  # 4 такта

# Завершение
puts "Композиция завершена!"
set :play_chords, false
set :play_bass, false
set :play_melody, false 