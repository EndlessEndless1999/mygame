extends KinematicBody2D

const speed = 200
const ACCELERATION = 100
const FRICTION = 10
const MAX_SPEED = 300
const DASH_SPEED = 4000

var frequency_scene = preload("res://SCRIPTS:SCENES/FrequencyProjectile.tscn")
var velocity = Vector2()
var state = MOVE
var note = C
var stats = stats
var dash_vector = Vector2.DOWN
var input_vector_static
var health = 7

signal shot 
signal input_vector_changed(input_vector)

onready var note_indicator = $"Note Indicator"
onready var timer = get_node("Timer")
onready var hurtbox = $PlayerHurtbox
onready var collider = $CollisionShape2D

enum {
	MOVE,
	DASH,
	ATTACK,
	PAUSE,
}

enum {
	C,
	D,
	E,
	F,
	G,
	A,
	B
}

func _ready():
	_physics_process(true)
	GameEvents.connect("player_dead", self, "_on_dead")

func _physics_process(delta):
	match state:
		MOVE:
			_move_state(delta)
		ATTACK:
			_attack_state(delta)
	if Input.is_action_just_pressed("ui_focus_next"):
		_note_switch()

func _move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right")*speed - Input.get_action_strength("ui_left")*speed
	input_vector.y = 0
	if input_vector != Vector2.ZERO:
		dash_vector = input_vector
		#this updates the dash vector variable only while we are moving so that it stores which way we are moving so we can dash in the correct direction
		velocity += input_vector * ACCELERATION * delta
		#this is adding acceleration to the speed! += is adding the value of acceleration to the speed every frame 
		velocity = velocity.clamped(MAX_SPEED)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	move_and_slide(velocity)
	emit_signal("input_vector_changed", input_vector)
	if Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
	if Input.is_action_just_pressed("ui_cancel"):
		state = DASH

func _attack_state(delta):
	shoot_frequency(note)
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	state = MOVE

func _dash_state(delta):
	velocity = dash_vector * DASH_SPEED * delta
	collider.disabled = true
	_move()
	collider.disabled = false
	_dash_finished()

func pause_game(delta):
	pass

func _move():
	velocity = move_and_slide(velocity)

func shoot_frequency(note):
	var frequency = frequency_scene.instance()
	print(note)
	get_parent().add_child(frequency)
	#this function adds the frequency to the current scene by instantiating it as a child to the parent
	frequency.set_global_position(get_node("Position2D").get_global_position())
	emit_signal("shot")


func _on_Player_shot():
	state = MOVE

func _dash_finished():
	velocity = Vector2.ZERO
	state = MOVE

func _note_switch():
	if note_indicator.frame < 6:
		note_indicator.frame += 1
		note = note + 1
		GameEvents.emit_signal("note_changed", note)
	else:
		note_indicator.frame = 0
		note = 0
	GameEvents.emit_signal("note_changed", note)
#stat functions

func _on_dead():
	queue_free()









func _on_Area2D_body_entered(body):
	health -= 1
	if health <= 0:
		GameEvents.emit_signal("player_dead")

