extends RandomNumberGenerator
# Random.gd
## Autload RNG that allows consistent randomness session

@export_placeholder("Rand...") var game_seed: String : set = set_game_seed



var current_seed: int : get = get_current_seed
## Sets Global Randomness
func _ready() -> void:
	if game_seed:
		seed(game_seed.hash())
	else:
		randomize()
		seed(randi())
	current_seed = get_seed()

func integer() -> int:
	return randi()

func floating_point() -> float:
	return randf()

func roll_dice_summed(amount: int, sides: int) -> int:
	return roll_dice(amount, sides, Types.RESULT.SUM)

func roll_dice_for_highest(amount: int, sides: int) -> int:
	return roll_dice(amount, sides, Types.RESULT.HIGHEST)

func roll_dice_for_lowest(amount: int, sides: int) -> int:
	return roll_dice(amount, sides, Types.RESULT.LOWEST)

func roll_dice_for_average(amount: int, sides: int) -> int:
	return roll_dice(amount, sides, Types.RESULT.AVERAGE)


func roll_dice(amount: int = 1, sides: int = 6, roll_type: Types.RESULT = Types.RESULT.SUM) -> int:
	amount = maxi(1, amount)
	sides = maxi(2, sides)

	var results: Array[int] = []
	var total: int = 0

	for a in amount:
		var die_result: int = randi_range(1, sides)
		results.append(die_result)

	match roll_type:
		Types.RESULT.SUM:
			total = total #ArrayHelper.sum(results)
		Types.RESULT.HIGHEST:
			total = results.max()
		Types.RESULT.LOWEST:
			total = results.min()
		Types.RESULT.AVERAGE:
			@warning_ignore("integer_division")
			total = ArrayHelper.sum(results) / amount
	return total


#region Set/Get
func set_game_seed(new_seed: String) -> void:
	seed(new_seed.hash())
	current_seed = get_seed()

func get_current_seed() -> int:
	return current_seed
#endregion
