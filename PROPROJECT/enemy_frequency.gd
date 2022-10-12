extends KinematicBody2D


const FREQUENCY_SPEED = 400
onready var Collider = $Collider
onready var speed_x = 0
onready var speed_y = -1
var motion = Vector2.UP
var current_note
var type = true

func _ready():
	set_process(true)
	GameEvents.connect("note_changed", self, "on_note_changed")
	add_to_group("enemy_projectile")



func _process(delta):
	var motion = Vector2.DOWN * FREQUENCY_SPEED
	set_global_position(get_global_position() + motion * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func on_note_changed(note):
	current_note = note

func _on_Collider_body_entered(body):
	var Note = current_note
	if body != self:
		GameEvents.emit_signal("damaged", body, Note)
		queue_free()
	else:
		pass
