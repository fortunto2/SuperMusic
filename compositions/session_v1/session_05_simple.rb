# Название: Session 05 - Simple Loops
# Стиль: Минималистичный эмбиент с вариациями гаммы
# BPM: 100
# Дата создания: 2023-11-01
# 
# Используемые инструменты:
# - :prophet (основной синт)
# - :blade (атмосферные пэды)
# - :loop_garzul (ритмический сэмпл)
# - :ambi_choir (эмбиентный хор)
# 
# Структура:
# - Три основных цикла: бас, атмосфера и ритм
# - Вариации нот и аккордов для разнообразия гаммы
# - Длинные эмбиентные элементы для создания атмосферы
# - Бесконечное воспроизведение с синхронизацией

# Установка темпа 100 BPM
use_bpm 100

# Расширенный набор гамм и аккордов для большего разнообразия
gamma_sets = [
  { 
    notes: [:d1, :a1, :g1, :e1],
    chords: [chord(:d3, :minor7), chord(:a2, :major7), chord(:g3, :minor9), chord(:e3, '7sus4')]
  },
  { 
    notes: [:c1, :g1, :f1, :d1],
    chords: [chord(:c3, :major7), chord(:g2, :sus4), chord(:f3, :minor7), chord(:d3, :dim7)]
  },
  { 
    notes: [:e1, :b1, :a1, :f1],
    chords: [chord(:e3, :minor9), chord(:b2, :minor7), chord(:a3, :major7), chord(:f3, :dom7)]
  }
]

# Живой цикл для смены гамм каждые 32 удара
live_loop :gamma_selector do
  set :current_gamma, gamma_sets.ring.tick
  sleep 32
end

# Цикл 1: Глубокий бас на синте Prophet с ротацией нот
live_loop :deep_bass do
  use_synth :prophet
  
  # Получаем текущую гамму из shared state
  current_gamma = get[:current_gamma] || gamma_sets[0]
  notes = current_gamma[:notes]
  
  # Используем индекс для бесконечного перебора нот
  note_index = tick % 4
  note = notes[note_index]
  play note, release: 8, amp: 0.7, cutoff: 65
  sleep 8
end

# Цикл 2: Атмосферные пэды со случайным срезом фильтра и вариациями аккордов
live_loop :atmosphere, sync: :deep_bass do
  use_synth :blade
  
  # Получаем текущую гамму из shared state
  current_gamma = get[:current_gamma] || gamma_sets[0]
  chords = current_gamma[:chords]
  
  # Используем индекс для бесконечного перебора аккордов
  chord_index = tick % 4
  
  with_fx :reverb, mix: 0.8, room: 0.9 do
    play chords[chord_index], release: 8, sustain: 4, amp: 0.5, cutoff: rrand(70, 110)
    sleep 8
  end
end

# Цикл 3: Ритмический сэмпл с вариациями мелодических акцентов
live_loop :rhythm, sync: :deep_bass do
  # Получаем текущую гамму из shared state
  current_gamma = get[:current_gamma] || gamma_sets[0]
  notes = current_gamma[:notes]
  
  # Иногда пропускаем ритм для большей "эмбиентности", но реже (1 из 4)
  if one_in(4)
    sleep 8
  else
    with_fx :echo, mix: 0.4, decay: 4 do
      sample :loop_garzul, amp: 0.5, rate: 1.0
      sleep 4
      
      use_synth :prophet
      play notes.ring.tick, release: 4, amp: 0.4, cutoff: rrand(70, 100)
      sleep 4
    end
  end
end

# Добавляем четвертый цикл для длинных эмбиентных элементов
live_loop :ambient_textures, sync: :deep_bass do
  # Получаем текущую гамму из shared state
  current_gamma = get[:current_gamma] || gamma_sets[0]
  chords = current_gamma[:chords]
  
  # Выбор между разными эмбиентными звуками
  ambient_sample = [:ambi_choir, :ambi_dark_woosh, :ambi_haunted_hum, :ambi_lunar_land].ring
  
  # Используем tick для перебора семплов
  with_fx :reverb, mix: 0.9, room: 1 do
    with_fx :slicer, mix: 0.3, phase: 8, wave: 1, smooth: 1 do
      sample ambient_sample.look, rate: rrand(0.5, 0.8), amp: 0.3
      
      # Добавляем иногда случайный аккорд из текущей гаммы для большего разнообразия
      if one_in(3)
        use_synth :hollow
        play chords.choose, release: 16, amp: 0.2
      end
      
      tick
      sleep 16
    end
  end
end 