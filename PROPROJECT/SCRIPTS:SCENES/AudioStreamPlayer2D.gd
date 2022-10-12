extends AudioStreamPlayer

export var bpm := 100
export var measures := 4
export var wave_type := 0
export var shoot_master = true

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1
var just_shot = false
# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal measure(position)


func _ready():
	sec_per_beat = 60.0 / bpm
	GameEvents.connect("beat_changed", self, "on_beat_changed")
	GameEvents.connect("wave_indicator", self, "on_new_wave")

func on_new_wave(number):
	if number == wave_type:
		yield(GameEvents, "new_measure")
		volume_db = 1
	else:
		pass


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		if song_position_in_beats % 2 != 0 and just_shot == false and shoot_master == true:
			print("shot")
			GameEvents.emit_signal("enemyshot")
			just_shot = true
		print(song_position_in_beats)
		GameEvents.emit_signal("beat", song_position_in_beats)
		GameEvents.emit_signal("measure", measure)
		if song_position_in_beats == 16:
			GameEvents.emit_signal("new_measure")
		measure += 1




func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures


func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()

func on_beat_changed():
	just_shot = false
