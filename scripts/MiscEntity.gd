class_name MiscEntity
extends RigidBody2D

@export var friction: float = 2
@export var health: float = 1 : 
	set(new):
		if health > highest_hp: highest_hp = health
		health = max(new,0)
		if new > highest_hp: highest_hp = new
		if !is_node_ready(): return
		if health <= 0: die()
var highest_hp = health
@export var pushable:bool = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.lerp(Vector2.ZERO,1.0 - exp(-friction*state.step))

func die():
	queue_free()
