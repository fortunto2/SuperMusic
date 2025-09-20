# Название: Cinematic Prophet Atmospheres
# Стиль: Cinematic, Ambient, Atmospheric
# BPM: 60
# Дата создания: 2023-12-11
# 
# Используемые инструменты:
# - :prophet (основные ноты и аккорды)
# - :blade (атмосферные пэды)
# - :hollow (фоновые текстуры)
# 
# Эффекты:
# - :reverb (mix: 0.9, room: 1.0)
# - :echo (mix: 0.5, decay: 12)
# - :pitch_shift (window_size: 0.2, pitch: -2)
#
# Структура:
# - Медленно развивающиеся ноты D1, G1, A1
# - Протяжные атмосферные слои
# - Кинематографические постепенные нарастания
# - Глубокие пространственные текстуры

# Основные настройки
use_bpm 60

# Переменные для удобного управления
main_amp = 0.6       # Общая громкость (0.0-1.0)
reverb_depth = 0.9   # Глубина реверберации (0.7-1.0)
echo_depth = 0.5     # Глубина эхо (0.0-0.7)
release_time = 12    # Длительное время затухания (8-16)
cutoff_low = 60      # Низкий срез (40-70)
cutoff_high = 90     # Высокий срез (80-110)

# Основной эффект реверберации и эхо для создания пространства
with_fx :reverb, mix: reverb_depth, room: 1.0 do
  with_fx :echo, mix: echo_depth, decay: 12, phase: 3 do
    with_fx :pitch_shift, window_size: 0.2, pitch: -2, mix: 0.3 do
      
      # Первый кинематографический слой с нотой D1
      live_loop :cinematic_d do
        use_synth :prophet
        note = :d1
        play note, release: release_time, sustain: 2, 
          amp: main_amp * rrand(0.8, 1.0), 
          cutoff: cutoff_low + (line 0, 30, steps: 16).tick
        sleep 4
      end
      
      # Второй слой с нотой G1
      live_loop :evolving_g do
        sync :cinematic_d
        use_synth :prophet
        sleep 2
        play :g1, release: release_time, sustain: 4, 
          amp: main_amp * 0.7, 
          cutoff: cutoff_low + rrand(10, 40)
        sleep 6
      end
      
      # Слой с атмосферным сэмплом и нотой A1
      live_loop :atmospheric_a do
        sync :cinematic_d
        with_fx :hpf, cutoff: 30 do
          sample :loop_garzul, rate: 0.5, 
            amp: main_amp * 0.4, 
            attack: 2, release: 4
        end
        
        sleep 4
        use_synth :blade
        play :a2, release: release_time * 1.5, 
          amp: main_amp * 0.5, 
          cutoff: cutoff_high - 20
        sleep 12
      end
      
      # Фоновый текстурный слой с аккордами
      live_loop :background_texture do
        sync :cinematic_d
        use_synth :hollow
        
        chord_progression = [
          chord(:d2, :minor7),
          chord(:a2, :minor),
          chord(:g2, :major7),
          chord(:c3, :major)
        ]
        
        with_fx :slicer, phase: 8, wave: 1, mix: 0.3 do
          play chord_progression.ring.tick, 
            release: release_time * 0.8, 
            amp: main_amp * 0.3, 
            cutoff: cutoff_high
        end
        
        sleep 8
      end
      
      # Медленно пульсирующий высокий элемент
      live_loop :high_pulses do
        sync :cinematic_d
        sleep 4
        use_synth :prophet
        with_fx :lpf, cutoff: 100 do
          play :d4, release: 6, amp: main_amp * 0.2, 
            cutoff: 90 + (range -10, 30).mirror.tick
        end
        sleep 4
      end
    end
  end
end 