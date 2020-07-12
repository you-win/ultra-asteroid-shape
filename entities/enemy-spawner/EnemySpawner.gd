extends Path2D

export var enemy: PackedScene = preload("res://entities/enemies/asteroid/Asteroid.tscn")

export var spawn_delay: float = 1.0

var enemy_speed_modifier: float = 1.0

onready var spawn_path: PathFollow2D = $PathFollow2D
onready var timer: Timer = $Timer
onready var entities_node: Node = get_parent().get_parent().get_node("ActiveEntities")

##
# Builtin functions
##

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")

	timer.start(spawn_delay)

	_subscribe_to_pubsub()

##
# Connections
##

func _on_timer_timeout() -> void:
	spawn_path.offset = randi()
	
	var instance = enemy.instance()
	instance.global_position = spawn_path.global_position
	instance.rotation = spawn_path.rotation + PI/2 + rand_range(-PI/4, PI/4)
	instance.speed_modifier = enemy_speed_modifier
	entities_node.call_deferred("add_child", instance)

	timer.start(spawn_delay)


##
# Private functions
##

func _subscribe_to_pubsub() -> void:
	PubSub.subscribe(GameManager.PUBSUB_KEYS.CHAOS_SPAWN_UP, self)
	PubSub.subscribe(GameManager.PUBSUB_KEYS.CHAOS_ENEMY_PERM, self)

##
# Public functions
##

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.CHAOS_SPAWN_UP:
			if spawn_delay > 0.2:
				spawn_delay *= 0.75
		GameManager.PUBSUB_KEYS.CHAOS_ENEMY_PERM:
			match payload["name"]:
				"enemy_speed_modifier":
					enemy_speed_modifier += payload["value"]
