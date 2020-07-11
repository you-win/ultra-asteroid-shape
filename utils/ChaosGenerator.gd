extends Node

"""
ChaosGenerator

Generate random effects. Basically a PubSub helper for the GameManager.
"""

enum EFFECT_TYPES {
	TEMPORARY_PLAYER_EFFECTS,
	PERMANENT_PLAYER_EFFECTS,
	TEMPORARY_ENEMY_EFFECTS,
	PERMANENT_ENEMY_EFFECTS
}

const TEMPORARY_PLAYER_EFFECTS = {
	"DRUNK_AIM": "The gun is drunk!",
	"NO_BRAKES": "This train has no brakes!",
	"BACKUP_ONLY": "No time to switch gears!",
	"ONLY_TURN_LEFT": "A very inefficient delivery route!",
	"ONLY_TURN_RIGHT": "A more efficient delivery route!",
	"FLIP_SPRITE": "Now this is podracing!",
	"SHOOT_MORE_BULLETS": "pew pew pew",
	"SHOT_DELAY_UP": "Stop fumbling the bullets!",
	"SHOT_DELAY_DOWN": "Infinite ammo!"
}

const PERMANENT_PLAYER_EFFECTS = {
	"SPEED_UP": "Overclocked!",
	"SPEED_DOWN": "Now who put that gum there?",
	"TURN_SPEED_UP": "Try not to throw up!"
}

const TEMPORARY_ENEMY_EFFECTS = {

}

const PERMANENT_ENEMY_EFFECTS = {

}

var rng = RandomNumberGenerator.new()

var temporary_player_effects_keys: Array = TEMPORARY_PLAYER_EFFECTS.keys()
var permanent_player_effects_keys: Array = PERMANENT_PLAYER_EFFECTS.keys()
var temporary_enemy_effects_keys: Array = TEMPORARY_ENEMY_EFFECTS.keys()
var permanent_enemy_effects_keys: Array = PERMANENT_ENEMY_EFFECTS.keys()

##
# Builtin functions
##

func _ready() -> void:
	rng.randomize()

##
# Connections
##

##
# Private functions
##

func _send_out_new_effect() -> void:
	# TODO always use temp player effects for now
	# var effect_type: int = rng.randi_range(0, 3)
	var effect_type: int = 0
	var random_number: int
	# I could wrap the effect types to make this more programmatic but w/e
	match effect_type:
		0: # Temporary player effects
			random_number = rng.randi_range(0, temporary_player_effects_keys.size())
			PubSub.publish(GameManager.PUBSUB_KEYS.CHAOS_PLAYER, {
				"type": EFFECT_TYPES.TEMPORARY_PLAYER_EFFECTS,
				"name": temporary_player_effects_keys[random_number]
			})
		1:
			random_number = rng.randi_range(0, permanent_player_effects_keys.size())
			PubSub.publish(GameManager.PUBSUB_KEYS.CHAOS_PLAYER, {
				"type": EFFECT_TYPES.PERMANENT_PLAYER_EFFECTS,
				"name": permanent_player_effects_keys[random_number]
			})
		2:
			random_number = rng.randi_range(0, temporary_enemy_effects_keys.size())
			PubSub.publish(GameManager.PUBSUB_KEYS.CHAOS_ENEMY, {
				"type": EFFECT_TYPES.TEMPORARY_ENEMY_EFFECTS,
				"name": temporary_enemy_effects_keys[random_number]
			})
		3:
			random_number = rng.randi_range(0, permanent_enemy_effects_keys.size())
			PubSub.publish(GameManager.PUBSUB_KEYS.CHAOS_ENEMY, {
				"type": EFFECT_TYPES.PERMANENT_ENEMY_EFFECTS,
				"name": permanent_enemy_effects_keys[random_number]
			})
		_:
			printerr("Bad effect type")

##
# Public functions
##

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			_send_out_new_effect()
