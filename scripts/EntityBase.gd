class_name EntityBase extends CharacterBody2D

@export_category("Stats")
@export var walkSpeed = 5.0
@export var damage = 5.0
@export var vitality = 0.2
@export var health = 100.0 : 
	set(new):
		HealthChanged.emit(health,new)
		health = new
@export var maxHealth = 100.0 :
	set(new):
		new = new or 0
		health = clampf(health,0,new)
		maxHealth = new

@export_category("Others")
@export var moveDirection = Vector2.ZERO :
	set(new):
		MoveDirChanged.emit(moveDirection,new)
		moveDirection = new
		
var rawMove = Vector2.ZERO

# Signals

signal HealthChanged(old:float,new:float)
signal MoveDirChanged(old:Vector2,new:Vector2)

# Main Changeable functions

func movementTick(direction:Vector2,_echo:bool,_dt:float):
	velocity = velocity.move_toward(direction * walkSpeed*100,walkSpeed*2.5)

func healTick():
	if health < maxHealth: health = clamp(health+vitality,0,maxHealth)

# Main

func _ready():
	var htimer : Timer = Timer.new()
	htimer.wait_time = 1; htimer.autostart = true; htimer.name = "Heal_Timer"
	add_child(htimer)
	htimer.timeout.connect(healTick)

func _physics_process(delta: float) -> void:
	movementTick(moveDirection,true,delta)
	move_and_slide()
	var collisions = get_slide_collision_count()
	for i in collisions:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if "pushable" in collider and collider is RigidBody2D and collider.pushable == true:
			collider.apply_central_impulse(-collision.get_normal()*walkSpeed)
