extends Node

const WALL_LAYER: int = 1
const PLAYER_LAYER: int = 2
const ENEMY_LAYER: int = 3
const PLAYER_PROJECTILE_LAYER: int = 4
const ENEMY_PROJECTILE_LAYER: int = 5
const PROPS_LAYER: int = 11

const PUBSUB_KEYS = {
	"PICKUP": "PICKUP"
}

var debug: bool = true

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

##
# Builtin functions
##

func _ready() -> void:
	rng.randomize()

func _input(event: InputEvent) -> void:
	# TODO debug
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

##
# Connections
##

##
# Private functions
##

##
# Public functions
##


