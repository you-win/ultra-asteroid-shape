extends Node

##
# Builtin functions
##

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		PubSub.clear()
		get_tree().change_scene("res://screens/standard-game/StandardGame.tscn")

##
# Connections
##

##
# Private functions
##

##
# Public functions
##


