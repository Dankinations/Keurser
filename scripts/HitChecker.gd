@icon("res://sprites/Cursor.png")
class_name HitChecker extends Node2D

signal HitWall()
signal HitEntity(EntityBase)

enum Effect {
	FIRE, ## Burns the enemies, for future synergies
	POISON, ## Makes the enemies take damage over time
	CONFUSED, ## Attacking and pathfinding gets messed up
	BLEEDING ## Makes the enemies take damage over time, without immunities
}

enum MeleeType {
	SWING, ## Half a circle
	AREA, ## Whole circle around the player
	POLYGON, ## Requires a Vector2Array (Convex shape),
	PUNCH ## Little box
}

enum CheckType {MELEE, BULLET}

## Determines which effects to apply and how long!
@export var effects:Dictionary[Effect,float] = {}
## Determines how the hitchecker will act
@export var check_type := CheckType.MELEE
var run_mode
@export var texture:Resource
@export var damage := 20

@export_group("Bullet Properties","bullet_")
@export var bullet_range := 10
@export var bullet_speed := 1
@export var bullet_scale := 1
@export var bullet_direction := Vector2.ZERO
@export var bullet_shape:PackedScene
@export_flags_2d_physics var target_mask := 2
@export_group("Melee Properties", "melee_")
@export var melee_type:MeleeType = MeleeType.SWING

# internal

var _area:Area2D

func _enter_tree() -> void:
	run_mode = check_type
	if check_type == CheckType.BULLET:
		if !bullet_shape: 
			push_warning("No bullet shape scene given, defaulting!") 
			bullet_shape = preload("res://prefabs/bullet_shapes/circle.tscn")
		var animate = AnimatedSprite2D.new()
		var sprites:SpriteFrames
		if texture is SpriteFrames:
			sprites = texture
		elif texture is Texture2D or texture is CompressedTexture2D:
			sprites = SpriteFrames.new()
			sprites.add_frame("default",texture)
		animate.autoplay = "default"
		animate.sprite_frames = sprites
		animate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		scale = Vector2.ONE*bullet_scale
		
		_area = Area2D.new()
		_area.collision_layer = 0
		_area.set_collision_layer_value(2,true)
		_area.set_collision_layer_value(3,true)
		_area.collision_mask = target_mask
		var collisionShape = bullet_shape.instantiate()
		for x in collisionShape.get_children():
			x.reparent(_area)
		_area.body_entered.connect(_hit_env)
		_area.area_entered.connect(_hit)
		call_deferred("add_child",_area)
		call_deferred("add_child",animate)

func _hit_env(what):
	HitWall.emit(what)

func _hit(what):
	var hit = what.get_parent()
	if hit is EntityBase:
		hit.health -= damage
		HitEntity.emit(hit)
		queue_free()

var distTravelled = 0

func _physics_process(_delta: float) -> void:
	if run_mode == CheckType.BULLET:
		distTravelled += bullet_speed
		if distTravelled >= bullet_range*100:
			queue_free()
			return
		global_position = global_position.move_toward(global_position+bullet_direction*bullet_speed,bullet_speed)
