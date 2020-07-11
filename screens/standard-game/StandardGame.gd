extends Node2D

var points: int = 0

onready var points_label: Label = $PointsLabel

##
# Builtin functions
##

func _ready() -> void:
	points_label.text = str(points)
	
	PubSub.subscribe(GameManager.PUBSUB_KEYS.PICKUP, self)

##
# Connections
##

##
# Private functions
##

##
# Public functions
##

func event_published(event_key: String, payload):
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			points += 1
			points_label.text = str(points)
