extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(delta: float) -> void:
	var last_pos = global_position
	global_position = get_global_mouse_position()
	var viewportSize = get_viewport().size
	var mouseVelocity = (get_global_mouse_position()-last_pos).x
	scale = Vector2.ONE/CameraManager.curr.zoom
	
	rotation_degrees = lerpf(rotation_degrees,mouseVelocity*10,1.0-exp(-10*delta))
	
	var middle = CameraManager.curr.get_screen_center_position()
	var dist = get_global_mouse_position()-middle
	var scaled = clamp(dist.length()/(viewportSize.x/2),-1,1)
	CameraManager.offset = (get_global_mouse_position()-middle).normalized()*scaled*min(dist.length(),80)
