extends Node3D

@export var rayshape: ShapeCast3D
@export var animationPlayer: AnimationPlayer
@export var kickTimer: Timer
@export var BigOneTimer: Timer
@export var shapesNode: Node3D

var shapes

func _ready() -> void:
	shapes = shapesNode.get_children()
	for i in shapes:
		i.visible = false


func _physics_process(delta: float) -> void:
	if rayshape.get_collider(0) != null:
		_fire()

func _fire():
	pass
