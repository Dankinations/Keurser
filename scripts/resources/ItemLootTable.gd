extends Resource
class_name ItemLootTable

@export var pool: Array[ItemData] = []

func pick_item() -> ItemData:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var weights = PackedFloat32Array()
	for item in pool:
		weights.append(item.base_weight)

	var index = rng.rand_weighted(weights)
	return pool[index]
