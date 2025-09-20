# Название: Prophet с MIDI выводом
# Стиль: Ambient, Experimental
# BPM: 60
# Дата создания: 2023-12-11
# 
# Используемые инструменты:
# - :prophet (три разных слоя)
# - Сэмпл :loop_garzul
# - MIDI выход для одного из инструментов
# 
# Эффекты:
# - :reverb (для создания атмосферы)
# - Изменяющийся cutoff filter
#
# Структура:
# - Три слоя с нотами D1, G1, A1
# - Один из слоев дублируется на MIDI-устройство

# Основные настройки
use_bpm 60

# Переменные для удобного управления
midi_enabled = true           # Включать/выключать MIDI вывод
midi_port = :iac_driver_bus_1 # Порт для MIDI (используйте соответствующий вашей системе)
midi_channel = 1              # MIDI канал (1-16)
midi_instrument = 4           # MIDI инструмент (GM программа 1-128)
midi_velocity = 100           # MIDI громкость (velocity 0-127)

# Громкость каждого инструмента по отдельности
d1_amp = 0.7                  # Громкость басовой ноты D1 (0.0-1.0)
g1_amp = 0.5                  # Громкость ноты G1 - пониженная (0.0-1.0)
a1_amp = 0.7                  # Громкость ноты A1 (0.0-1.0)
garzul_amp = 0.5              # Громкость сэмпла loop_garzul (0.0-1.0)

# Другие параметры
reverb_amount = 0.6           # Количество реверберации (0.0-1.0)
cutoff_min = 70               # Минимальный фильтр (40-80)
cutoff_max = 130              # Максимальный фильтр (100-130)

# Настраиваем MIDI порт и инструмент, если включено
if midi_enabled
  use_midi_defaults port: midi_port, channel: midi_channel
  midi_program_change midi_instrument, port: midi_port, channel: midi_channel
end

# Основной эффект реверберации для всех циклов
with_fx :reverb, mix: reverb_amount, room: 0.8 do
  
  # Первый цикл с нотой D1
  live_loop :bass_d do
    use_synth :prophet
    play :d1, release: 8, amp: d1_amp
    
    # Дублируем на MIDI, если включено
    if midi_enabled
      midi :d1, sustain: 7, release: 1, vel: midi_velocity
    end
    
    sleep 2
  end
  
  # Второй цикл с нотой G1 - с пониженной громкостью
  live_loop :mid_g do
    use_synth :prophet
    current_cutoff = rrand(cutoff_min, cutoff_max)
    
    play :g1, release: 8, amp: g1_amp, cutoff: current_cutoff
    
    sleep 2
  end
  
  # Третий цикл с нотой A1 и сэмплом
  live_loop :high_a do
    sample :loop_garzul, amp: garzul_amp
    use_synth :prophet
    
    play :a1, release: 8, amp: a1_amp, cutoff: rrand(cutoff_min, cutoff_max)
    
    sleep 8
  end
end 