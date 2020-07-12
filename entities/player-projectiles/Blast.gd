extends BaseProjectile

const ANIMATIONS = {
	"DEFAULT": "DEFAULT"
}

var current_animation: String = ANIMATIONS["DEFAULT"]
var next_animation: String = ANIMATIONS["DEFAULT"]

##
# Builtin functions
##

func _ready() -> void:
	self.lifetime = 5.0
	self.shot_delay = 0.5
	self.speed = 4.0

	$AnimationPlayer.play(self.current_animation)

	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start(self.lifetime)

func _physics_process(_delta: float) -> void:
	var current_rotation = self.global_rotation
	self.actual_velocity = Vector2(cos(current_rotation), sin(current_rotation)) * self.speed
	
	var collision = move_and_collide(self.actual_velocity)
	if collision != null:
		if collision.collider.is_in_group(GameManager.WALL_GROUP):
			self.queue_free()
		if collision.collider.is_in_group(GameManager.ENEMY_GROUP):
			# TODO have a death state
			collision.collider.queue_free()
			self.queue_free()

##
# Connections
##

func _on_timer_timeout() -> void:
	self.queue_free()

##
# Private functions
##

##
# Public functions
##


