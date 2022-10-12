extends KinematicBody2D

onready var stats = $Stats
onready var _timer = $Timer
onready var explosion = $Explosion
onready var sprite = $Sprite


export var ACCELERATION = 200
export var MAX_SPEED = 30
export var FRICTION = 200
export var WANDER_ACCELERATION = 200

var state = IDLE
var velocity = Vector2.LEFT
var harmony = 6
var frequency_scene = preload("res://SCRIPTS:SCENES/enemy_frequency.tscn")
var health = 1
onready var ap = $AnimationPlayer

enum{
	IDLE,
	ATTACK
}

func _physics_process(delta):
	match state:
		IDLE:
			_idle_state(delta)
		ATTACK:
			_attack_state(delta)


func _ready():
	add_to_group("EnemyRight")
	add_to_group("Enemy")
	GameEvents.connect("damaged", self, "_on_damaged")
	GameEvents.connect("seek_player", self, "_seek_player")
	GameEvents.connect("move_left", self, "on_move_left")
	GameEvents.connect("move_right", self, "on_move_right")
	GameEvents.connect("enemyshot", self, "on_shot")
	GameEvents.connect("interval_changed", self, "on_interval_changed")

func _idle_state(delta):
	move_and_slide(velocity * MAX_SPEED)

func on_shot():
		var frequency = frequency_scene.instance()
		get_parent().add_child(frequency)
		#this function adds the frequency to the current scene by instantiating it as a child to the parent
		frequency.set_global_position(get_node("Position2D").get_global_position())




func _attack_state(delta):
	attack()

#state functions
func attack():
	pass



func on_move_left():
	velocity = Vector2.LEFT

func on_move_right():
	velocity = Vector2.RIGHT


#health processes

func _on_damaged(body, Note):
	if body == self and Note == harmony:
		health -= 1
		if health >= 0:
			GameEvents.emit_signal("enemy_died")
			ap.play("death")
			yield(ap, "animation_finished")
			GameEvents.emit_signal("interval_over")
			queue_free()
		else:
			pass



func on_interval_changed(wave):
	match wave:
		1:
			harmony = 2
		2:
			harmony = 4
		3:
			harmony = 1
		4:
			harmony = 0

func dead_anim():
	explosion.show()
	sprite.hide()
