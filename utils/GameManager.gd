extends Node

"""
GameManager

Holds shared data for use across many objects. This is the single source of truth for the game.
"""

const WALL_GROUP: String = "wall"
const PLAYER_GROUP: String = "player"
const ENEMY_GROUP: String = "enemy"
const PROPS_GROUP: String = "prop"

const PUBSUB_KEYS = {
	"PICKUP": "PICKUP",
	"GAME_OVER": "GAME_OVER",
	"INCREASE_CHAOS": "INCREASE_CHAOS",
	"CHAOS_PLAYER_TEMP": "CHAOS_PLAYER_TEMP",
	"CHAOS_PLAYER_PERM": "CHAOS_PLAYER_PERM",
	"CHAOS_ENEMY_TEMP": "CHAOS_ENEMY_TEMP",
	"CHAOS_ENEMY_PERM": "CHAOS_ENEMY_PERM",
	"CHAOS_SPAWN_UP": "CHAOS_SPAWN_UP"
}

# TODO Hack for getting high scores to work
var high_scores: Array = [
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
]

var debug: bool = true

##
# Builtin functions
##

func _ready() -> void:
	randomize()

##
# Connections
##

func _on_select_sound_finished() -> void:
	get_tree().root.get_node("Select").queue_free()

##
# Private functions
##

##
# Public functions
##


