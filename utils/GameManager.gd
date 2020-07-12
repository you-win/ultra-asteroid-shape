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
	"CHAOS_ENEMY_PERM": "CHAOS_ENEMY_PERM"
}

var debug: bool = true

##
# Builtin functions
##

func _ready() -> void:
	randomize()

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


