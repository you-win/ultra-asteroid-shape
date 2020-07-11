extends Node2D

const HIGH_SCORES_FILE: String = ""

onready var scores: Control = $Scores
onready var back_button: Button = $BackButton

##
# Builtin functions
##

func _ready() -> void:
#	_generate_label_nodes()
	
	back_button.connect("button_down", self, "_on_back_button_pressed")

##
# Connections
##

func _on_back_button_pressed() -> void:
	get_tree().change_scene("res://screens/main-menu/MainMenu.tscn")

##
# Private functions
##

func _read_high_scores_file() -> Dictionary:
	"""
	Scores are stored as a dictionary of dictionaries for ease of logic.
	
	e.g. Rank one is "1": {"name": "FFF", "score": "69"}
	"""
	var file: File = File.new()
	file.open(HIGH_SCORES_FILE, File.READ)
	
	var high_scores: Dictionary = JSON.parse(file.get_as_text()).result as Dictionary
	
	file.close()
	
	return high_scores

func _generate_label_nodes() -> void:
	"""
	Generate labels for the top ten scores. No scrolling.
	"""
	var high_scores: Dictionary = _read_high_scores_file()
	
	for i in range(1, 11):
		var new_label: Label = Label.new()
		new_label.text = high_scores[i]["name"] + " : " + high_scores[i]["score"]
		
		new_label.rect_position.y = i * -18
		
		scores.call_deferred("add_child", new_label)

##
# Public functions
##


