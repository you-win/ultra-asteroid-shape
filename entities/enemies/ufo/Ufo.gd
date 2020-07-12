extends KinematicBody2D

const ANIMATIONS = {
	"DEFAULT": "DEFAULT"
}

const MOVEMENT_SPEED: float = 1.0

const NAME: String = "UFO"

var target_velocity: Vector2 = Vector2.ZERO
var actual_velocity: Vector2 = Vector2.ZERO

var speed_modifier: float = 1.0

var current_animation: String = ANIMATIONS["DEFAULT"]
var next_animation: String = ANIMATIONS["DEFAULT"]

var should_chase: bool = true
var eligible_for_free: bool = false

onready var visibility_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var target: KinematicBody2D = get_parent().get_node_or_null("Player")

##
# Builtin functions
##

func _ready() -> void:
	visibility_notifier.connect("screen_entered", self, "_on_screen_entered")
	visibility_notifier.connect("screen_exited", self, "_on_screen_exited")
	$Sounds/Killed.connect("finished", self, "_on_death_sound_finished")
	
	self.global_rotation = 0
	$AnimationPlayer.play(current_animation)
	
	$Sounds/Move.pitch_scale += rand_range(-2, 2)
	
	PubSub.subscribe(GameManager.PUBSUB_KEYS.GAME_OVER, self)

func _physics_process(_delta: float) -> void:
	if(should_chase and target and target.global_position):
		target_velocity = (target.global_position - self.global_position).normalized() * MOVEMENT_SPEED
	else:
		target_velocity = (self.global_position - Vector2(rand_range(-10, 10), rand_range(-10, 10))).normalized() * MOVEMENT_SPEED
	
	var collision := move_and_collide(target_velocity)
	if collision:
		if collision.collider.is_in_group(GameManager.PLAYER_GROUP):
			PubSub.publish(GameManager.PUBSUB_KEYS.GAME_OVER, {"name": NAME})
	
	if not $Sounds/Move.playing:
		$Sounds/Move.play()

##
# Connections
##

func _on_screen_entered() -> void:
	eligible_for_free = true

func _on_screen_exited() -> void:
	if eligible_for_free:
		PubSub.unsubscribe(self)
		.queue_free()

func _on_death_sound_finished() -> void:
	PubSub.unsubscribe(self)
	.queue_free()

##
# Private functions
##

##
# Public functions
##

func queue_free() -> void:
	$Sounds/Move.stop()
	$Sounds/Killed.play()
	$CollisionShape2D.disabled = true
	$Sprite.visible = false

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.GAME_OVER:
			should_chase = false
