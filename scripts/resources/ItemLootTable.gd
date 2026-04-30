extends Resource
class_name ItemLootTable

@export var pool: Dictionary[ItemData,float] = {}

func pick_item() -> ItemData:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var weights = PackedFloat32Array()
	weights = pool.values()

	var index = rng.rand_weighted(weights)
	return pool.keys()[index]
