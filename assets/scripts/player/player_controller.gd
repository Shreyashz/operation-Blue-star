class_name Player extends CharacterBody3D

@export var debug : bool = false
@export_category("References")
@export var camera_controller : CameraController
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var animation_player: AnimationPlayer
@export var crouch_check : ShapeCast3D
@export var interaction_raycast : RayCast3D
@export_category("Movement Settings")
@export_group("Easing")
@export var acceleration : float = 0.2
@export var deceleration : float = 0.5
@export_group("Speed")
@export var accelaration: float = 0.1
@export var decelaration: float = 0.25
@export var default_speed : float = 5.0
@export var sprint_speed : float = 3.0
@export var crouch_speed : float = -3.0
@export_category("Jump Settings")
@export var jump_velocity : float = 4.5
@export_category("crouching")
@export var toggle_crouch: bool = false

var _is_crouching: bool = false
var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0
var speed : float = 0.0

func _ready() -> void:
	Global.player = self
	crouch_check.add_exception(self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_exit"):
		get_tree().quit()
	if event.is_action_pressed("sprint"):
		sprint()
	elif event.is_action_released("sprint"):
		walk()
	if event.is_action_pressed("crouch") and is_on_floor() and toggle_crouch:
		if _is_crouching and crouch_check.is_colliding() == false:
			stand()
		elif !_is_crouching:
			crouch()
	if event.is_action_pressed("crouch") and !_is_crouching and is_on_floor() and !toggle_crouch:
		crouch()
	if event.is_action_released("crouch") and !toggle_crouch:
		if !crouch_check.is_colliding():
			stand()
		else:
			stand_later()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var speed_modifier = sprint_modifier + crouch_modifier
	speed = default_speed + speed_modifier
	
	_input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)
	
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	velocity = _movement_velocity
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	move_and_slide()
	

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)


func sprint() -> void:
	sprint_modifier = sprint_speed
	
	
func walk() -> void:
	sprint_modifier = 0.0

func stand_later() -> void:
	if crouch_check.is_colliding():
		await get_tree().create_timer(0.1).timeout
		stand_later()
	else:
		stand()

func stand() -> void:
	animation_player.play("crouch", -1 , crouch_speed, true)
	if debug:
		print("uncrouch")
	crouch_modifier = 0.0
	_is_crouching = false
	standing_collision.disabled = false
	crouching_collision.disabled = true

func crouch() -> void:
	animation_player.play("crouch", -1, -crouch_speed)
	crouch_modifier = crouch_speed
	if debug:
		print("crouch")
	_is_crouching = true
	standing_collision.disabled = true
	crouching_collision.disabled = false

func jump() -> void:
	velocity.y = jump_velocity
