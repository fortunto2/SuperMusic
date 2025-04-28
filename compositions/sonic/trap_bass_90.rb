# Название: Trap Bass
# Стиль: Trap, Hip-hop
# BPM: 90
# Дата создания: 2023-08-20
# 
# Используемые инструменты:
# - :tb303 (бас)
# - :dsaw (суб-бас)
# - :drum_cymbal_closed (хай-хэт)
# - :bd_tek (бочка)
# - :drum_snare_hard (снэйр)
# 
# Эффекты:
# - :distortion (mix: 0.3)
# - :reverb (mix: 0.2, room: 0.7)
# - :lpf (частота: 80-120)
#
# Структура:
# - Тяжелая бочка и снэйр
# - Агрессивный 808 бас
# - Быстрые хай-хэты

use_bpm 90

# Главный бас
live_loop :bass do
  use_synth :tb303
  use_synth_defaults cutoff: 100, res: 0.8, attack: 0.01, release: 0.6, env_curve: 7
  with_fx :distortion, mix: 0.3 do
    with_fx :lpf, cutoff: 90, cutoff_slide: 4 do |f|
      control f, cutoff: 120
      play_pattern_timed [:e1, :e1, :e1, :g1, :r, :a0, :a0], [0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5], amp: 0.7
    end
  end
  sleep 1
end

# Суб-бас
live_loop :deep_bass, sync: :bass do
  use_synth :dsaw
  use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.2
  
  with_fx :lpf, cutoff: 70 do
    with_fx :distortion, mix: 0.3 do
      play_pattern_timed [:e0, :r, :r, :g0, :r, :a-1, :r], [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], amp: 1.5
    end
  end
  
  sleep 1
end

# Ударные - бочка
live_loop :kicks, sync: :bass do
  sample :bd_tek, rate: 0.9, amp: 1.5
  sleep 0.5
  sample :bd_tek, rate: 0.9, amp: 1.5
  sleep 0.5
end

# Ударные - снэйр
live_loop :snare, sync: :bass do
  sleep 0.5
  sample :drum_snare_hard, rate: 0.9, amp: 1.2
  sleep 0.5
end

# Хай-хэты
live_loop :hats, sync: :bass do
  with_fx :reverb, mix: 0.2, room: 0.7 do
    8.times do
      sample :drum_cymbal_closed, rate: rrand(1.0, 1.2), amp: rrand(0.5, 0.7) if rand < 0.9
      sleep 0.125
    end
  end
end

# Время от времени добавляем дополнительные перкуссии
live_loop :percussion, sync: :bass do
  sleep 2
  sample :elec_blip, rate: 0.8, amp: 0.6 if one_in(3)
  sleep 2
end 