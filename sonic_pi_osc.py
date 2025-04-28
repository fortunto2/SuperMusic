#!/usr/bin/env python3
import time
import sys
import random
import argparse
from pythonosc import udp_client

# Sonic Pi по умолчанию слушает OSC-сообщения на порту 4557
SONIC_PI_PORT = 4557
SONIC_PI_HOST = "127.0.0.1"  # localhost

# Ноты и аккорды
NOTES = {
    "C": 60,
    "C#": 61,
    "Db": 61,
    "D": 62,
    "D#": 63,
    "Eb": 63,
    "E": 64,
    "F": 65,
    "F#": 66,
    "Gb": 66,
    "G": 67,
    "G#": 68,
    "Ab": 68,
    "A": 69,
    "A#": 70,
    "Bb": 70,
    "B": 71,
}

CHORD_PROGRESSIONS = {
    "pop": ["C", "G", "Am", "F"],
    "jazz": ["Dm7", "G7", "Cmaj7", "Cmaj7"],
    "blues": ["C7", "F7", "C7", "G7", "F7", "C7"],
    "rock": ["A", "D", "E", "D"],
}


def create_osc_client():
    """Создает OSC-клиент для соединения с Sonic Pi"""
    return udp_client.SimpleUDPClient(SONIC_PI_HOST, SONIC_PI_PORT)


def send_sonic_pi_code(client, code):
    """Отправляет Ruby-код в Sonic Pi через OSC"""
    # Адрес /run используется для выполнения кода в Sonic Pi
    client.send_message("/run-code", code)
    print(f"Отправлен код в Sonic Pi:\n{code}\n")


def play_simple_melody(client):
    """Играет простую мелодию в Sonic Pi"""
    code = """
# Простая мелодия на синтезаторе
use_synth :prophet
play_pattern_timed [:c4, :e4, :g4, :c5], [0.5, 0.25, 0.25, 1]
sleep 1
play_pattern_timed [:e4, :g4, :b4, :c5], [0.5, 0.25, 0.25, 1]
    """
    send_sonic_pi_code(client, code)


def play_chord_progression(client, progression_type="pop", synth="prophet", bpm=120):
    """Играет прогрессию аккордов в Sonic Pi"""
    progression = CHORD_PROGRESSIONS.get(progression_type, CHORD_PROGRESSIONS["pop"])

    code = f"""
# Прогрессия аккордов с типом: {progression_type}
use_bpm {bpm}
use_synth :{synth}

live_loop :chord_progression do
  {' '.join([f'play_chord :{chord.lower()}, release: 2' + '\n  sleep 2' for chord in progression])}
  stop
end
    """
    send_sonic_pi_code(client, code)


def play_ambient_melody(client, key="C", synth="prophet", bpm=60):
    """Играет эмбиентную мелодию в Sonic Pi"""
    code = f"""
# Эмбиентная мелодия в тональности {key}
use_bpm {bpm}

live_loop :ambient_background do
  use_synth :{synth}
  use_synth_defaults attack: 0.5, release: 4, amp: 0.5
  with_fx :reverb, mix: 0.7, room: 0.9 do
    with_fx :echo, mix: 0.4, phase: 0.25, decay: 4 do
      play_chord :{key.lower()}m7, sustain: 2
      sleep 4
      play_chord :{key.lower()}maj9, sustain: 2
      sleep 4
    end
  end
  stop
end

live_loop :gentle_melody do
  use_synth :blade
  use_synth_defaults release: 3, amp: 0.4
  with_fx :reverb, mix: 0.8 do
    play scale(:{key.lower()}3, :minor_pentatonic).choose, amp: rand(0.3..0.6)
    sleep [0.5, 0.75, 1, 1.5].choose
  end
  stop
end
    """
    send_sonic_pi_code(client, code)


def play_techno_beat(client, bpm=125):
    """Играет техно-бит в Sonic Pi"""
    code = f"""
# Техно-бит
use_bpm {bpm}

live_loop :techno_kick do
  sample :bd_tek, amp: 1.5
  sleep 1
end

live_loop :techno_hi_hat do
  sample :drum_cymbal_closed, amp: 0.5 if spread(6, 8).look
  sleep 0.25
end

live_loop :techno_bass do
  use_synth :tb303
  note = (ring :e1, :e2, :e1, :e1).tick
  play note, release: 0.2, cutoff: rrand(60, 110)
  sleep 0.5
end

live_loop :techno_melody do
  use_synth :dsaw
  with_fx :reverb, mix: 0.4 do
    play_pattern_timed scale(:e3, :minor_pentatonic).shuffle.take(4), [0.25, 0.25, 0.5, 0.25], amp: 0.4
  end
end
    """
    send_sonic_pi_code(client, code)


def stop_all_sounds(client):
    """Останавливает все звуки в Sonic Pi"""
    code = """
# Остановка всех звуков
stop
    """
    send_sonic_pi_code(client, code)


def main():
    parser = argparse.ArgumentParser(description="Отправка команд в Sonic Pi через OSC")
    parser.add_argument(
        "--mode",
        type=str,
        default="melody",
        choices=["melody", "chords", "ambient", "techno", "stop"],
        help="Режим воспроизведения",
    )
    parser.add_argument(
        "--key", type=str, default="C", help="Тональность (C, D, E и т.д.)"
    )
    parser.add_argument("--bpm", type=int, default=120, help="Темп (BPM)")
    parser.add_argument(
        "--synth",
        type=str,
        default="prophet",
        help="Синтезатор (prophet, blade, tb303, и т.д.)",
    )
    parser.add_argument(
        "--progression",
        type=str,
        default="pop",
        choices=["pop", "jazz", "blues", "rock"],
        help="Тип прогрессии аккордов",
    )

    args = parser.parse_args()

    try:
        client = create_osc_client()
        print(f"Соединение с Sonic Pi установлено ({SONIC_PI_HOST}:{SONIC_PI_PORT})")

        if args.mode == "melody":
            play_simple_melody(client)
        elif args.mode == "chords":
            play_chord_progression(client, args.progression, args.synth, args.bpm)
        elif args.mode == "ambient":
            play_ambient_melody(client, args.key, args.synth, args.bpm)
        elif args.mode == "techno":
            play_techno_beat(client, args.bpm)
        elif args.mode == "stop":
            stop_all_sounds(client)
        else:
            print(f"Неизвестный режим: {args.mode}")

    except Exception as e:
        print(f"Ошибка: {e}")
        print("Убедитесь, что Sonic Pi запущен и работает!")
        sys.exit(1)


if __name__ == "__main__":
    main()
