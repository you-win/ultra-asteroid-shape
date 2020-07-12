extends Node2D

var old_points: int = 0
var old_chaos: int = 0
var points: int = 0
var game_over: bool = false

var retry_flash_delay: float = 0.8
var retry_hide_delay: float = 0.4

onready var points_label: Label = $UILayer/PointsLabel
onready var chaos_label: Label = $UILayer/ChaosLabel

##
# Builtin functions
##

func _ready() -> void:
	points_label.text = str(points)
	chaos_label.text = str(ChaosGenerator.chaos_level)
	
	ChaosGenerator.refresh_chaos()
	_subscribe_to_pubsub()
	
	if not get_tree().root.get_node("StandardGameMusic").playing:
		get_tree().root.get_node("StandardGameMusic").play()

func _physics_process(_delta: float) -> void:
	chaos_label.text = "Chaos: " + str(ChaosGenerator.chaos_level)
	if(ChaosGenerator.chaos_level == 1 and points > 5):
		old_points = 5
		old_chaos += 1
		PubSub.publish(GameManager.PUBSUB_KEYS.INCREASE_CHAOS)
	elif(ChaosGenerator.chaos_level == 2 and points > 10):
		old_points = 10
		old_chaos += 1
		PubSub.publish(GameManager.PUBSUB_KEYS.INCREASE_CHAOS)
	elif(ChaosGenerator.chaos_level == 3 and points > (old_points + 10)):
		old_points = points
		old_chaos += 1
		_create_asteroid_spawner()
		PubSub.publish(GameManager.PUBSUB_KEYS.INCREASE_CHAOS)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel") and not game_over):
		$PauseLayer.visible = true
		get_tree().paused = true

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

func _create_asteroid_spawner() -> void:
	# Defaults to asteroid spawner
	var spawner_scene = load("res://entities/enemy-spawner/EnemySpawner.tscn")
	var instance = spawner_scene.instance()
	$Spawners.call_deferred("add_child", instance)

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

func _subscribe_to_pubsub() -> void:
	PubSub.subscribe(GameManager.PUBSUB_KEYS.PICKUP, self)
	PubSub.subscribe(GameManager.PUBSUB_KEYS.GAME_OVER, self)

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
				if points != 0:
					for i in range(0, 10):
						if GameManager.high_scores[i] < points:
							GameManager.high_scores.insert(i, points)
							GameManager.high_scores.pop_back()
							return # Only replace one value
						elif GameManager.high_scores[i] == points:
							continue
