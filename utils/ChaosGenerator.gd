extends Node

"""
ChaosGenerator

Generate random effects. Basically a PubSub helper for the GameManager.
"""

##
# Builtin functions
##

func _ready() -> void:
	pass

##
# Connections
##

##
# Private functions
##

##
# Public functions
##

func event_published(event_key: String, payload) -> void:
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			pass
