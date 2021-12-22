extends Node2D

func _ready():
	$AnimationPlayer.play("RESET")

func get_up():
	$AnimationPlayer.play("ass_lift")

func _on_Hurtbox_area_entered(area):
	get_node("../../..").ass_smacked(self)

func _on_SmackAnimationPlayer_animation_finished(anim_name):
	if anim_name == "smacked":
		get_node("../../..").smack_finished(self)
