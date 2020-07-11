extends Node2D

var points: int = 0
var game_over: bool = false

onready var points_label: Label = $UILayer/PointsLabel

##
# Builtin functions
##

func _ready() -> void:
	points_label.text = str(points)
	
	PubSub.subscribe(GameManager.PUBSUB_KEYS.PICKUP, self)
	PubSub.subscribe(GameManager.PUBSUB_KEYS.GAME_OVER, self)

##
# Connections
##

##
# Private functions
##

func _show_and_update_game_over_layer(killedBy: String) -> void:
	$GameOverLayer/KilledByLabel.text = "Killed by " + killedBy
	
	$GameOverLayer.visible = true

##
# Public functions
##

func event_published(event_key: String, payload):
	match event_key:
		GameManager.PUBSUB_KEYS.PICKUP:
			points += 1
			points_label.text = str(points)
		GameManager.PUBSUB_KEYS.GAME_OVER:
			if not game_over:
				_show_and_update_game_over_layer(payload["name"])
