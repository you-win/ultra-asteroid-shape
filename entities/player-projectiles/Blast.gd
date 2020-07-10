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
	self.shot_delay = 0.5
	self.speed = 200.0

	$AnimationPlayer.play(self.current_animation)

func _physics_process(_delta: float) -> void:
	var current_rotation = self.global_rotation
	self.target_velocity = Vector2(cos(current_rotation), sin(current_rotation)) * self.speed
	
	self.actual_velocity = move_and_slide(self.target_velocity)

##
# Connections
##

##
# Private functions
##

##
# Public functions
##


