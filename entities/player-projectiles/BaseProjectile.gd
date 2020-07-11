class_name BaseProjectile

extends KinematicBody2D

var lifetime: float = 5.0
var shot_delay: float = 0.5
var speed: float = 4.0

var target_velocity: Vector2 = Vector2.ZERO
var actual_velocity: Vector2 = Vector2.ZERO

##
# Builtin functions
##

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	# Use actual_velocity since we aren't changing the speed dynamically during the object lifetime
	var current_rotation = self.global_rotation
	self.actual_velocity = Vector2(cos(current_rotation), sin(current_rotation)) * self.speed
	
	var collision = move_and_collide(self.actual_velocity)
	if collision != null:
		if collision.collider.collision_layer == GameManager.WALL_LAYER:
			self.queue_free()

##
# Connections
##

##
# Private functions
##

##
# Public functions
##


