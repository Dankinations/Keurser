extends CharacterBody2D

@export_category("Stats")
@export var walkSpeed = 2.0
@export var damage = 5.0
@export var vitality = 0.2
@export var health = 100.0 : 
	set(new):
		HealthChanged.emit(health,new)
		health = new
@export var maxHealth = 100.0 :
	set(new):
		health = clampf(health,0,new)
		maxHealth = new
@export var luck = 0.0

@export_category("Others")
@export var moveDirection = Vector2.ZERO :
	set(new):
		MoveDirChanged.emit(moveDirection,new)
		moveDirection = new

# Signals

signal HealthChanged(old:float,new:float)
signal MoveDirChanged(old:Vector2,new:Vector2)

# Main Changeable functions

func movementTick(direction:Vector2,echo:bool,dt:float):
	velocity = velocity.move_toward(direction * walkSpeed,dt*walkSpeed*10)

func healTick():
	if health < maxHealth: health = clamp(health+vitality,0,maxHealth)

# Main

func _ready():
	var htimer : Timer = Timer.new()
	htimer.wait_time = 1; htimer.autostart = true; htimer.name = "Heal_Timer"
	add_child(htimer)
	htimer.timeout.connect(healTick)
	
func _physics_process(delta: float) -> void:
	var tempMoveDirection = Input.get_vector("move_left","move_right","move_up","move_down")
	var echo = tempMoveDirection != moveDirection
	moveDirection = tempMoveDirection
	movementTick(moveDirection,echo,delta)
	move_and_collide(self.velocity)
