extends KinematicBody2D

const ANIMATIONS = {
	"DEFAULT": "DEFAULT",
	"KILLED": "KILLED"
}

const MOVEMENT_SPEED: float = 100.0
const ROTATION_SPEED: float = 0.1

const SHOOT_TIMER_TIME: float = 0.5

var projectile: PackedScene = preload("res://entities/player-projectiles/Blast.tscn")

var target_movement: float = 0.0
var target_rotation: float = 0.0
var target_velocity: Vector2 = Vector2.ZERO
var actual_velocity: Vector2 = Vector2.ZERO

var velocity_modifier: Vector2 = Vector2.ONE
var rotation_modifier: float = 1.0

var current_animation: String = ANIMATIONS.DEFAULT
var next_animation: String = ANIMATIONS.DEFAULT

var can_shoot: bool = true

onready var parent_node = get_parent()
onready var shoot_timer = $ShootTimer

##
# Builtin functions
##

func _ready() -> void:
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")

	_subscribe_to_pubsub()

	$AnimationPlayer.play(ANIMATIONS.DEFAULT)

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
	
	self.rotate(target_rotation * rotation_modifier)
	
	var current_rotation = self.global_rotation
	target_velocity = Vector2(cos(current_rotation), sin(current_rotation)) * target_movement * velocity_modifier
	
	actual_velocity = move_and_slide(target_velocity)

	if get_slide_count() > 0:
		for i in get_slide_count():
			if get_slide_collision(i).collider.collision_layer != GameManager.WALL_LAYER:
				PubSub.publish(GameManager.PUBSUB_KEYS.GAME_OVER, {"name": get_slide_collision(i).collider.NAME})


##
# Connections
##

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_killed_animation_finished(animation_name: String) -> void:
	if animation_name == ANIMATIONS.KILLED:
		var killed_player_scene = load("res://entities/player/KilledPlayer.tscn")
		var killed_player = killed_player_scene.instance()
		killed_player.global_position = self.global_position
		killed_player.global_rotation = self.rotation

		get_parent().call_deferred("add_child", killed_player)
		self.queue_free()

##
# Private functions
##

func _subscribe_to_pubsub() -> void:
	PubSub.subscribe(GameManager.PUBSUB_KEYS.PICKUP, self)
	PubSub.subscribe(GameManager.PUBSUB_KEYS.GAME_OVER, self)
	PubSub.subscribe(GameManager.PUBSUB_KEYS.CHAOS_PLAYER, self)

func _process_chaos(chaos: Dictionary) -> void:
	match chaos["type"]:
		ChaosGenerator.EFFECT_TYPES.TEMPORARY_PLAYER_EFFECTS:
			_process_temporary_effect(chaos["name"])
		ChaosGenerator.EFFECT_TYPES.PERMANENT_PLAYER_EFFECTS:
			_process_permanent_effect(chaos["name"])

func _process_temporary_effect(effect_name: String) -> void:
	match ChaosGenerator.TEMPORARY_PLAYER_EFFECTS[effect_name]:
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.DRUNK_AIM:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.NO_BRAKES:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.BACKUP_ONLY:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.ONLY_TURN_LEFT:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.ONLY_TURN_RIGHT:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.FLIP_SPRITE:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.SHOOT_MORE_BULLETS:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.SHOT_DELAY_UP:
			pass
		ChaosGenerator.TEMPORARY_PLAYER_EFFECTS.SHOT_DELAY_DOWN:
			pass

func _process_permanent_effect(effect_name: String) -> void:
	match ChaosGenerator.PERMANENT_PLAYER_EFFECTS[effect_name]:
		ChaosGenerator.PERMANENT_PLAYER_EFFECTS:
			pass
		ChaosGenerator.PERMANENT_PLAYER_EFFECTS:
			pass
		ChaosGenerator.PERMANENT_PLAYER_EFFECTS:
			pass
		ChaosGenerator.PERMANENT_PLAYER_EFFECTS:
			pass
	pass

func _killed() -> void:
	shoot_timer.stop()
	can_shoot = false

	velocity_modifier = Vector2.ZERO
	rotation_modifier = 0.0
	
	$AnimationPlayer.connect("animation_finished", self, "_on_killed_animation_finished")
	$AnimationPlayer.play(ANIMATIONS.KILLED)

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
		GameManager.PUBSUB_KEYS.GAME_OVER:
			_killed()
		GameManager.PUBSUB_KEYS.CHAOS_PLAYER:
			_process_chaos(payload)
