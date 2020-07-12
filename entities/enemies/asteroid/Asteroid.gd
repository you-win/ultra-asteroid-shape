extends KinematicBody2D

const ANIMATIONS = {
	"DEFAULT": "DEFAULT"
}

const MOVEMENT_SPEED: float = 1.0

const NAME: String = "Asteroid"

var target_velocity: Vector2 = Vector2.ZERO
var actual_velocity: Vector2 = Vector2.ZERO

var speed_modifier: float = 1.0

var current_animation: String = ANIMATIONS["DEFAULT"]
var next_animation: String = ANIMATIONS["DEFAULT"]

var eligible_for_free: bool = false

onready var visibility_notifier: VisibilityNotifier2D = $VisibilityNotifier2D

##
# Builtin functions
##

func _ready() -> void:
	visibility_notifier.connect("screen_entered", self, "_on_screen_entered")
	visibility_notifier.connect("screen_exited", self, "_on_screen_exited")

	target_velocity = Vector2(cos(self.rotation), sin(self.rotation)) * MOVEMENT_SPEED
	self.rotation = 0.0

	PubSub.subscribe(GameManager.PUBSUB_KEYS.PICKUP, self)

	$AnimationPlayer.play(current_animation)

func _physics_process(_delta: float) -> void:
	# Do things to the target here

	var collision = move_and_collide(target_velocity)
	if collision != null:
		if collision.collider.is_in_group(GameManager.PLAYER_GROUP):
			self.queue_free()
			PubSub.publish(GameManager.PUBSUB_KEYS.GAME_OVER, {"name": NAME})

##
# Connections
##

func _on_screen_entered() -> void:
	eligible_for_free = true

func _on_screen_exited() -> void:
	if eligible_for_free:
		self.queue_free()

##
# Private functions
##

##
# Public functions
##


