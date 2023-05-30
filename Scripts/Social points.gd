extends Node

const START_POINTS = 20
const DIFFICULTY_FACTOR = 5
var social_points = 0
signal low_points 

# Called when the node enters the scene tree for the first time.
func _ready():
	social_points = start_points(1)  # Replace with function body.

func reset_points():
	social_points = start_points(1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_points(difficulty):
	social_points = START_POINTS - (difficulty - 1) * DIFFICULTY_FACTOR 	

func update_social_points(action_result):
	if action_result["affects_social_points"]:
		var action_counter = action_result["action_counter"]
		var affect_state = action_result["affect_state"]
		var social_points_effect = action_result["social_points_effect"]
		var social_points_change = action_result["social_points_change"]
		var action_done_times = action_result["action_done_times"]
		
		if (affect_state == "done" and action_counter == action_done_times) or (affect_state == "not_done" and action_counter == -action_done_times):
			if social_points_effect == "increase":
				social_points += social_points_change
			elif social_points_effect == "decrease":
				social_points -= social_points_change
		if social_points <= 5:
			emit_signal("low_points")
