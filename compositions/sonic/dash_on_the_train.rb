# Название: Dash On The Train
# Стиль: Experimental, Minimalist
# BPM: 30 (от оригинала)
# Дата создания: 2023-12-11
# Конвертировано из Strudel
# 
# Используемые инструменты:
# - :saw (пилообразная волна - sawtooth)
# 
# Эффекты:
# - :lpf (низкочастотный фильтр со сложной модуляцией)
# - :reverb (объемная реверберация)
# - :echo (delay в оригинале)
# - :pan (панорамирование между левым и правым каналами)
#
# Структура:
# - Минималистичный паттерн нот с вариациями
# - Сложная модуляция фильтра
# - Замедление темпа для создания эффекта растянутого времени

# Основные настройки
use_bpm 30

# Переменные для удобного управления
cpm_modifier = 0.1275  # Эквивалент .slow(".1275") в Strudel
main_amp = 0.8         # Gain параметр из оригинала
reverb_size = 1.0      # Эквивалент .room(1)
echo_level = 1.0       # Эквивалент .delay(1)

# Создаем паттерны нот, аналогичные оригиналу
notes_pattern1 = [:C4, :G4]
notes_pattern2 = [:D4, :Fb4, :B3, :C4, :A3].ring  # Используем .ring для зацикливания

# Паттерн для lpf, преобразованный в кольцо
lpf_values = (100..1400).step(100).to_a + (1300..200).step(-100).to_a
lpf_pattern = lpf_values.ring

# Паттерн панорамирования (0 - лево, 1 - право)
pan_pattern = [0, 1].ring

# Основные эффекты
with_fx :reverb, mix: reverb_size, room: 0.9 do
  with_fx :echo, mix: echo_level, decay: 4, phase: 0.5 do
    
    # Основной музыкальный цикл
    live_loop :dash_on_the_train do
      # Рассчитываем фактический темп с учетом модификатора
      current_sleep = 0.5 * (1.0 / cpm_modifier)
      
      # Панорамирование между левым и правым каналом
      current_pan = pan_pattern.look
      
      # Получаем текущее значение фильтра из паттерна
      current_lpf = lpf_pattern.tick
      
      # Перебираем ноты по очереди
      use_synth :saw
      
      # Первый аккорд (C G)
      play notes_pattern1, release: current_sleep * 0.8, 
        amp: main_amp, 
        pan: current_pan,
        cutoff: current_lpf
      
      sleep current_sleep
      
      # Вторая нота из кольца с множителем времени
      note_idx = (tick(:note_index) / 2) % notes_pattern2.length
      
      # Множитель времени из [0.5, 2], чередующийся как в оригинале
      time_multiplier = [0.5, 2].ring.look
      
      play notes_pattern2[note_idx], release: current_sleep * 0.8 * time_multiplier, 
        amp: main_amp, 
        pan: current_pan,
        cutoff: current_lpf
      
      sleep current_sleep * time_multiplier
    end
  end
end 