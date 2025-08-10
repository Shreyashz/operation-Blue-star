class_name  IdlePlayerState

extends PlayerMovementState

func enter()-> void:
	await  owner.ready
	ANIMATION.pause()

func update(delta):
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
