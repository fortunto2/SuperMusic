# Название: Prophet Ambient Variations
# Стиль: Ambient, Atmospheric
# BPM: 80
# Дата создания: 2023-12-11
# 
# Используемые инструменты:
# - :prophet (основные ноты с различными вариациями)
# - :dsaw (дополнительные ноты)
# 
# Эффекты:
# - :reverb (mix: 0.8, room: 0.9)
# - :echo (mix: 0.3, decay: 4)
#
# Структура:
# - Три основных цикла с нотами D1, G1, A1
# - Разные модуляции параметров для создания вариаций
# - Атмосферные слои с изменяемыми параметрами
# - Переменные для удобного управления композицией

# Основные настройки для удобной модуляции
use_bpm 80

# Переменные для удобного управления
main_amp = 0.7       # Общая громкость (0.0-1.0)
cutoff_min = 70      # Минимальное значение среза (40-80)
cutoff_max = 120     # Максимальное значение среза (90-130)
reverb_amount = 0.8  # Количество реверберации (0.0-1.0)
echo_amount = 0.3    # Количество эхо (0.0-0.5)
release_time = 8     # Время затухания ноты (4-12)

# Основной эффект реверберации для всех циклов
with_fx :reverb, mix: reverb_amount, room: 0.9 do
  with_fx :echo, mix: echo_amount, decay: 4, phase: 1 do
    
    # Первый цикл - нижняя нота D1
    live_loop :bass_d do
      use_synth :prophet
      play :d1, release: release_time, amp: main_amp, 
        cutoff: rrand(cutoff_min, cutoff_max)
      sleep 2
    end
    
    # Второй цикл - нота G1 с меняющимся cutoff
    live_loop :mid_g do
      sync :bass_d
      use_synth :prophet
      play :g1, release: release_time, amp: main_amp * 0.8, 
        cutoff: rrand(cutoff_min, cutoff_max)
      sleep 2
    end
    
    # Третий цикл - нота A1 и сэмпл
    live_loop :high_a do
      sync :bass_d
      sample :loop_garzul, rate: 1, amp: main_amp * 0.6
      use_synth :prophet
      play :a1, release: release_time, amp: main_amp * 0.7, 
        cutoff: rrand(cutoff_min, cutoff_max)
      sleep 8
    end
    
    # Дополнительный цикл с синтом dsaw для текстуры
    live_loop :texture do
      sync :bass_d
      use_synth :dsaw
      play chord(:d2, :minor), release: release_time * 0.75, 
        amp: main_amp * 0.4, cutoff: rrand(cutoff_min, cutoff_max - 30)
      sleep 4
    end
  end
end 