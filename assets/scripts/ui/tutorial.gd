extends Control
var UIs
var currentI:int = -1
var lent:int = 0
func _ready() -> void:
	UIs = get_children()
	for i in UIs:
		i.visible = false
		lent+=1
	_next()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next"):
		_next()

func _next():
	if currentI >=0:
		UIs[currentI].visible = false
	currentI +=1
	if currentI < lent: 
		UIs[currentI].visible = true
	else:
		Global.game_controller.end_tut()
