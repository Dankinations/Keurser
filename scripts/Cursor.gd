extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var diff_x = get_global_mouse_position().x-global_position.x
	rotation_degrees = lerpf(rotation_degrees,diff_x*30,15*delta)
	global_position = get_global_mouse_position()
	var viewport_size = get_viewport().size
	var middle = CameraManager.curr.get_screen_center_position()
	var dist = get_global_mouse_position()-middle
	CameraManager.offset = (get_global_mouse_position()-middle).normalized()*min(dist.length()/viewport_size.x*125,50)
