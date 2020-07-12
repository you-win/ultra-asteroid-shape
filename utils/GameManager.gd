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

var menu_select_sound: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

var debug: bool = true

##
# Builtin functions
##

func _ready() -> void:
	randomize()
	menu_select_sound.stream = load("res://assets/props/menu-select.wav")
	add_child(menu_select_sound)

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


