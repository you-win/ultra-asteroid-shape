extends Node2D

onready var start_game_button: Button = $MenuButtons/StartGameButton
onready var high_scores_button: Button = $MenuButtons/HighScoresButton
onready var quit_button: Button = $MenuButtons/QuitButton

##
# Builtin functions
##

func _ready() -> void:
	start_game_button.connect("button_down", self, "_on_start_button_pressed")
	high_scores_button.connect("button_down", self, "_on_high_scores_button_pressed")
	quit_button.connect("button_down", self, "_on_quit_button_pressed")

##
# Connections
##

func _on_start_button_pressed() -> void:
	get_tree().change_scene("res://screens/standard-game/StandardGame.tscn")

func _on_high_scores_button_pressed() -> void:
	get_tree().change_scene("res://screens/high-scores/HighScores.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

##
# Private functions
##

##
# Public functions
##


