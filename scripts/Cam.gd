extends Node

var curr:Camera2D

@export var target = null
@export var rotation:float : 
	set(new):
		curr.rotation = new
		rotation = new
@export var smoothing:float :
	set(new):
		curr.position_smoothing_speed = new
		smoothing = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr = Camera2D.new()
	get_tree().current_scene.add_child(curr)
	curr.position_smoothing_enabled = true

func _physics_process(_delta: float) -> void:
	if target:
		curr.position = target.position if target is Node2D else target
	
