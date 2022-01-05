extends Node2D

export (Array, NodePath) var asses = []
var assesInstances = []
var liftedAsses = []

var previousLevel = 1
var level  = 1
var subLevel = 1
var isFirstLevel = true
var transitionValue

export (int, 1, 6) var amountToSpawn = 5
export (Array, int) var pointsPerLevel = []

export (int) var upTime = 2
export (int) var downTime = 2

export (int) var pointStep = 100
export (int) var gameTime = 10
export (int) var timeStep = 3

var points = 0

func _ready():
	update_labels()
	for ass in asses:
		assesInstances.append(get_node(ass))

func ass_smacked(ass):
	if !$AssLiftTimer.is_stopped():
		points += pointStep
		level_transitions()
		gameTime += timeStep
		update_labels()
		ass.get_node("SmackAnimationPlayer").play("smacked")
		ass.get_node("SweatAnimationPlayer").play("sweat")
		liftedAsses.erase(ass)
		amount_to_spawn_by_level()

func smack_finished(ass):
	ass.get_node("AnimationPlayer").play("RESET")
	ass.get_node("AnimationPlayer").play("ass_down")


func _on_AssLiftTimer_timeout():
	var i = 0
	while i < amountToSpawn:
		randomize()
		var random_value = int(rand_range(0, assesInstances.size()))
		while liftedAsses.has(assesInstances[random_value]):
			random_value = int(rand_range(0, assesInstances.size()))
		assesInstances[random_value].get_up()
		liftedAsses.append(assesInstances[random_value])
		i += 1
		
	$AssDownTimer.start()

func shake_desk():
	$AnimationPlayer.play("shake_desk")

func _on_AssDownTimer_timeout():
	for ass in liftedAsses:
		ass.get_node("AnimationPlayer").play("ass_down")
	
	liftedAsses.clear()
	
	amount_to_spawn_by_level()


func _on_GameTimer_timeout():
	if gameTime > 0:
		gameTime -= 1
		update_labels()
	else:
		print("GAME OVER")
		$AssLiftTimer.stop()
		$GameTimer.stop()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func level_transitions():
	if isFirstLevel:
		transitionValue = pointsPerLevel[0]/5
		time_up_per_sublevel()
		isFirstLevel = false
	if points >= transitionValue and points < transitionValue*2:
		if subLevel != 2:
			subLevel = 2
			time_up_per_sublevel()
	elif points >= transitionValue*2 and points < transitionValue*3:
		if subLevel != 3:
			subLevel = 3
			time_up_per_sublevel()
	elif points >= transitionValue*3 and points < transitionValue*4:
		if subLevel != 4:
			subLevel = 4
			time_up_per_sublevel()
	elif points >= transitionValue*4 and points < transitionValue*5:
		if subLevel != 5:
			subLevel = 5
			time_up_per_sublevel()
	elif points >= transitionValue*5 and level < 5:
		if subLevel != 1:
			subLevel = 1
			time_up_per_sublevel()
		level += 1
		pointsPerLevel.remove(0)
		if !pointsPerLevel.empty():
			transitionValue = pointsPerLevel[0]/5


func amount_to_spawn_by_level():
	randomize()
	match level:
		1:
			amountToSpawn = int(rand_range(1, 6))
		2:
			amountToSpawn = int(rand_range(1, 5))
		3:
			amountToSpawn = int(rand_range(1, 4))
		4:
			amountToSpawn = int(rand_range(1, 3))
		5:
			amountToSpawn = int(rand_range(1, 2))

func time_up_per_sublevel():
	downTime = 5.0 / level
#	match subLevel:
#		1:
#			downTime = 3.0
#		2:
#			downTime = 2.5
#		3:
#			downTime = 2.0
#		4:
#			downTime = 1.5
#		5:
#			downTime = 1.0
	
	$AssDownTimer.wait_time = downTime

func update_labels():
	$GUI/LevelLabel.bbcode_text = "[wave amp=50 freq=5]" + str(level) + " - " + str(subLevel) + "[/wave]"
	$GUI/TimerLabel.bbcode_text = "[wave amp=50 freq=5]" + str(gameTime) + "[/wave]"
	$GUI/RichTextLabel.bbcode_text = "[wave amp=50 freq=5]" + str(points) + "[/wave]"
