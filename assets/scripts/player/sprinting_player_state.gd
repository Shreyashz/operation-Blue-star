class_name SprintingPlayerState extends PlayerMovementState

@export var TOP_ANIM_SPEED: float = 1.6
func enter()->void:
	ANIMATION.play("sprinting", 0.5, 1.0)
	
func update(delta):
	set_animation_speed(PLAYER.velocity.length())


func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, PLAYER.speed, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)

func _input(event: InputEvent) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")
