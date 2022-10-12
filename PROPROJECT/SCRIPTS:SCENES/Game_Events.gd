extends Node

signal Harmonised
signal damaged(body, Note)
signal state_changed(state)
signal seek_player
signal note_changed(note)
signal player_dead

signal move_right
signal move_left
signal enemyshot


signal beat(song_position_in_beats)
signal measure(measure)
signal beat_changed
signal new_wave
signal wave_indicator(number)
signal enemy_died
signal new_measure
signal enemy_note_changed(note)
signal interval_changed(wave)
signal interval_over
signal enemy_spawned

var beat 
var player_input_vector = Vector2.ZERO
var current_note = 0
#this is set up so that the damaged signal can send the data of what it is hitting. If it hits the dog, the receiver of the signal will be told that the dog is being hit. 
func _on_Player_input_vector_changed(input_vector):
		player_input_vector = input_vector

func _ready():
	GameEvents.connect("beat", self, "on_beat")
	GameEvents.connect("note_changed", self, "on_note_changed")

func on_beat(song_position_in_beats):
	beat = song_position_in_beats
	if beat % 2 == 0:
		GameEvents.emit_signal("beat_changed")

func on_note_changed(note):
	current_note = note
