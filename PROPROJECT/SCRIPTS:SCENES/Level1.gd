extends Node2D

var enemy = preload("res://SCRIPTS:SCENES/EnemyAI.tscn")
var enemyleft = preload("res://SCRIPTS:SCENES/EnemyAI_Left.tscn")
var enemyright = preload("res://SCRIPTS:SCENES/EnemyAI_Right.tscn")
onready var spawn = $Spawn_Location/Position2D
onready var spawn2 = $Spawn_Location2/Position2D
onready var spawn3 = $Spawn_Location3/Position2D
onready var spawn4 = $Spawn_Location4/Position2D
onready var spawn5 = $Spawn_Location5/Position2D
onready var spawn_left = $Spawn_Location_Left/Position2D
onready var spawn_right = $Spawn_Location_Right/Position2D
onready var ap = $AnimationPlayer
var wave = 0
var enemies = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("new_wave", self, "on_new_wave")
	GameEvents.connect("enemy_died", self, "on_enemy_died")
	GameEvents.connect("player_dead", self, "player_dead")

func on_new_wave():
	wave += 1
	if wave < 5:
		GameEvents.emit_signal("wave_indicator", wave)
	else:
		finish()

func on_enemy_died():
	enemies -= 1
	if enemies == 0 and wave != 5:
		GameEvents.emit_signal("new_wave")
		print("Hiya")
		spawn_wave()
	else:
		pass

func spawn_wave():
	yield(GameEvents, "new_measure")
	GameEvents.emit_signal("enemy_spawned")
	if wave != 5:
		var instance = enemy.instance()
		add_child(instance)
		instance.global_position = spawn.global_position
		var instance_left = enemyleft.instance()
		add_child(instance_left)
		instance_left.global_position = spawn_left.global_position
		var instance_right = enemyright.instance()
		add_child(instance_right)
		instance_right.global_position = spawn_right.global_position
		enemies = 3
		if wave == 1:
			var instance_2 = enemy.instance()
			add_child(instance_2)
			instance_2.global_position = spawn2.global_position
			enemies = 4
		elif wave == 2:
			var instance_2 = enemy.instance()
			var instance_3 = enemy.instance()
			add_child(instance_2)
			instance_2.global_position = spawn2.global_position
			add_child(instance_3)
			instance_3.global_position = spawn3.global_position
			enemies = 5
		elif wave == 3:
			var instance_2 = enemy.instance()
			var instance_3 = enemy.instance()
			var instance_4 = enemy.instance()
			add_child(instance_2)
			instance_2.global_position = spawn2.global_position
			add_child(instance_3)
			instance_3.global_position = spawn3.global_position
			add_child(instance_4)
			instance_4.global_position = spawn4.global_position
			enemies = 6
		elif wave == 4:
			var instance_2 = enemy.instance()
			var instance_3 = enemy.instance()
			var instance_4 = enemy.instance()
			var instance_5 = enemy.instance()
			add_child(instance_2)
			instance_2.global_position = spawn2.global_position
			add_child(instance_3)
			instance_3.global_position = spawn3.global_position
			add_child(instance_4)
			instance_4.global_position = spawn4.global_position
			add_child(instance_5)
			instance_5.global_position = spawn5.global_position
			enemies = 6
		else:
			pass
	GameEvents.emit_signal("interval_changed", wave)

func finish():
	ap.play("finish")

func player_dead():
	ap.play("finish")


func _on_Button_pressed():
	var new_scene = load("res://SCRIPTS:SCENES/Level1.tscn")
	get_tree().change_scene_to(new_scene)
