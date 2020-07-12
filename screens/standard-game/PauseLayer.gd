extends Node2D

##
# Builtin functions
##

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("ui_cancel"):
			get_tree().paused = false
			_generate_timer()

		for action in InputMap.get_actions():
			if action != "ui_cancel" and event.is_action_pressed(action):
				get_tree().paused = false
				visible = false

##
# Connections
##

func _go_to_main_menu() -> void:
	PubSub.clear()
	get_tree().paused = false
	get_tree().change_scene("res://screens/main-menu/MainMenu.tscn")

##
# Private functions
##

func _generate_timer() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_go_to_main_menu")
	timer.start(0.2)

##
# Public functions
##


