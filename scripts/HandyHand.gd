extends Node2D

export (NodePath) var backPosition
export (NodePath) var frontPosition

func _ready():
	backPosition = get_node(backPosition)
	frontPosition = get_node(frontPosition)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$ReticleAnimationPlayer.play("reticle")

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		$AnimationPlayer.play("smack")
	self.global_position = get_global_mouse_position()
	
	check_collision_layer()


func check_collision_layer():
	if self.global_position.y < backPosition.global_position.y:
		if !$Hitbox.get_collision_layer_bit(0):
			$Hitbox.set_collision_layer_bit(0, true)
			$Hitbox.set_collision_layer_bit(1, false)
			$Hitbox.set_collision_layer_bit(2, false)
			$Hitbox.set_collision_mask_bit(3, true)
			$Hitbox.set_collision_mask_bit(4, false)
			$Hitbox.set_collision_mask_bit(5, false)
	elif self.global_position.y > frontPosition.global_position.y:
		if !$Hitbox.get_collision_layer_bit(2):
			$Hitbox.set_collision_layer_bit(0, false)
			$Hitbox.set_collision_layer_bit(1, false)
			$Hitbox.set_collision_layer_bit(2, true)
			$Hitbox.set_collision_mask_bit(3, false)
			$Hitbox.set_collision_mask_bit(4, false)
			$Hitbox.set_collision_mask_bit(5, true)
	else:
		if !$Hitbox.get_collision_layer_bit(1):
			$Hitbox.set_collision_layer_bit(0, false)
			$Hitbox.set_collision_layer_bit(1, true)
			$Hitbox.set_collision_layer_bit(2, false)
			$Hitbox.set_collision_mask_bit(3, false)
			$Hitbox.set_collision_mask_bit(4, true)
			$Hitbox.set_collision_mask_bit(5, false)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "smack":
		$AnimationPlayer.play("RESET")
	elif anim_name == "ass_down":
		$AnimationPlayer.play("RESET")
