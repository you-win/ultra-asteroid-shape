extends Node

"""
ChaosGenerator

Generate random effects. Basically a PubSub helper for the GameManager.
"""

enum EFFECT_TYPES {
	TEMP_PLAYER_EFFECTS,
	PERM_PLAYER_EFFECTS,
	TEMP_ENEMY_EFFECTS,
	PERM_ENEMY_EFFECTS
}

const TEMP_PLAYER_EFFECTS = {
	"DRUNK_AIM": "The gun is drunk!",
	"NO_BRAKES": "This train has no brakes!",
	"BACKUP_ONLY": "No time to switch gears!",
	"ONLY_TURN_LEFT": "A very inefficient delivery route!",
	"ONLY_TURN_RIGHT": "A more efficient delivery route!",
	"FLIP_SPRITE": "Now this is podracing!",
	"SHOOT_MORE_BULLETS": "pew pew pew",
	"SHOT_DELAY_UP": "Stop fumbling the bullets!"
}

const PERM_PLAYER_EFFECTS = {
	"SPEED_UP": "Overclocked!",
	"SPEED_DOWN": "Now who put that gum there?",
	"TURN_SPEED_UP": "Try not to throw up!"
}

const TEMP_ENEMY_EFFECTS = {

}

const PERM_ENEMY_EFFECTS = {

}

var rng = RandomNumberGenerator.new()

var temp_player_effects_keys: Array = TEMP_PLAYER_EFFECTS.keys()
var perm_player_effects_keys: Array = PERM_PLAYER_EFFECTS.keys()
var temp_enemy_effects_keys: Array = TEMP_ENEMY_EFFECTS.keys()
var perm_enemy_effects_keys: Array = PERM_ENEMY_EFFECTS.keys()

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
	match effect_type:
		0: # Temporary player effects
			random_number = rng.randi_range(0, temp_player_effects_keys.size() - 1)
			_create_temp_player_effect(temp_player_effects_keys[random_number])
		1:
			random_number = rng.randi_range(0, perm_player_effects_keys.size())
			
		2:
			random_number = rng.randi_range(0, temp_enemy_effects_keys.size())
			
		3:
			random_number = rng.randi_range(0, perm_enemy_effects_keys.size())
			
		_:
			printerr("Bad effect type")

func _create_temp_player_effect(effect_name: String) -> void:
	var modifier: String = ""
	var value: String = ""
	var quip: String = TEMP_PLAYER_EFFECTS[effect_name]
	match TEMP_PLAYER_EFFECTS[effect_name]:
		TEMP_PLAYER_EFFECTS.DRUNK_AIM:
			modifier = "shoot_aim_modifier"
			value = str(rng.randf_range(-1.5, 1.5))
		TEMP_PLAYER_EFFECTS.NO_BRAKES:
			modifier = "disable_forward_movement_modifier"
			value = "true"
		TEMP_PLAYER_EFFECTS.BACKUP_ONLY:
			modifier = "inputmap"
			value = "ui_up"
		TEMP_PLAYER_EFFECTS.ONLY_TURN_LEFT:
			modifier = "inputmap"
			value = "ui_right"
		TEMP_PLAYER_EFFECTS.ONLY_TURN_RIGHT:
			modifier = "inputmap"
			value = "ui_left"
		TEMP_PLAYER_EFFECTS.FLIP_SPRITE:
			modifier = "sprite"
			value = "true"
		TEMP_PLAYER_EFFECTS.SHOOT_MORE_BULLETS:
			modifier = "bullet_amount_modifier"
			value = "3"
		TEMP_PLAYER_EFFECTS.SHOT_DELAY_UP:
			modifier = "shot_delay_modifier"
			value = str(rng.randf_range(2, 3))
	PubSub.publish(GameManager.PUBSUB_KEYS.CHAOS_PLAYER_TEMP, {
		"modifier": modifier,
		"value": value,
		"quip": quip
	})

##
# Public functions
##

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			_send_out_new_effect()
