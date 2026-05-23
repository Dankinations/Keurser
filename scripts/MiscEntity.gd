class_name MiscEntity extends EntityBase

@export var friction: float = 2
@export var pushable:bool = false

func _ready():
	HealthChanged.connect(func(_old,new):
		if new <= 0:
			die()
	)

func _physics_process(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO,friction)
	move_and_slide()

func die():
	queue_free()
