# Название: Simple Ambient for Surge
# Стиль: Эмбиент, Атмосферный, Минималистичный
# BPM: 70
# Дата создания: 2023-09-20
# 
# Используемые MIDI-инструменты:
# - Канал 0: Ambient Pad - основной слой пэдов
# - Канал 1: Slow Arpeggio - медленное арпеджио
# - Канал 2: Atmospheric Lead - атмосферная мелодия
# - Канал 3: Textural Effects - эффекты и текстуры
#
# Предполагается использование с Surge Synthesizer, 
# настроенным на прием MIDI через IAC Driver Bus 1

# Проверяем доступные MIDI порты
puts "Доступные MIDI-порты:"
puts midi_available_ports

# Настраиваем MIDI порт 
use_midi_ports "IAC Driver Bus 1", nil
use_bpm 70

# --- Функции для работы с MIDI ---

# Отправка MIDI ноты с заданной длительностью
define :play_midi_note do |note, channel=0, velocity=80, duration=1|
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

# Отправка аккорда MIDI-нотами с удержанием
define :hold_midi_chord do |notes, channel=0, velocity=80|
  notes.each do |note|
    midi_note_start note, channel, velocity
    sleep 0.05 # Небольшая задержка между нотами
  end
end

# Выключение аккорда MIDI-нот
define :release_midi_chord do |notes, channel=0|
  notes.each do |note|
    midi_note_end note, channel
    sleep 0.05 # Небольшая задержка между нотами
  end
end

# Отправка MIDI Control Change
define :send_midi_cc do |cc_num, value, channel=0|
  midi_cc cc_num, value, channel: channel
end

# --- Инициализация ---
puts "Запуск Simple Ambient для Surge Synthesizer"

# --- Композиция ---

# Основная гармоническая прогрессия
chord_progression = [
  chord(:c3, :major7),    # Cmaj7
  chord(:a2, :minor7),    # Am7
  chord(:f2, :major7),    # Fmaj7
  chord(:g2, :sus4)       # Gsus4
]

# Арпеджио ноты для каждого аккорда
arpeggios = [
  (scale :c4, :major_pentatonic, num_octaves: 2),
  (scale :a3, :minor_pentatonic, num_octaves: 2),
  (scale :f3, :major_pentatonic, num_octaves: 2),
  (scale :g3, :mixolydian, num_octaves: 2)
]

# Главный пэд
live_loop :main_pad do
  chord_progression.each_with_index do |chord, idx|
    
    # Отправляем MIDI CC для изменения параметров
    send_midi_cc 1, 60 + rand(40), 0  # Модуляция
    send_midi_cc 74, 30 + rand(40), 0 # Яркость
    
    # Играем аккорд с долгим удержанием
    hold_midi_chord chord, 0, 60
    
    # Удерживаем аккорд
    sleep 8
    
    # Отпускаем ноты
    release_midi_chord chord, 0
    
    # Небольшая пауза между аккордами
    sleep 0.5
  end
end

# Медленное арпеджио
live_loop :slow_arpeggio, sync: :main_pad do
  chord_progression.each_with_index do |chord, idx|
    # Выбираем ноты для арпеджио
    arpeggio = arpeggios[idx]
    
    # Играем арпеджио с разной скоростью и интенсивностью
    8.times do
      if one_in(4) # Иногда пропускаем ноту для создания пространства
        sleep 1
      else
        note = arpeggio.choose
        velocity = 40 + rand(30)
        play_midi_note note, 1, velocity, 1
      end
    end
  end
end

# Атмосферная мелодия
live_loop :atmospheric_lead, sync: :main_pad do
  # Играем мелодию только с вероятностью 30%
  if one_in(3)
    chord_progression.each_with_index do |chord, idx|
      # Используем ноты из текущего аккорда и добавляем октаву выше
      melody_notes = chord + [chord[0] + 12, chord[1] + 12]
      
      # Создаем простую мелодию из этих нот
      4.times do
        if one_in(3) # Иногда пропускаем ноту
          sleep 2
        else
          note = melody_notes.choose
          duration = [1, 1.5, 2].choose
          play_midi_note note, 2, 50 + rand(30), duration
          sleep 2 - duration # Остаток времени
        end
      end
    end
  else
    # Если не играем мелодию в этом цикле, просто ждем
    sleep 8 * 4 # Пропускаем целый цикл аккордов
  end
end

# Текстурные эффекты
live_loop :textural_effects, sync: :main_pad do
  if one_in(2) # 50% шанс проигрывания в этом цикле
    # Выбираем группу нот для текстурных эффектов
    base_note = [:c4, :a3, :f3, :g3].choose
    texture_notes = (scale base_note, :minor_pentatonic).shuffle.take(3)
    
    # Отправляем MIDI CC для эффектов
    send_midi_cc 16, 20 + rand(80), 3 # Произвольный CC для эффекта 1
    send_midi_cc 17, 20 + rand(80), 3 # Произвольный CC для эффекта 2
    
    # Играем несколько быстрых нот для создания текстуры
    6.times do
      note = texture_notes.choose
      velocity = 30 + rand(30) # Более низкая громкость для фоновых текстур
      duration = [0.25, 0.5, 0.75].choose
      play_midi_note note, 3, velocity, duration
      sleep 0.5
    end
    
    # Пауза перед следующей текстурой
    sleep 4
  else
    # Если не играем текстуры, просто ждем
    sleep 8
  end
end

puts "Ambient для Surge теперь играет через IAC Driver Bus 1"
puts "Откройте Surge и настройте его на прием MIDI с IAC Driver Bus 1" 