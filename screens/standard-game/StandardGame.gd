extends Node2D

var points: int = 0
var game_over: bool = false

var retry_flash_delay: float = 0.8
var retry_hide_delay: float = 0.4

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

func _on_retry_flash_timer_timeout() -> void:
	get_node("FlashTimer").stop()
	get_node("HideTimer").start(retry_hide_delay)
	$GameOverLayer/RetryLabel.visible = false

func _on_retry_hide_timer_timeout() -> void:
	get_node("HideTimer").stop()
	get_node("FlashTimer").start(retry_flash_delay)
	$GameOverLayer/RetryLabel.visible = true

##
# Private functions
##

func _show_and_update_game_over_layer(killedBy: String) -> void:
	$GameOverLayer/KilledByLabel.text = "Killed by " + killedBy
	
	$GameOverLayer.visible = true

func _create_retry_timers() -> void:
	var retry_flash_timer: Timer = Timer.new()
	var retry_hide_timer: Timer = Timer.new()

	retry_flash_timer.name = "FlashTimer"
	retry_flash_timer.autostart = true
	retry_hide_timer.name = "HideTimer"

	call_deferred("add_child", retry_flash_timer)
	call_deferred("add_child", retry_hide_timer)

	retry_flash_timer.connect("timeout", self, "_on_retry_flash_timer_timeout")
	retry_hide_timer.connect("timeout", self, "_on_retry_hide_timer_timeout")

func _add_retry_listener() -> void:
	var listener_scene = load("res://screens/standard-game/RetryListener.gd")
	var listener = listener_scene.new()
	listener.name = "RetryListener"
	call_deferred("add_child", listener)

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
				game_over = true
				_show_and_update_game_over_layer(payload["name"])
				_create_retry_timers()
				_add_retry_listener()
