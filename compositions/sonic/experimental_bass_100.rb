# Название: Experimental Dark Bass
# Стиль: Experimental, Dark Electronic
# BPM: 100
# Дата создания: 2023-08-21
# 
# Используемые инструменты:
# - :tb303 (кислотный бас)
# - :dsaw (тяжелый бас)
# - :gnoise (шум)
# - :bd_haus (бочка)
# - :elec_blip (перкуссия)
# 
# Эффекты:
# - :distortion (mix: 0.5)
# - :bitcrusher (mix: 0.3)
# - :echo (mix: 0.2, decay: 4)
# - :flanger (mix: 0.4)
#
# Структура:
# - Глубокий агрессивный бас
# - Глитчевые биты
# - Индустриальные текстуры

use_bpm 100

# Основной мрачный бас
live_loop :dark_bass do
  use_synth :tb303
  use_synth_defaults cutoff: rrand(60, 110), res: 0.9, attack: 0.01, release: 0.8, env_curve: 7
  
  with_fx :distortion, mix: 0.5 do
    with_fx :bitcrusher, mix: 0.3, bits: 8, sample_rate: 4000 do
      notes = ring :e1, :e1, :g1, :e0, :c1, :c1, :a0, :b0
      times = ring 0.25, 0.25, 0.75, 0.25, 0.25, 0.5, 0.25, 0.5
      
      play_pattern_timed notes, times, amp: 0.8
    end
  end
end

# Суб-бас для усиления низких
live_loop :sub_bass, sync: :dark_bass do
  use_synth :dsaw
  use_synth_defaults attack: 0.1, sustain: 0.2, release: 0.5
  
  with_fx :lpf, cutoff: 65 do
    with_fx :flanger, mix: 0.4 do
      if spread(3, 8).look
        play_pattern_timed [:e0, :e0, :g0], [0.75, 0.75, 1.5], amp: 1.8
      else
        play_pattern_timed [:c0, :c0, :a-1], [0.75, 0.75, 1.5], amp: 1.8
      end
    end
  end
  
  sleep 3
end

# Глитчевые удары
live_loop :glitch_beat, sync: :dark_bass do
  use_synth :cnoise
  use_synth_defaults attack: 0.05, sustain: 0.05, release: 0.1
  
  with_fx :echo, mix: 0.2, phase: 0.5, decay: 4 do
    n = rrand_i(36, 60)
    if one_in(4)
      16.times do
        play n, amp: rrand(0.1, 0.5) * line(0, 1, steps: 16).mirror.look
        sleep 0.125
      end
    else
      8.times do
        play n, amp: rrand(0.1, 0.5) if spread(5, 8).look
        sleep 0.25
      end
    end
  end
end

# Индустриальная перкуссия
live_loop :industrial_perc, sync: :dark_bass do
  with_fx :distortion, mix: 0.3 do
    sample :bd_haus, rate: 0.8, amp: 1.2
    sleep 0.5
    sample :elec_blip, rate: rrand(0.8, 1.2), amp: 0.7 if one_in(3)
    sleep 0.5
  end
end

# Шумовые текстуры
live_loop :noise_texture, sync: :dark_bass do
  use_synth :gnoise
  use_synth_defaults attack: 1, sustain: 2, release: 3
  
  with_fx :hpf, cutoff: 90 do
    with_fx :reverb, mix: 0.7, room: 0.9 do
      play 60, amp: 0.3
      sleep 8
    end
  end
end 