extends RayCast2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var collider 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var collider = get_collider()
	check_for_wall()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_for_wall():
	if collider:
		print(collider)
		if collider.is_in_group("Wall"):
			GameEvents.emit_signal("move_right")
	else:
		pass
