extends Node2D

export var entity_to_spawn: PackedScene
export var spawn_on_ready: bool = false
export var time_bewtween_spawns: float = 1.0
export var number_to_spawn: int = 1
export var free_on_completion: bool = true

onready var level_node: Node = get_parent().get_parent().get_node("ActiveEntities")

##
# Builtin functions
##

func _ready() -> void:
	$Timer.connect("timeout", self, "_on_timer_timeout")
	if spawn_on_ready:
		spawn()

##
# Connections
##

func _on_timer_timeout() -> void:
	_spawn()
	if number_to_spawn > 0:
		$Timer.start(time_bewtween_spawns)

##
# Private functions
##

func _spawn() -> void:
	var entity_instance := entity_to_spawn.instance()
	entity_instance.global_position = self.global_position
	level_node.call_deferred("add_child", entity_instance)

##
# Public functions
##

func spawn() -> void:
	if number_to_spawn > 0:
		_spawn()
		number_to_spawn -= 1
	elif free_on_completion:
		self.queue_free()
