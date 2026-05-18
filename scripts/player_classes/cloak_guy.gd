extends PlayerBase

func movementTick(direction:Vector2,_echo:bool,dt:float):
	super(direction,_echo,dt)
	var goal = rawMove.x/1*15 
	$TorsoBone.rotation_degrees = lerp($TorsoBone.rotation_degrees,goal,1.0-exp(-5*dt))
	$HeadBone.rotation_degrees = lerp($HeadBone.rotation_degrees,goal/4,1.0-exp(-5*dt))
