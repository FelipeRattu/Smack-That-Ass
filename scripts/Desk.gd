extends Node2D





func _on_DeskCollision_area_entered(area):
	if area.is_in_group("Hand"):
		get_parent().shake_desk()
