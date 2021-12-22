extends Node2D

export (Array, NodePath) var asses = []
var assesInstances = []
var liftedAsses = []

var level  = 0
var subLevel = 0

export (int, 1, 6) var amount_to_spawn = 2

export (int) var upTime = 2
export (int) var downTime = 2

export (int) var pointStep = 100
export (int) var gameTime = 60

var points = 0

func _ready():
	$GameTimer.wait_time = gameTime
	$GUI/RichTextLabel.bbcode_text = "[wave amp=50 freq=5]" + str(points) + "[/wave]"
	for ass in asses:
		assesInstances.append(get_node(ass))


func ass_smacked(ass):
	points += pointStep
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
