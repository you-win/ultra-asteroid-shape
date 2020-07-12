extends Node2D

const CURSOR_Y_POSITIONS: Array = [-11, 17, 45]

var button_order: Array = []
var current_button: int = 0

var flash_delay: float = 0.8
var hide_delay: float = 0.4

onready var start_game_button: Button = $MenuButtons/StartGameButton
onready var high_scores_button: Button = $MenuButtons/HighScoresButton
onready var quit_button: Button = $MenuButtons/QuitButton

onready var cursor: Node2D = $Cursor
onready var flash_timer: Timer = $Cursor/FlashTimer
onready var hide_timer: Timer = $Cursor/HideTimer

##
# Builtin functions
##

func _ready() -> void:
	start_game_button.connect("button_down", self, "_on_start_button_pressed")
	high_scores_button.connect("button_down", self, "_on_high_scores_button_pressed")
	quit_button.connect("button_down", self, "_on_quit_button_pressed")
	
	start_game_button.connect("mouse_entered", self, "_on_start_button_entered")
	high_scores_button.connect("mouse_entered", self, "_on_high_scores_button_entered")
	quit_button.connect("mouse_entered", self, "_on_quit_button_entered")
	
	flash_timer.connect("timeout", self, "_on_flash_timer_timeout")
	hide_timer.connect("timeout", self, "_on_hide_timer_timeout")
	
	button_order.append(start_game_button)
	button_order.append(high_scores_button)
	button_order.append(quit_button)
	
	if not get_tree().root.get_node_or_null("Select"):
		_create_menu_select_sound()

func _process(_delta: float) -> void:
	if cursor.global_position.y != CURSOR_Y_POSITIONS[current_button]:
		$Sounds/Menu.play()
		cursor.global_position.y = CURSOR_Y_POSITIONS[current_button]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		if current_button > 0:
			current_button -= 1
		else:
			current_button = 2
	if event.is_action_pressed("ui_down"):
		if current_button < 2:
			current_button += 1
		else:
			current_button = 0
	if(event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select")):
		button_order[current_button].emit_signal("button_down")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

##
# Connections
##

func _on_start_button_pressed() -> void:
	get_tree().root.get_node("Select").connect("finished", GameManager, "_on_select_sound_finished")
	get_tree().root.get_node("Select").play()
	get_tree().change_scene("res://screens/standard-game/StandardGame.tscn")

func _on_high_scores_button_pressed() -> void:
	get_tree().root.get_node("Select").play()
	get_tree().change_scene("res://screens/high-scores/HighScores.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_entered() -> void:
	current_button = 0

func _on_high_scores_button_entered() -> void:
	current_button = 1

func _on_quit_button_entered() -> void:
	current_button = 2

func _on_flash_timer_timeout() -> void:
	flash_timer.stop()
	hide_timer.start(hide_delay)
	cursor.visible = false

func _on_hide_timer_timeout() -> void:
	hide_timer.stop()
	flash_timer.start(flash_delay)
	cursor.visible = true

##
# Private functions
##

func _create_menu_select_sound() -> void:
	var menu_select_sound: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	menu_select_sound.name = "Select"
	menu_select_sound.stream = load("res://assets/props/menu-select.wav")
	get_tree().root.call_deferred("add_child", menu_select_sound)

##
# Public functions
##


