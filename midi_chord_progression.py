#!/usr/bin/env python3
import time
import sys
import mido
from mido import Message

# Определение аккордов (каждый аккорд - список MIDI-нот)
chords = {
    "C": [60, 64, 67],  # До-мажор (C-E-G)
    "Dm": [62, 65, 69],  # Ре-минор (D-F-A)
    "Em": [64, 67, 71],  # Ми-минор (E-G-B)
    "F": [65, 69, 72],  # Фа-мажор (F-A-C)
    "G": [67, 71, 74],  # Соль-мажор (G-B-D)
    "Am": [69, 72, 76],  # Ля-минор (A-C-E)
    "Bdim": [71, 74, 77],  # Си-уменьшенный (B-D-F)
}

# Прогрессия аккордов (популярная прогрессия C-G-Am-F)
progression = ["C", "G", "Am", "F"]


def select_midi_port():
    """Выбор MIDI-порта вывода"""
    output_ports = mido.get_output_names()

    print("Доступные MIDI-порты выхода:")
    for i, port in enumerate(output_ports):
        print(f"{i}: {port}")

    if not output_ports:
        print("MIDI-порты не найдены!")
        sys.exit(1)

    # Автоматически выбираем первый порт IAC Driver, если есть
    for port in output_ports:
        if "IAC" in port:
            return port

    # Если нет IAC Driver, используем первый доступный порт
    return output_ports[0]


def play_chord(output, chord_name, duration=1.0, channel=0, velocity=80):
    """Играет аккорд с заданной длительностью"""
    chord_notes = chords[chord_name]

    print(f"Играю аккорд {chord_name}: {chord_notes}")

    # Включаем все ноты аккорда
    for note in chord_notes:
        note_on = Message("note_on", note=note, velocity=velocity, channel=channel)
        output.send(note_on)
        print(f"  Нота ON: {note}")
        time.sleep(0.01)  # Небольшая задержка между нотами

    # Удерживаем аккорд
    time.sleep(duration)

    # Выключаем все ноты аккорда
    for note in chord_notes:
        note_off = Message("note_off", note=note, velocity=0, channel=channel)
        output.send(note_off)
        print(f"  Нота OFF: {note}")
        time.sleep(0.01)  # Небольшая задержка между нотами


def change_instrument(output, program, channel=0):
    """Меняет инструмент на указанный Program Change"""
    program_change = Message("program_change", program=program, channel=channel)
    output.send(program_change)
    print(f"Смена инструмента: Program Change {program} на канале {channel}")


def main():
    port_name = select_midi_port()
    print(f"\nИспользую MIDI-порт: {port_name}")

    with mido.open_output(port_name) as output:
        # Пианино
        change_instrument(output, 0)  # Grand Piano
        print("\nИграю прогрессию аккордов на пианино...")
        for chord in progression:
            play_chord(output, chord, duration=1.0)
            time.sleep(0.2)  # Пауза между аккордами

        time.sleep(1)  # Пауза перед сменой инструмента

        # Струнные
        change_instrument(output, 48)  # Strings
        print("\nИграю ту же прогрессию на струнных...")
        for chord in progression:
            play_chord(output, chord, duration=1.2, velocity=70)
            time.sleep(0.1)  # Пауза между аккордами

        print("\nПрограмма успешно выполнена!")


if __name__ == "__main__":
    main()
