extends CharacterBody2D
class_name PlayerBase

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

func movementTick(direction:Vector2,_echo:bool,_dt:float):
	velocity = velocity.move_toward(direction * walkSpeed*100,walkSpeed*25)

func healTick():
	if health < maxHealth: health = clamp(health+vitality,0,maxHealth)

func attack(pos:Vector2):
	#var area = Area2D.new()
	#area.global_position = pos
	#area.collision_layer = 0
	#area.collision_mask = 2
	#var collisionShape = CollisionShape2D.new()
	#collisionShape.shape = CircleShape2D.new()
	#collisionShape.shape.radius = 50
	#get_tree().current_scene.add_child(area)
	#await get_tree().physics_frame
	#var hit = area.get_overlapping_bodies()
	#
	#for x in hit:
		#if "health" in x and x!=self: 
			#x.health -= damage
			#print("did damage to thing!!")
	#
	#await get_tree().create_timer(2).timeout
	#area.queue_free()
	var circle = CircleShape2D.new(); circle.radius = 40
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = circle
	query.transform = Transform2D(0,get_global_mouse_position())
	query.collision_mask = 2
	var hits = space.intersect_shape(query)
	for x in hits:
		var hit:RigidBody2D = x.collider
		if "health" in hit:
			hit.health -= damage
# Main

func _ready():
	var htimer : Timer = Timer.new()
	htimer.wait_time = 1; htimer.autostart = true; htimer.name = "Heal_Timer"
	add_child(htimer)
	htimer.timeout.connect(healTick)
	GameManager.player = self

func _process(_dt):
	if Input.is_action_just_pressed("click"):
		attack(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	var tempMoveDirection = Input.get_vector("move_left","move_right","move_up","move_down")
	var echo = tempMoveDirection != moveDirection
	moveDirection = tempMoveDirection
	movementTick(moveDirection,echo,delta)
	move_and_slide()
	
	var collisions = get_slide_collision_count()
	for i in collisions:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if "pushable" in collider and collider is RigidBody2D:
			collider.apply_central_impulse(-collision.get_normal()*walkSpeed)
