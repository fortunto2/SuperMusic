# Название: Dynamic Retrowave Coding
# Стиль: Ретровейв, синтвейв, динамичный
# BPM: 110
# Дата создания: 2023-10-12
# 
# Используемые инструменты:
# - :tb303 (кислотный бас)
# - :dsaw (яркие синты)
# - :prophet (ретро-пэды)
# - :tech_saws (арпеджио)
# - :fm (металлические ноты)
# 
# Эффекты:
# - :distortion (для 80-х сатурации)
# - :flanger (для текстуры)
# - :echo (для пространства)
# - :bitcrusher (для ретро-звучания)
#
# Структура:
# - Динамичные 8-битные ритмы
# - Рандомные кислотные басовые линии
# - Арпеджио и мелодические пассажи
# - Постоянно меняющиеся структуры

# Динамичный ретровейв на 110 BPM
use_bpm 110

# Основная функция для рандомизации паттернов
define :random_pattern do |length|
  Array.new(length) { [1, 0, 0, 1, 1, 0].choose }
end

# Рандомные ноты из гаммы
define :random_notes_from_scale do |scale_type, octave|
  scale([:c, :d, :e, :f].choose, scale_type, num_octaves: 1).map { |n| n + octave * 12 }
end

# Общие эффекты для ретровейв атмосферы
with_fx :reverb, mix: 0.4, room: 0.6 do
  
  # Рандомные басовые линии
  live_loop :acid_bass do
    use_random_seed rand(1000)
    use_synth :tb303
    
    # Рандомный паттерн каждые 8 тактов
    pattern = random_pattern(16)
    
    notes = random_notes_from_scale(:minor_pentatonic, 2)
    cutoff_pattern = (line 70, 110, steps: 16).mirror
    
    with_fx :distortion, distort: 0.3 do
      16.times do |i|
        # Играем ноту только если в паттерне стоит 1
        if pattern[i] == 1
          play notes.choose, release: 0.2, cutoff: cutoff_pattern[i], res: 0.8, amp: 0.7
        end
        sleep 0.25
      end
    end
  end
  
  # Динамичные барабаны
  live_loop :drums, sync: :acid_bass do
    use_random_seed rand(500)
    
    kick_pattern = (ring 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0)
    snare_pattern = (ring 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0)
    hat_pattern = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)
    
    # Иногда используем рандомные паттерны для разнообразия
    kick_pattern = random_pattern(16) if one_in(4)
    snare_pattern = random_pattern(16) if one_in(4)
    
    with_fx :bitcrusher, bits: 8, sample_rate: 12000 do
      16.times do |i|
        sample :bd_tek, amp: 0.8, rate: 0.85 if kick_pattern[i] == 1
        sample :sn_dolf, amp: 0.6, rate: 0.8 if snare_pattern[i] == 1
        sample :drum_cymbal_closed, amp: 0.25, rate: 1.1 if hat_pattern[i] == 1
        
        # Случайные эффектные перкуссионные звуки
        sample :glitch_robot1, amp: 0.3, rate: 2 if i % 15 == 0 and one_in(3)
        sample :elec_blip, amp: 0.4, rate: rrand(0.8, 1.5) if i % 7 == 0 and one_in(4)
        
        sleep 0.25
      end
    end
  end
  
  # Динамичное арпеджио
  live_loop :energetic_arp, sync: :acid_bass do
    use_random_seed rand(300)
    use_synth :tech_saws
    
    # Случайно выбираем между несколькими паттернами арпеджио
    arp_styles = [
      (ring 0, 1, 2, 3, 7, 6, 5, 4),
      (ring 0, 2, 4, 7, 4, 2, 0, 5),
      (ring 0, 3, 7, 10, 12, 10, 7, 3)
    ]
    
    arp_pattern = arp_styles.choose
    root = [:c4, :a3, :f3, :g3].choose
    
    with_fx :flanger, feedback: 0.3 do
      with_fx :echo, mix: 0.2, decay: 2, phase: 0.5 do
        8.times do |i|
          play root + arp_pattern[i], release: 0.2, cutoff: rrand(80, 110), amp: 0.4
          sleep [0.25, 0.5].choose
        end
      end
    end
  end
  
  # Динамичные синтовые аккорды
  live_loop :retro_chords, sync: :acid_bass do
    use_synth :dsaw
    
    # Вероятностная система для выбора аккордов
    if one_in(3)
      chords = [
        chord(:c3, :minor7),
        chord(:g2, :dominant7),
        chord(:a2, :minor7),
        chord(:f2, :major7)
      ]
    else
      chords = [
        chord(:e3, :minor7),
        chord(:b2, :minor7),
        chord(:g2, '7sus4'),
        chord(:a2, :minor7)
      ]
    end
    
    # Рандомно определяем, как часто играть аккорды
    if one_in(2)
      play chords.choose, release: 2, cutoff: rrand(75, 95), amp: 0.4
      sleep 4
    else
      2.times do
        play chords.choose, release: 1, cutoff: rrand(75, 95), amp: 0.4
        sleep 2
      end
    end
  end
  
  # Мелодические фрагменты
  live_loop :melody_fragments, sync: :acid_bass do
    use_synth :prophet
    
    # Пропускаем иногда для создания разнообразия
    if one_in(3)
      sleep 8
    else
      # Рандомный сид для повторяемости внутри цикла, но изменения между циклами
      use_random_seed rand(1000)
      
      notes = scale(:c4, [:minor_pentatonic, :dorian, :phrygian].choose)
      rhythm = [0.5, 0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.5]
      
      with_fx :echo, mix: 0.3, decay: 3 do
        with_fx :distortion, distort: 0.2 do
          8.times do |i|
            # Вероятностная игра нот
            if one_in(4)
              # Аккорд
              play chord(notes.choose, :minor), release: 0.3, cutoff: rrand(80, 100), amp: 0.3
            else
              # Отдельная нота
              play notes.choose, release: 0.3, cutoff: rrand(80, 100), amp: 0.3
            end
            sleep rhythm[i]
          end
        end
      end
    end
  end
  
  # Случайные эффекты и сэмплы
  live_loop :random_fx, sync: :acid_bass do
    # Рандомный выбор между разными типами эффектов
    effect_type = [:glitch, :sweep, :transition].choose
    
    case effect_type
    when :glitch
      sample [:glitch_perc1, :glitch_perc2, :glitch_robot1, :glitch_robot2].choose,
        rate: rrand(0.5, 2.0), amp: 0.4
      sleep [4, 8].choose
    when :sweep
      with_fx :bitcrusher, bits: 8, sample_rate: 5000 do
        with_fx :flanger, depth: 10 do
          use_synth :fm
          play (scale :c3, :minor_pentatonic).choose, release: 4, amp: 0.3
        end
      end
      sleep 8
    when :transition
      4.times do
        sample :elec_blip2, rate: rrand(0.8, 1.5), amp: 0.3
        sleep 0.5
      end
    end
  end
  
  # 8-битные мелодические линии
  live_loop :bit_melody, sync: :acid_bass do
    use_synth :chiplead
    use_synth_defaults release: 0.2, amp: 0.25
    
    # 50% вероятность пропуска этого цикла
    if one_in(2)
      sleep 8
    else
      use_random_seed rand(500)
      
      notes = random_notes_from_scale([:minor, :minor_pentatonic, :melodic_minor].choose, 4)
      
      with_fx :bitcrusher, bits: 4, sample_rate: 10000 do
        16.times do |i|
          play notes.choose if [1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1].ring[i] == 1
          sleep 0.25
        end
      end
    end
  end
end 