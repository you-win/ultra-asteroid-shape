extends Area2D

var eligibility_delay: float = 0.2
var eligible_for_pickup: bool = false

##
# Builtin functions
##

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")
	$AudioStreamPlayer.connect("finished", self, "_on_sound_finished")
	$Timer.connect("timeout", self, "_on_timer_timeout")

	$AnimationPlayer.play("DEFAULT")
	$Timer.start(eligibility_delay)

##
# Connections
##

func _on_body_entered(body: Node) -> void:
	if(eligible_for_pickup and body.is_in_group("player")):
		$AudioStreamPlayer.play()
		$Sprite.visible = false
		$CollisionShape2D.call_deferred("disabled", true)
		PubSub.publish(GameManager.PUBSUB_KEYS.PICKUP)

func _on_timer_timeout() -> void:
	eligible_for_pickup = true

func _on_sound_finished() -> void:
	self.queue_free()

##
# Private functions
##

##
# Public functions
##


