# Название: Retrowave Ambient
# Стиль: Ретро-синтвейв, амбиент
# BPM: 120
# Дата создания: 2023-08-15
# 
# Используемые инструменты:
# - :prophet (аккорды)
# - :blade (пэды)
# - :dsaw (арпеджио)
# - :tb303 (бас)
# 
# Эффекты:
# - :reverb (mix: 0.7, room: 0.9)
# - :echo (mix: 0.4, decay: 8)
#
# Структура:
# - Основные аккорды: Em7-Cmaj7-Am7-D7
# - Арпеджио на минорной пентатонике
# - Ретро-ударные и атмосферные эффекты

# Ambient Retrowave melody at 120 BPM

use_bpm 120

# Reverb and delay settings for ambient atmosphere
with_fx :reverb, mix: 0.7, room: 0.9 do
  with_fx :echo, mix: 0.4, decay: 8, phase: 0.5 do

    # Retro synth chords
    live_loop :retro_chords do
      use_synth :prophet
      chord_progression = [
        chord(:E3, :m7),
        chord(:C3, :major7),
        chord(:A3, :m7), 
        chord(:D3, '7')
      ]
      
      chord_progression.each do |c|
        play c, release: 4, cutoff: 80, amp: 0.7
        sleep 4
      end
    end

    # Dreamy pad
    live_loop :ambient_pad, sync: :retro_chords do
      use_synth :blade
      notes = [:E4, :B3, :G3, :A3]
      
      notes.each do |n|
        play n, attack: 2, release: 6, amp: 0.4
        sleep 4
      end
    end
    
    # Retrowave arpeggios
    live_loop :retro_arp, sync: :retro_chords do
      use_synth :dsaw
      use_synth_defaults cutoff: 95, release: 0.2, amp: 0.35
      
      notes = scale(:e3, :minor_pentatonic, num_octaves: 2)
      16.times do
        play notes.choose, pan: rrand(-0.7, 0.7)
        sleep 0.25
      end
    end
    
    # 80s style bass
    live_loop :bass, sync: :retro_chords do
      use_synth :tb303
      use_synth_defaults cutoff: 90, res: 0.5, release: 0.5, amp: 0.8
      
      pattern = [:e1, :e1, :r, :e1, :c2, :c2, :r, :c2, :a1, :a1, :r, :a1, :d2, :d2, :r, :d2]
      pattern.each do |n|
        play n if n != :r
        sleep 0.5
      end
    end
    
    # Sparse retro drums
    live_loop :drums, sync: :retro_chords do
      sample :bd_klub, rate: 0.8, amp: 1.0 if (spread 4, 16).tick
      sample :drum_cymbal_closed, rate: 1.5, amp: 0.2 if (spread 8, 16).look
      sample :sn_dolf, rate: 0.7, amp: 0.4 if (spread 2, 16).look
      
      sleep 0.25
    end
    
    # Occasional atmospheric sounds
    live_loop :atmosphere, sync: :retro_chords do
      sample :ambi_lunar_land, rate: 0.5, amp: 0.3
      sleep 16
    end
  end
end 