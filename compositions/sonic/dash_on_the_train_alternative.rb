# Название: Dash On The Train (Alternative)
# Стиль: Experimental, Minimalist
# BPM: 30 (cpm в оригинале)
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
# - Аккорды [C G] чередуются с нотами из последовательности D Fb B C A
# - Постепенно меняющийся фильтр cutoff
# - Панорамирование между левым и правым каналами
# - Общее замедление через модификатор .slow(".1275")

# Основные настройки
use_bpm 30

# Переменные для основных параметров
gain = 0.8            # .gain(.8)
roomsize = 10         # .roomsize("10")
slow_factor = 0.1275  # .slow(".1275")

# Паттерн нот для цикла live_loop
def note_sequence(tick_count)
  # Соответствует "[C G], <D Fb B C A>*[0.5,2]"
  if tick_count % 2 == 0
    # Возвращаем аккорд [C G]
    return [:C4, :G4], 1
  else
    # Определяем какая нота из <D Fb B C A> будет играть
    notes = [:D4, :Fb4, :B3, :C4, :A3]
    note_index = (tick_count / 2) % notes.length
    
    # Определяем множитель времени из [0.5, 2]
    time_multiplier = [(tick_count / 2) % 2 == 0 ? 0.5 : 2.0]
    
    return notes[note_index], time_multiplier[0]
  end
end

# Для модуляции lpf фильтра
# Соответствует "<100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1300 1200 1100 1000 900 800 700 600 500 400 300 200>/4"
def lpf_sequence(tick_count)
  lpf_values = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400,
               1300, 1200, 1100, 1000, 900, 800, 700, 600, 500, 400, 300, 200]
  
  # Деление на 4 в "/4" означает более медленную смену значений
  index = (tick_count / 4) % lpf_values.length
  return lpf_values[index]
end

# Для модуляции панорамирования
# Соответствует "<0 1>/2"
def pan_sequence(tick_count)
  # Деление на 2 в "/2" означает более медленную смену значений
  index = (tick_count / 2) % 2
  return [0, 1][index]
end

# Применяем эффекты реверберации и эхо
with_fx :reverb, mix: 1, room: roomsize do
  with_fx :echo, mix: 1, decay: 4, phase: 0.25 do
    
    # Основной live_loop
    live_loop :dash_on_the_train do
      # Получаем текущий tick для последовательностей
      t = tick
      
      # Получаем ноту/аккорд и множитель времени
      current_note, time_multiplier = note_sequence(t)
      
      # Получаем текущее значение lpf фильтра
      current_lpf = lpf_sequence(t)
      
      # Получаем текущее значение панорамирования
      current_pan = pan_sequence(t)
      
      # Вычисляем длительность на основе slow_factor
      actual_sleep = 0.5 * (1.0 / slow_factor) * time_multiplier
      
      # Играем ноту или аккорд
      use_synth :saw
      play current_note, amp: gain, 
        release: [actual_sleep * 0.8, 8].min, # Ограничиваем release, чтобы избежать слишком длительных нот
        cutoff: current_lpf,
        pan: current_pan
      
      sleep actual_sleep
    end
  end
end 