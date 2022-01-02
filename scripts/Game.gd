extends Node2D

export (Array, NodePath) var asses = []
var assesInstances = []
var liftedAsses = []

var level  = 1
var subLevel = 1

export (int, 1, 6) var amount_to_spawn = 5

export (int) var upTime = 2
export (int) var downTime = 2

export (int) var pointStep = 100
export (int) var gameTime = 10
export (int) var timeStep = 3

var points = 0

func _ready():
	$GUI/TimerLabel.bbcode_text = "[wave amp=50 freq=5]" + str(gameTime) + "[/wave]"
	$GUI/RichTextLabel.bbcode_text = "[wave amp=50 freq=5]" + str(points) + "[/wave]"
	for ass in asses:
		assesInstances.append(get_node(ass))

func ass_smacked(ass):
	if !$AssLiftTimer.is_stopped():
		points += pointStep
		gameTime += timeStep
		$GUI/TimerLabel.bbcode_text = "[wave amp=50 freq=5]" + str(gameTime) + "[/wave]"
		$GUI/RichTextLabel.bbcode_text = "[wave amp=50 freq=5]" + str(points) + "[/wave]"
		ass.get_node("SmackAnimationPlayer").play("smacked")
		ass.get_node("SweatAnimationPlayer").play("sweat")
		liftedAsses.erase(ass)

func smack_finished(ass):
	ass.get_node("AnimationPlayer").play("RESET")
	ass.get_node("AnimationPlayer").play("ass_down")


func _on_AssLiftTimer_timeout():
	var i = 0
	while i < amount_to_spawn:
		randomize()
		var random_value = int(rand_range(0, assesInstances.size()))
		while liftedAsses.has(assesInstances[random_value]):
			random_value = int(rand_range(0, assesInstances.size()))
		assesInstances[random_value].get_node("AnimationPlayer").play("ass_lift")
		liftedAsses.append(assesInstances[random_value])
		i += 1
	$AssDownTimer.start()

func shake_desk():
	$AnimationPlayer.play("shake_desk")

func _on_AssDownTimer_timeout():
	for ass in liftedAsses:
		ass.get_node("AnimationPlayer").play("ass_down")
	
	liftedAsses.clear()


func _on_GameTimer_timeout():
	if gameTime > 0:
		gameTime -= 1
		$GUI/TimerLabel.bbcode_text = "[wave amp=50 freq=5]" + str(gameTime) + "[/wave]"
	else:
		print("GAME OVER")
		$AssLiftTimer.stop()
		$GameTimer.stop()

func _process(delta):
	points_transitions()
	look_for_level()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func points_transitions():
	match points:
		500:
			level = 2
		1000:
			level = 3
		1500:
			level = 4
		2000:
			level = 5

func look_for_level():
	match level:
		1:
			amount_to_spawn = 6
		2:
			amount_to_spawn = 5
		3:
			amount_to_spawn = 4
		4:
			amount_to_spawn = 3
		5:
			amount_to_spawn = 2
