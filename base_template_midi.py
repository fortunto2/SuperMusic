#!/usr/bin/env python3
"""
Title: Base Template MIDI Version
Style: Electronic music with customizable elements
BPM: 100
Date: 2023-10-20

Used instruments:
- Different synths depending on melody
- Basic drums

Structure:
- Main rhythm
- Melody
- Bass
- Additional elements

MIDI Configuration:
- Channel 1: King of FM synthesizer
- IAC Driver Bus 1 for output
"""

import time
import threading
import mido
from mido import Message

# MIDI Configuration
MIDI_CHANNEL = 0  # Channel 1 (0-indexed)
IAC_PORT = "IAC Driver Bus 1"

# BPM and timing
BPM = 100
BEAT_DURATION = 60.0 / BPM  # Duration of one beat in seconds

# Note mappings (MIDI note numbers)
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

# Chord definitions
CHORDS = {
    "Cm": [60, 63, 67],  # C minor: C, Eb, G
    "C": [60, 64, 67],  # C major: C, E, G
    "G": [67, 71, 74],  # G major: G, B, D
    "Am": [69, 72, 76],  # A minor: A, C, E
    "F": [65, 69, 72],  # F major: F, A, C
}

# Current settings (easily changeable)
RHYTHM_TYPE = "basic"
BASS_TYPE = "simple"
MELODY_TYPE = "arpeggio"
FX_TYPE = "ambient"
USE_FX = True


class MIDIComposer:
    def __init__(self):
        self.output = None
        self.running = False

    def connect(self):
        """Connect to MIDI output"""
        try:
            self.output = mido.open_output(IAC_PORT)
            print(f"Connected to MIDI port: {IAC_PORT}")
            return True
        except Exception as e:
            print(f"Error connecting to MIDI: {e}")
            return False

    def disconnect(self):
        """Disconnect from MIDI"""
        if self.output:
            self.output.close()
            print("MIDI connection closed")

    def send_note_on(self, note, velocity=80, channel=MIDI_CHANNEL):
        """Send note on message"""
        if self.output:
            msg = Message("note_on", note=note, velocity=velocity, channel=channel)
            self.output.send(msg)

    def send_note_off(self, note, velocity=0, channel=MIDI_CHANNEL):
        """Send note off message"""
        if self.output:
            msg = Message("note_off", note=note, velocity=velocity, channel=channel)
            self.output.send(msg)

    def play_note(self, note, duration, velocity=80):
        """Play a single note for specified duration"""
        self.send_note_on(note, velocity)
        time.sleep(duration)
        self.send_note_off(note)

    def play_chord(self, chord_notes, duration, velocity=80):
        """Play a chord"""
        # Turn on all notes
        for note in chord_notes:
            self.send_note_on(note, velocity)
            time.sleep(0.01)  # Small delay between notes

        # Hold chord
        time.sleep(duration)

        # Turn off all notes
        for note in chord_notes:
            self.send_note_off(note)
            time.sleep(0.01)

    def play_rhythm_basic(self):
        """Play basic rhythm pattern"""
        # Kick drum (C2 = 36)
        self.play_note(36, 0.1, velocity=100)
        time.sleep(BEAT_DURATION - 0.1)

        # Snare (D2 = 38)
        self.play_note(38, 0.1, velocity=80)
        time.sleep(BEAT_DURATION - 0.1)

        # Kick drum
        self.play_note(36, 0.1, velocity=100)
        time.sleep(BEAT_DURATION - 0.1)

        # Snare
        self.play_note(38, 0.1, velocity=80)
        time.sleep(BEAT_DURATION - 0.1)

    def play_rhythm_breakbeat(self):
        """Play breakbeat rhythm pattern"""
        # More complex pattern
        pattern = [
            (36, 0.1, 100),  # Kick
            (0.4, None, None),  # Rest
            (42, 0.05, 60),  # Hi-hat
            (0.45, None, None),  # Rest
            (38, 0.1, 80),  # Snare
            (0.4, None, None),  # Rest
            (42, 0.05, 60),  # Hi-hat
            (0.45, None, None),  # Rest
        ]

        for item in pattern:
            if item[0] is not None and item[1] is not None:
                self.play_note(item[0], item[1], velocity=item[2])
            else:
                time.sleep(item[0])

    def play_bass_simple(self):
        """Play simple bass line"""
        # C2, C2, E2, E2 pattern
        bass_notes = [36, 36, 40, 40]  # C2, C2, E2, E2

        for note in bass_notes:
            self.play_note(note, 0.3, velocity=70)
            time.sleep(BEAT_DURATION - 0.3)

    def play_bass_walking(self):
        """Play walking bass line"""
        # Walking bass: C2, E2, G2, B2
        bass_notes = [36, 40, 43, 47]

        for note in bass_notes:
            self.play_note(note, 0.7, velocity=60)
            time.sleep(BEAT_DURATION - 0.7)

    def play_melody_arpeggio(self):
        """Play arpeggio melody"""
        chord_progression = ["Cm", "G", "Am", "F"]

        for chord_name in chord_progression:
            chord_notes = CHORDS[chord_name]
            # Play arpeggio
            for note in chord_notes:
                self.play_note(note, 0.25, velocity=60)
                time.sleep(0.05)
            time.sleep(0.2)  # Pause between chords

    def play_melody_chords(self):
        """Play chord melody"""
        chord_progression = ["Cm", "F", "Cm", "F"]

        for chord_name in chord_progression:
            chord_notes = CHORDS[chord_name]
            self.play_chord(chord_notes, 2.0, velocity=70)
            time.sleep(0.2)

    def play_melody_lead(self):
        """Play lead melody"""
        lead_notes = [64, 67, 69, 72, 69, 67, 64]  # E, G, A, C, A, G, E
        note_durations = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0]

        for note, duration in zip(lead_notes, note_durations):
            self.play_note(note, duration, velocity=80)
            time.sleep(0.05)

    def play_fx_ambient(self):
        """Play ambient effects"""
        # Low pad sound
        self.play_note(48, 4.0, velocity=30)  # C3 held

    def rhythm_loop(self):
        """Main rhythm loop"""
        while self.running:
            if RHYTHM_TYPE == "basic":
                self.play_rhythm_basic()
            elif RHYTHM_TYPE == "breakbeat":
                self.play_rhythm_breakbeat()
            elif RHYTHM_TYPE == "minimal":
                # Minimal rhythm - just kick every 2 beats
                self.play_note(36, 0.1, velocity=100)
                time.sleep(2 * BEAT_DURATION - 0.1)
                self.play_note(38, 0.1, velocity=60)
                time.sleep(2 * BEAT_DURATION - 0.1)

    def bass_loop(self):
        """Bass loop"""
        while self.running:
            if BASS_TYPE == "simple":
                self.play_bass_simple()
            elif BASS_TYPE == "walking":
                self.play_bass_walking()
            elif BASS_TYPE == "octaves":
                # Octave bass
                self.play_note(36, 1.0, velocity=60)  # C2
                time.sleep(1.0)
                self.play_note(48, 1.0, velocity=60)  # C3
                time.sleep(1.0)

    def melody_loop(self):
        """Melody loop"""
        while self.running:
            if MELODY_TYPE == "arpeggio":
                self.play_melody_arpeggio()
            elif MELODY_TYPE == "chords":
                self.play_melody_chords()
            elif MELODY_TYPE == "lead":
                self.play_melody_lead()

            time.sleep(0.5)  # Pause between melody cycles

    def fx_loop(self):
        """Effects loop"""
        while self.running:
            if USE_FX:
                if FX_TYPE == "ambient":
                    self.play_fx_ambient()
                elif FX_TYPE == "glitch":
                    # Glitch effect - random short notes
                    import random

                    note = random.randint(60, 84)  # Random note in C4-C6 range
                    self.play_note(note, 0.1, velocity=random.randint(40, 80))
                elif FX_TYPE == "sweep":
                    # Sweep effect - ascending notes
                    for note in range(48, 72, 2):  # C3 to C5
                        self.play_note(note, 0.1, velocity=50)
                        time.sleep(0.05)

            time.sleep(8)  # Wait 8 beats before next effect

    def start(self):
        """Start all loops"""
        if not self.connect():
            return False

        self.running = True

        # Start all loops in separate threads
        threads = []

        rhythm_thread = threading.Thread(target=self.rhythm_loop)
        rhythm_thread.daemon = True
        rhythm_thread.start()
        threads.append(rhythm_thread)

        bass_thread = threading.Thread(target=self.bass_loop)
        bass_thread.daemon = True
        bass_thread.start()
        threads.append(bass_thread)

        melody_thread = threading.Thread(target=self.melody_loop)
        melody_thread.daemon = True
        melody_thread.start()
        threads.append(melody_thread)

        if USE_FX:
            fx_thread = threading.Thread(target=self.fx_loop)
            fx_thread.daemon = True
            fx_thread.start()
            threads.append(fx_thread)

        print("🎵 Base Template MIDI version started!")
        print(f"🎛️  Rhythm: {RHYTHM_TYPE}")
        print(f"🎸 Bass: {BASS_TYPE}")
        print(f"🎹 Melody: {MELODY_TYPE}")
        print(f"🌟 FX: {FX_TYPE if USE_FX else 'OFF'}")
        print("Press Ctrl+C to stop...")

        try:
            # Keep main thread alive
            while self.running:
                time.sleep(0.1)
        except KeyboardInterrupt:
            print("\n🛑 Stopping...")
            self.stop()

        return True

    def stop(self):
        """Stop all loops"""
        self.running = False
        time.sleep(0.5)  # Give threads time to stop
        self.disconnect()


def main():
    """Main function"""
    print("🎼 Base Template MIDI Version")
    print("=" * 40)
    print(f"🎵 BPM: {BPM}")
    print(f"🎹 MIDI Channel: {MIDI_CHANNEL + 1}")
    print(f"🔌 Output: {IAC_PORT}")
    print("=" * 40)

    composer = MIDIComposer()

    if not composer.start():
        print("❌ Failed to start MIDI composition")
        return 1

    return 0


if __name__ == "__main__":
    exit(main())


