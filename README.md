# SuperMusic

Коллекция музыкальных композиций, созданных с помощью Sonic Pi и MIDI-интеграции с GarageBand.

## О проекте

Этот репозиторий содержит набор музыкальных композиций, созданных с использованием Sonic Pi — инструмента для кодирования музыки. Особенность проекта в том, что композиции также могут отправляться через MIDI в GarageBand для дальнейшей обработки и аранжировки.

## Инструменты для создания музыки с помощью кода

1. **Sonic Pi** - мощный инструмент для программирования музыки на языке Ruby
2. **Glicol** - современный веб-инструмент для программирования музыки на языке JavaScript
3. **Gibber** - https://gibber.cc/playground/index.html
4. **Strudel** - https://strudel.cc/
5. **Orca** - https://100r.co/site/orca.html
6. **NoiseCraft** - https://noisecraft.app/1735 - модульный синтез 
7. **Surge Synthesizer** - https://surge-synthesizer.github.io/

## Структура проекта

- `compositions/` - папка с композициями
  - `sonic/` - композиции для Sonic Pi
  - `strudel/` - композиции для Strudel (веб-интерфейс для создания музыки)
- `midi_chord_progression.py` - генератор аккордовых последовательностей
- `send_midi.py` - утилита для отправки MIDI-сообщений
- `sonic_garageband_live.rb` - интеграция Sonic Pi с GarageBand
- `sonic_pi_midi_thru.rb` - проброс MIDI-сообщений через Sonic Pi
- `sonic_pi_osc.py` - управление Sonic Pi через OSC-протокол
- `sonic_to_garageband.rb` - передача звука из Sonic Pi в GarageBand

## Композиции

### Ambient Dreamscape (90 BPM)
- Файл: `compositions/sonic/ambient_dreamscape_90_midi.rb`
- Стиль: Эмбиент, Атмосферный
- Использует MIDI интеграцию с GarageBand через IAC Driver Bus 1

### Drum & Bass (160 BPM)
- Файл: `compositions/sonic/drum_bass_160_midi.rb`
- Стиль: Drum & Bass, Electronic
- Использует MIDI интеграцию с GarageBand через IAC Driver Bus 1

## Настройка MIDI для macOS

1. Откройте Audio MIDI Setup (Настройка Audio MIDI)
2. Откройте окно MIDI Studio (Window > Show MIDI Studio)
3. Дважды щелкните на IAC Driver
4. Убедитесь, что опция "Device is online" включена
5. Создайте порт "IAC Driver Bus 1", если он отсутствует

## Запуск композиций

1. Откройте Sonic Pi
2. Загрузите файл композиции (`File > Open`)
3. Запустите код (кнопка Run)
4. Откройте GarageBand и настройте MIDI вход на "IAC Driver Bus 1"

## Лицензия

Этот проект распространяется под лицензией MIT. 