extends Control

onready var sprite = $Sprite
var current_note


func _ready():
	GameEvents.connect("note_changed", self, "on_note_changed")

func on_note_changed(note):
	current_note = note
	print(current_note)
	sprite.frame = current_note

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
