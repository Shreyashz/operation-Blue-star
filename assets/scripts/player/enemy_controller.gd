class_name EnemyController extends CharacterBody3D

enum states {idle, found, attack}


@onready var cur_state:states = states.idle
@onready var player:Player = Global.player
@onready var health:float = 1000

@export_category("Ref")
@export var nav_agent:NavigationAgent3D
@export var cast_shape:ShapeCast3D 
@export var timer:Timer
@export var RayCheckWall:RayCast3D
@export var progressBar: ProgressBar

@export_category("Speed")
@export var chase_speed = 4.0
@export var wander_speed = 4.0
@export var turn_speed = 0.5

@export_category("Exta")
@export var safeDist:float = 1.0


var direction
var safeOffset:Vector3 = Vector3(safeDist, 0, safeDist)

func _ready() -> void:
	randomize_direction()

func _process(delta: float) -> void:
	if RayCheckWall.get_collider():
		direction = -direction
	if cast_shape.get_collider(0) != null:
		set_state(states.found)
	else:
		set_state(states.idle)
	if health>0:
		progressBar.value = health
	elif health==0:
		Global.game_controller.end_game()



func _physics_process(delta: float) -> void:
	if cur_state == states.idle:
		wonderAround(delta)
	elif cur_state == states.found:
		chase_player()
	elif cur_state == states.attack:
		wait_to_comp()

func wait_to_comp():
	velocity = Vector3.ZERO

func randomize_direction():
	direction = Vector3(randf_range(-1.0, 1.0), 0,randf_range(-1.0, 1.0)).normalized()

func wonderAround(delta):
	velocity = direction * wander_speed
	look_at(global_position + velocity, Vector3.UP)
	move_and_slide()

func chase_player():
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin - safeOffset)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * chase_speed
	look_at(Vector3(player.global_position.x, global_position.y ,player.global_position.z),  Vector3.UP)
	move_and_slide()

func set_state(state_t:states):
	cur_state = state_t

func punched(damage:float):
	health -= damage
