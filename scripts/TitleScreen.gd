extends Node2D

#adding to the github channel ^^

func _ready():
	$AnimationPlayer.play("intro")


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/Level.tscn")
