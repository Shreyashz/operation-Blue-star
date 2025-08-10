class_name PlayerMovementState

extends State

var PLAYER: Player
var ANIMATION: AnimationPlayer

func _ready()->void:
	await  owner.ready
	PLAYER = Global.player as Player
	ANIMATION = PLAYER.animation_player

func _process(delta: float) -> void:
	pass
