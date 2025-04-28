#!/usr/bin/env python3
import time
import mido
from mido import Message

# Список всех доступных MIDI-портов
print("Доступные MIDI-порты выхода:")
output_ports = mido.get_output_names()
for i, port in enumerate(output_ports):
    print(f"{i}: {port}")

# Попытка найти порт IAC Driver или GarageBand
iac_port = None
for port in output_ports:
    if "IAC" in port or "GarageBand" in port:
        iac_port = port
        break

if iac_port:
    print(f"\nИспользую порт: {iac_port}")
    with mido.open_output(iac_port) as output:
        print("Отправляю ноту C (60) на канале 1...")

        # Включаем ноту (Note On)
        note_on = Message("note_on", note=60, velocity=100, channel=0)
        output.send(note_on)
        print(f"Отправлено: {note_on}")

        # Ждем 1 секунду
        time.sleep(1)

        # Выключаем ноту (Note Off)
        note_off = Message("note_off", note=60, velocity=0, channel=0)
        output.send(note_off)
        print(f"Отправлено: {note_off}")

        print(
            "\nТеперь отправляю последовательность нот C, E, G (до-мажорное трезвучие)..."
        )
        notes = [60, 64, 67]  # C, E, G

        for note in notes:
            # Включаем ноту
            note_on = Message("note_on", note=note, velocity=100, channel=0)
            output.send(note_on)
            print(f"Отправлено: {note_on}")
            time.sleep(0.5)

            # Выключаем ноту
            note_off = Message("note_off", note=note, velocity=0, channel=0)
            output.send(note_off)
            print(f"Отправлено: {note_off}")
            time.sleep(0.1)

        print("\nПрограмма успешно выполнена!")
else:
    print("Не найден порт IAC Driver или GarageBand!")
    print("Пожалуйста, убедитесь, что IAC Driver активирован в Audio MIDI Setup.")
