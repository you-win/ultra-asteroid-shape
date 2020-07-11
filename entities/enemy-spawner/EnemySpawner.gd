extends Path2D

var enemy: PackedScene = preload("res://entities/enemies/asteroid/Asteroid.tscn")

onready var spawn_path: PathFollow2D = $PathFollow2D

##
# Builtin functions
##

func _ready() -> void:
	pass

##
# Connections
##

func _on_timer_timeout() -> void:
	spawn_path.offset = randi()
	
	var instance = enemy.instance()
	instance.global_position = spawn_path.global_position
	instance.rotation = spawn_path.rotation + PI/2 + rand_range(-PI/4, PI/4)

##
# Private functions
##

##
# Public functions
##


