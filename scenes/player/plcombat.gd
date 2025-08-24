class_name CombatController extends Node3D
enum sides{left, right}

@export_category("Ref")
@export var SecAnimation_player:AnimationPlayer
@export var PunchCoolDownTimer:Timer
@export var DoublePCoolDownTimer:Timer
@export var HitBox: Area3D
@export var punchTimerBar:ProgressBar
@export var doublePTimerBar:ProgressBar
@export_category("Punch")
@export var coolDownTime:Dictionary = {"punch":1.5, "double":4.0}
@export var leftHand:MeshInstance3D
@export var rightHand:MeshInstance3D

var puchOnCoolDown:bool = false
var doubleOnCoolDown:bool = false
func _process(delta: float) -> void:
	if puchOnCoolDown or doubleOnCoolDown:
		update_coolDownBar()
	

func update_coolDownBar():
	punchTimerBar.value = (PunchCoolDownTimer.time_left/coolDownTime["punch"])*100
	doublePTimerBar.value = (DoublePCoolDownTimer.time_left/coolDownTime["double"])*100

func fire(hand:sides):
	if !puchOnCoolDown:
		match hand:
			sides.left:
				play_Punch("L_HandPunch")
			sides.right:
				play_Punch("R_HandPunch")
		PunchCoolDownTimer.start(coolDownTime["punch"])
		puchOnCoolDown = true
		

func two_handed():
	if !doubleOnCoolDown:
		owner._stop()
		HitBox.set_meta("damage", 30)
		SecAnimation_player.play("dual_handPunch")
		DoublePCoolDownTimer.start(coolDownTime["double"])
		await  SecAnimation_player.animation_finished
		owner._start()
		doubleOnCoolDown = true

func play_Punch(anim:String):
	owner._stop()
	HitBox.set_meta("damage", 10)
	SecAnimation_player.play(anim)
	await SecAnimation_player.animation_finished
	owner._start()

func punchcoolDownOver():
	puchOnCoolDown = false
func doublecoolDownOver():
	doubleOnCoolDown = false
 # Replace with function body.
