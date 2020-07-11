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

func _physics_process(delta: float) -> void:
	._physics_process(delta)

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


