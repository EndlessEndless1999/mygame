extends Area2D

onready var timer = $Timer
var invincible = false setget set_invincible

signal iframe_start
signal iframe_end

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("iframe_start")
	else:
		emit_signal("iframe_end")

func _start_invincible(duration):
	self.invincible = true
	timer.start(duration)

func _on_Hurtbox_iframe_start():
	set_deferred("Monitorable", false)
	#this relaunches the hurtbox area so that it can check again for collisions

func _on_Hurtbox_iframe_end():
	set_deferred("Monitorable", true)

func _on_Timer_timeout():
	self.invincible = false 
	print("timeout")
