# Название: Simple Retrowave Vibe
# Стиль: Retrowave, Synthwave, 80s
# BPM: 86
# Дата создания: 2023-12-11
# 
# Используемые инструменты:
# - :tb303 (ретро-бас)
# - :dsaw (синтвейв-пэды)
# - :prophet (атмосферные ноты)
# - Ударные: :bd_haus, :drum_cymbal_closed, :drum_snare_hard
# 
# Эффекты:
# - :reverb (mix: 0.4, room: 0.6)
# - :distortion (distort: 0.2)
# - :echo (mix: 0.3, decay: 2)
#
# Структура:
# - Классический ретровейв-ритм с бочкой на 4/4
# - Простой арпеджированный басовый паттерн
# - Ретро-синтезаторные пэды
# - Минималистичный и атмосферный звук

# Основные настройки
use_bpm 86

# Переменные для удобного управления
main_amp = 0.8       # Общая громкость (0.0-1.0)
bass_amp = 0.7       # Громкость баса (0.0-1.0)
drums_amp = 0.9      # Громкость ударных (0.0-1.0)
pad_amp = 0.5        # Громкость пэдов (0.0-1.0)
cutoff_bass = 90     # Срез для баса (70-110)
distortion = 0.2     # Искажение (0.0-0.3)

# Аккордовая последовательность в стиле ретровейв
chords = [
  chord(:a2, :minor),
  chord(:f2, :major),
  chord(:g2, :major),
  chord(:e2, :minor)
]

# Основные эффекты
with_fx :reverb, mix: 0.4, room: 0.6 do
  
  # Ритм-секция - простой ретровейв бит
  live_loop :retro_drums do
    sample :bd_haus, amp: drums_amp * 1.2, cutoff: 110
    sample :drum_cymbal_closed, amp: drums_amp * 0.6, rate: 1.1 if (spread 3, 8).tick
    sleep 0.5
    
    sample :drum_cymbal_closed, amp: drums_amp * 0.6, rate: 1.1
    sleep 0.5
    
    sample :bd_haus, amp: drums_amp * 1.2, cutoff: 110
    sample :drum_snare_hard, amp: drums_amp * 0.8
    sample :drum_cymbal_closed, amp: drums_amp * 0.6, rate: 1.1 if (spread 3, 8).look
    sleep 0.5
    
    sample :drum_cymbal_closed, amp: drums_amp * 0.6, rate: 1.1
    sleep 0.5
  end
  
  # Ретро-бас с арпеджио
  live_loop :retro_bass do
    with_fx :distortion, distort: distortion do
      use_synth :tb303
      
      # Перебираем аккорды
      current_chord = chords.ring.tick
      4.times do |i|
        play current_chord[i % current_chord.length], release: 0.2, cutoff: cutoff_bass,
          amp: bass_amp * 0.8, res: 0.3
        sleep [0.5, 0.25, 0.75, 0.5].ring[i]
      end
    end
  end
  
  # Синтвейв-пэды
  live_loop :synthwave_pads do
    sync :retro_bass
    
    with_fx :echo, mix: 0.3, decay: 2 do
      use_synth :dsaw
      
      # Проигрываем текущий аккорд как пэд
      current_chord = chords.ring.look
      play current_chord, release: 7, cutoff: 80, attack: 0.8,
        amp: pad_amp * 0.6, detune: 0.2
      
      sleep 8
    end
  end
  
  # Атмосферный слой для глубины
  live_loop :atmosphere do
    sync :retro_bass
    
    use_synth :prophet
    with_fx :hpf, cutoff: 70 do
      play chords.ring.look.first + 12, release: 6, 
        amp: pad_amp * 0.4, cutoff: 90, attack: 1
    end
    
    sleep 8
  end
end 