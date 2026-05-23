class_name PlayerBase extends EntityBase

func _ready():
	super()
	GameManager.player = self

func _process(_dt):
	if Input.is_action_just_pressed("click"):
		attack(get_global_mouse_position())

func attack(pos:Vector2):
	var circle = CircleShape2D.new(); circle.radius = 40
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	
	query.shape = circle
	query.transform = Transform2D(0,pos)
	query.collision_mask = 2
	var hits = space.intersect_shape(query)
	for x in hits:
		var hit:RigidBody2D = x.collider
		if "health" in hit:
			hit.health -= damage

func _physics_process(delta: float) -> void:
	var tempMoveDirection = Input.get_vector("move_left","move_right","move_up","move_down")
	var echo = tempMoveDirection != moveDirection
	moveDirection = tempMoveDirection
	rawMove = rawMove.lerp(moveDirection,1.0-exp(-walkSpeed*25*delta))
	movementTick(moveDirection,echo,delta)
	move_and_slide()
	
	var collisions = get_slide_collision_count()
	for i in collisions:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if "pushable" in collider and collider is MiscEntity and collider.pushable == true:
			collider.velocity += (-collision.get_normal()*walkSpeed)
