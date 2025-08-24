class_name GameController extends Node

@onready var player= Global.player
@export_category("Refrences")
@export var world2d: Node2D
@export var world3d: Node3D
@export var gui: Control
@export_category("Settings")
@export var testing: bool= false
@export_category("impScene")
@export var finished:String 
@export var tut_gui:String 
@export var test_level = "res://scenes/environment/level_1.tscn"
@export var default_gui:String


var current_3d_scene:Node3D
var current_2d_scene:Node2D
var current_gui_scene: Control
var path_current_3d_scene: String
var path_current_2d_scene: String
var path_main_menu: String
var path_curr_gui: String

func _ready() -> void:
	Global.game_controller = self
	if testing:
		change_3d_scene(test_level)
	else:
		Global.game_controller.paused = true

func start_tut():
	change_gui_scene(tut_gui)

func end_tut():
	change_gui_scene()

func end_game():
	change_gui_scene(finished)

func change_3d_scene(new_scene:String, delete:bool = true, keep_running:bool=false)->void:
	# fixed and working.
	if current_3d_scene != null:
		if delete:
			current_3d_scene.queue_free()
		elif keep_running:
			current_3d_scene.visible = false
		else:
			world3d.remove_child(current_3d_scene)
	var new = load(new_scene).instantiate()
	world2d.add_child(new)
	path_current_3d_scene = new_scene
	current_3d_scene = new


func change_gui_scene(new_scene:String = default_gui, delete:bool = true, keep_running:bool=false)->void:
	# Needs to be fixed as pe req for this.
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new:Control = load(new_scene).instantiate()
	if(new_scene == "res://GUI/options_menu.tscn"):
		new.previous_route = current_gui_scene.scene_file_path
	gui.add_child(new)
	if current_gui_scene:
		new.set_meta("previous", current_gui_scene.scene_file_path)
	current_gui_scene = new
	path_curr_gui = new_scene
	
func change_2d_scene(new_scene:String, delete:bool = true, keep_running:bool=false)->void:
	# Needs to be fixed as pe req for this.
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world2d.remove_child(current_2d_scene)
	var new = load(new_scene).instantiate()
	world2d.add_child(new)
	path_current_2d_scene = new_scene
	current_2d_scene = new
	if current_2d_scene.has_meta("LEVEL"):
		change_gui_scene("res://GUI/InGameUI.tscn")
