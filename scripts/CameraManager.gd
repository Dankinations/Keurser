extends Node

var curr:Camera2D

@export var target = null
@export var rotation:float : 
	set(new):
		curr.rotation = new
		rotation = new
var camera_snappiness = 10
var offset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr = Camera2D.new()
	curr.zoom = Vector2.ONE/1.25
	get_tree().current_scene.call_deferred("add_child",curr)

func _physics_process(delta: float) -> void:
	if target:
		curr.global_position = curr.global_position.lerp(target.global_position+offset,1.0 - exp(-camera_snappiness * delta)) if target is Node2D else target
	
