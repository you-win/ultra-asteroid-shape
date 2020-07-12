extends KinematicBody2D

const ANIMATIONS = {
	"DEFAULT": "DEFAULT",
	"KILLED": "KILLED"
}

const MOVEMENT_SPEED: float = 100.0
const ROTATION_SPEED: float = 0.1

const SHOOT_TIMER_TIME: float = 0.5

var base_velocity_modifier: Vector2 = Vector2.ONE
var base_rotation_modifier: float = 1.0
var base_shot_rotation_modifier: bool = false
var base_disable_movement_modifiers: String = "None"
var base_replace_movement_modifiers: String = "None"
var base_bullet_amount_modifier: int = 1
var base_shot_delay_modifier: float = 0.0

var projectile: PackedScene = preload("res://entities/player-projectiles/Blast.tscn")

var target_movement: float = 0.0
var target_rotation: float = 0.0
var target_velocity: Vector2 = Vector2.ZERO
var actual_velocity: Vector2 = Vector2.ZERO

var velocity_modifier: Vector2 = Vector2.ONE
var rotation_modifier: float = 1.0
var shot_rotation_modifier: bool = false
var disable_movement_modifier: String = "None"
var replace_movement_modifier: String = "None"
var bullet_amount_modifier: int = 1
var shot_delay_modifier: float = 0.0

var current_animation: String = ANIMATIONS.DEFAULT
var next_animation: String = ANIMATIONS.DEFAULT

var quip_display_time: float = 1.0

var can_shoot: bool = true

onready var parent_node = get_parent()
onready var shoot_timer = $ShootTimer
onready var quip_label = $QuipContainer/Quip
onready var quip_tween = $QuipContainer/Tween

##
# Builtin functions
##

func _ready() -> void:
	_reset_modifiers()
	
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")

	_subscribe_to_pubsub()

	$AnimationPlayer.play(ANIMATIONS.DEFAULT)

func _physics_process(_delta: float) -> void:
	target_movement = 0.0
	target_rotation = 0.0

	if(Input.is_action_pressed("ui_up") and disable_movement_modifier != "ui_up"):
		target_movement += MOVEMENT_SPEED
	if Input.is_action_pressed("ui_down"):
		target_movement -= MOVEMENT_SPEED
	if(Input.is_action_pressed("ui_left") and disable_movement_modifier != "ui_left"):
		target_rotation -= ROTATION_SPEED
	if(Input.is_action_pressed("ui_right") and disable_movement_modifier != "ui_right"):
		target_rotation += ROTATION_SPEED

	match replace_movement_modifier:
		"None":
			pass
		"ui_up":
			target_movement = MOVEMENT_SPEED

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

	$QuipContainer.global_rotation = 0

##
# Connections
##

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_killed_animation_finished(animation_name: String) -> void:
	$AnimationPlayer.disconnect("animation_finished", self, "_on_killed_animation_finished")
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
	PubSub.subscribe(GameManager.PUBSUB_KEYS.CHAOS_PLAYER_TEMP, self)

func _killed() -> void:
	shoot_timer.stop()
	can_shoot = false

	velocity_modifier = Vector2.ZERO
	rotation_modifier = 0.0
	
	if not $AnimationPlayer.is_connected("animation_finished", self, "_on_killed_animation_finished"):
		$AnimationPlayer.connect("animation_finished", self, "_on_killed_animation_finished")
	
	$AnimationPlayer.play(ANIMATIONS.KILLED)

func _reset_modifiers() -> void:
	InputMap.load_from_globals()
	velocity_modifier = base_velocity_modifier
	rotation_modifier = base_rotation_modifier
	shot_rotation_modifier = base_shot_rotation_modifier
	shot_delay_modifier = base_shot_delay_modifier
	replace_movement_modifier = base_replace_movement_modifiers
	disable_movement_modifier = base_disable_movement_modifiers
	bullet_amount_modifier = base_bullet_amount_modifier
	$Sprite.flip_v = false

func _set_quip(quip: String) -> void:
	quip_label.text = quip
	quip_tween.interpolate_property(quip_label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), quip_display_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	quip_tween.start()

##
# Public functions
##

func shoot() -> void:
	can_shoot = false
	
	if bullet_amount_modifier == 1:
		var instance = projectile.instance()
		instance.global_position = self.global_position
		
		var modifier: float = 0.0
		if shot_rotation_modifier:
			modifier = rand_range(-1.5, 1.5)
		instance.global_rotation = self.global_rotation + modifier

		parent_node.call_deferred("add_child", instance)

		shoot_timer.start(instance.shot_delay + shot_delay_modifier)
	
	if bullet_amount_modifier == 3:
		var delay
		for i in range(3):
			var instance = projectile.instance()
			instance.global_position = self.global_position
			instance.global_rotation = self.global_rotation + rand_range(-1, 1)

			if i == 0:
				delay = instance.shot_delay
			parent_node.call_deferred("add_child", instance)
		shoot_timer.start(delay + shot_delay_modifier)

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			pass
		GameManager.PUBSUB_KEYS.GAME_OVER:
			_killed()
		GameManager.PUBSUB_KEYS.CHAOS_PLAYER_TEMP:
			_reset_modifiers()
			match payload["modifier"]:
				"shoot_aim_modifier":
					shot_rotation_modifier = true
				"disable_forward_movement_modifier":
					replace_movement_modifier = "ui_up"
				"inputmap":
					disable_movement_modifier = payload["value"]
				"sprite":
					$Sprite.flip_v = true
				"bullet_amount_modifier":
					bullet_amount_modifier = int(payload["value"])
				"shot_delay_modifier":
					shot_delay_modifier = int(payload["value"])
				_:
					printerr("Unrecognized modifier: " + payload["modifier"])
			_set_quip(payload["quip"])
		GameManager.PUBSUB_KEYS.CHAOS_PLAYER_PERM:
			pass
