extends PlayerBase

func movementTick(direction:Vector2,_echo:bool,dt:float):
	super(direction,_echo,dt)
	var goal = rawMove.x/1*15 
	$TorsoBone.rotation_degrees = lerp($TorsoBone.rotation_degrees,goal,1.0-exp(-5*dt))
	$HeadBone.rotation_degrees = lerp($HeadBone.rotation_degrees,goal/4,1.0-exp(-5*dt))

func attack(pos:Vector2):
	var hitCheck = HitChecker.new()
	hitCheck.texture = load("res://sprites/Cursor.png")
	hitCheck.check_type = HitChecker.CheckType.BULLET
	hitCheck.bullet_scale = 2
	hitCheck.bullet_direction = (pos-global_position).normalized()
	hitCheck.global_position = global_position
	hitCheck.bullet_speed = 1
	hitCheck.damage = 50

	create_tween().tween_property(hitCheck,"bullet_speed",10,2)
	owner.call_deferred("add_child",hitCheck)
