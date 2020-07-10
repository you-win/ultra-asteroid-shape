extends Area2D

##
# Builtin functions
##

func _ready() -> void:
	pass

##
# Connections
##

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		PubSub.publish(GameManager.PUBSUB_KEYS.PICKUP)
		self.queue_free()

##
# Private functions
##

##
# Public functions
##


