extends Node

signal zero_spoons
signal overspent
signal out_of_spoons
signal not_engouh_spoons

var actions_taken = 0
var max_spoons = 35
var overspent_spoons = 0
var current_spoons = 0
var max_dif_spoons = 0

func _ready():
	current_spoons = start_spoons(1)
	max_dif_spoons = current_spoons
	
func start_spoons(difficulty):
	current_spoons = max_spoons - (difficulty - 1) * 5
	if overspent_spoons > 0:
		current_spoons -= overspent_spoons
		overspent_spoons = 0 

func perform_action(cost, spoons):
	spoons = current_spoons
	# Case 1: Exceeds max spoons set by difficulty
	if cost < 0 and spoons - cost > max_dif_spoons:
		current_spoons = spoons
		return {"success": false, "overspent": false, "current_Spoons": current_spoons, "reason": "exceeds_max_spoons",}
	# Case 2: Overspending spoons
	elif cost > 0 and spoons < cost and spoons - cost >= -5:
		overspent_spoons += cost - spoons
		spoons = spoons - overspent_spoons
		emit_signal('overspent')
		if spoons == -5:
			emit_signal('out_of_spoons')
		current_spoons = spoons
		return {"success": true, "overspent": true, "current_spoons": current_spoons,"reason": null }
	# Case 3: not engouh spoons
	elif (cost > 0 and spoons == -5) or (cost > 0 and cost - spoons < -5):
		emit_signal('not_engouh_spoons')
		current_spoons = spoons
		return {"success": false, "overspent": false, "current_spoons": current_spoons, "reason": "not_enough_spoons"}
	# Case 4: Perform action normally
	else:
		spoons -= cost
		current_spoons = spoons
		return {"success": true, "overspent": false, "current_spoons": current_spoons, "reason": null}

func actions_counter(cost):
	var result = perform_action(cost, current_spoons)
	if result["success"]:
		actions_taken += 1
	return {"actions_taken": actions_taken, "action_result": result}

func reset_new_day():
	current_spoons = start_spoons(1)
	actions_taken = 0
	
