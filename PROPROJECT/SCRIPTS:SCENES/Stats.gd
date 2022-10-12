extends Node


export var max_health = 2 setget set_max_health
onready var health = max_health setget set_health
#setget makes the function set health run everytime the health value is set to something else.

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
	else: 
		emit_signal("health_changed", health)

func set_max_health(value):
	max_health = value





func _on_PlayerStats_max_health_changed(value):
	var new_max_health = value
	max_health = new_max_health
	health = new_max_health
