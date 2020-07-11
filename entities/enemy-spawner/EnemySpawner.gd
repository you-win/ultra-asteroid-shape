extends Path2D

var enemy: PackedScene = preload("res://entities/enemies/asteroid/Asteroid.tscn")

var spawn_delay: int = 1

onready var spawn_path: PathFollow2D = $PathFollow2D
onready var timer: Timer = $Timer
onready var entities_node: Node = get_parent().get_parent().get_node("ActiveEntities")

##
# Builtin functions
##

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")

	timer.start(spawn_delay)

##
# Connections
##

func _on_timer_timeout() -> void:
	spawn_path.offset = randi()
	
	var instance = enemy.instance()
	instance.global_position = spawn_path.global_position
	instance.rotation = spawn_path.rotation + PI/2 + rand_range(-PI/4, PI/4)
	entities_node.call_deferred("add_child", instance)

	timer.start(spawn_delay)


##
# Private functions
##

##
# Public functions
##


