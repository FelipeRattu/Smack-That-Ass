extends Node2D

signal combo_tween_ended

func _ready():
	$AnimationPlayer.play("RESET")
	self.connect("combo_tween_ended",get_node("../../.."), "combo_received")

func get_up():
	$AnimationPlayer.play("ass_lift")

func smack_is_no_more():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("ass_down")

func smacky_smacked():
	$SmackAnimationPlayer.play("smacked")
	$SweatAnimationPlayer.play("sweat")
	$CanvasLayer/StreakLabel.text = "X"+str(get_node("../../..").combo)
	$CanvasLayer/StreakLabel.visible = true
	$CanvasLayer/StreakLabel.set_global_position(self.global_position)
	var uiPosition = get_node("../../..").get_node("GUI/ComboLabel")
	$Tween.interpolate_property($CanvasLayer/StreakLabel, "rect_position", self.get_global_transform_with_canvas().origin , uiPosition.rect_position, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Hurtbox_area_entered(area):
	get_node("../../..").ass_smacked(self)

func _on_SmackAnimationPlayer_animation_finished(anim_name):
	if anim_name == "smacked":
		get_node("../../..").smack_finished(self)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ass_lift":
		$Hurtbox/Hurtbox.set_deferred("disabled", false)


func _on_Tween_tween_all_completed():
	$CanvasLayer/StreakLabel.visible = false
	emit_signal("combo_tween_ended")
