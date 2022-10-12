extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.








func _on_Raycast_Collider_body_entered(body):
	print(body)
	if body.is_in_group("EnemyRight"):
		GameEvents.emit_signal("move_left")
	elif body.is_in_group("EnemyLeft"):
		GameEvents.emit_signal("move_right")
	else:
		pass


