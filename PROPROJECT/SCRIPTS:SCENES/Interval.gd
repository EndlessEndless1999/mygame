extends RichTextLabel


var new_interval = "MINOR 7TH"
var wave = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("wave_indicator", self, "on_wave_changed")
	on_wave_changed(wave)


func on_wave_changed(wave):
	match wave:
		0:
			new_interval = "MINOR 7TH"
		1:
			new_interval = "MINOR 3RD"
		2:
			new_interval = "PERFECT 5TH"
		3:
			new_interval = "MAJOR 2ND"
		4:
			new_interval = "TONIC"
		5:
			new_interval = "CONGRATS"
			yield(GameEvents, "enemy_spawned")
	self.text = new_interval


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

