extends Node2D



var wave = 0
var current_audio = one
onready var one = $M7
onready var two = $M3
onready var three = $P5
onready var four = $Ma2
onready var five = $Tonic



func _ready():
	GameEvents.connect("enemy_died", self, "on_enemy_died")
	GameEvents.connect("wave_indicator", self, "new_wave")

func on_enemy_died():
	yield(GameEvents, "beat_changed")
	match wave:
		0:
			one.play()
		1:
			two.play()
		2:
			three.play()
		3:
			four.play()
		4:
			five.play()



func new_wave(number):
	yield(GameEvents, "enemy_spawned")
	wave = number






