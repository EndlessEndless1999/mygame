extends RichTextLabel


var new_note 

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("enemy_note_changed", self, "on_note_changed")


func on_note_changed(note):
	match note:
		0:
			new_note = "A"
		1:
			new_note = "B"
		2:
			new_note = "C"
		3:
			new_note = "D"
		4:
			new_note = "E"
		5:
			new_note = "F"
		6:
			new_note = "G"
	self.text = new_note


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
