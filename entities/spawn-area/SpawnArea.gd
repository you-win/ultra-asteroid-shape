extends Area2D

var pickup: PackedScene = preload("res://entities/pickup/Pickup.tscn")

onready var rectangle_size: Vector2 = $CollisionShape2D.shape.extents/2
onready var entities_node: Node = get_parent().get_parent().get_node("ActiveEntities")

##
# Builtin functions
##

func _ready() -> void:
	PubSub.subscribe(GameManager.PUBSUB_KEYS.PICKUP, self)
	_spawn()

##
# Connections
##

##
# Private functions
##

func _spawn() -> void:
	var instance := pickup.instance()
	instance.global_position = _generate_random_position_in_area()
	entities_node.call_deferred("add_child", instance)


func _generate_random_position_in_area() -> Vector2:
	var random_position: Vector2 = Vector2.ZERO
	random_position.x = self.global_position.x + rand_range(-rectangle_size.x, rectangle_size.x)
	random_position.y = self.global_position.y + rand_range(-rectangle_size.y, rectangle_size.y)
	return random_position

##
# Public functions
##

func spawn() -> void:
	_spawn()

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			print_debug("Spawning another pickup")
			_spawn()
