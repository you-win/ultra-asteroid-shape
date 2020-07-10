extends KinematicBody2D

const ANIMATIONS = {
	"DEFAULT": "DEFAULT"
}

const MOVEMENT_SPEED: float = 100.0
const ROTATION_SPEED: float = 0.1

const SHOOT_TIMER_TIME: float = 0.5

var projectile: PackedScene = preload("res://entities/player-projectiles/Blast.tscn")

var target_movement: float = 0.0
var target_rotation: float = 0.0
var target_velocity: Vector2 = Vector2.ZERO
var actual_velocity: Vector2 = Vector2.ZERO

var current_animation: String = ANIMATIONS["DEFAULT"]
var next_animation: String = ANIMATIONS["DEFAULT"]

var can_shoot: bool = true

onready var parent_node = get_parent()
onready var shoot_timer = $ShootTimer

##
# Builtin functions
##

func _ready() -> void:
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")

	$AnimationPlayer.play(current_animation)

func _physics_process(_delta: float) -> void:
	target_movement = 0.0
	target_rotation = 0.0

	if Input.is_action_pressed("ui_up"):
		target_movement = MOVEMENT_SPEED
	if Input.is_action_pressed("ui_down"):
		target_movement = -MOVEMENT_SPEED
	if Input.is_action_pressed("ui_left"):
		target_rotation = -ROTATION_SPEED
	if Input.is_action_pressed("ui_right"):
		target_rotation = ROTATION_SPEED

	if(Input.is_action_pressed("ui_select") and can_shoot):
		shoot()
	
	self.rotate(target_rotation)
	
	var current_rotation = self.global_rotation
	target_velocity = Vector2(cos(current_rotation), sin(current_rotation)) * target_movement
	
	actual_velocity = move_and_slide(target_velocity)

##
# Connections
##

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

##
# Private functions
##

##
# Public functions
##

func shoot() -> void:
	can_shoot = false
	
	var instance = projectile.instance()
	instance.global_position = self.global_position
	instance.global_rotation = self.global_rotation

	parent_node.call_deferred("add_child", instance)

	shoot_timer.start(instance.shot_delay)

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			pass
