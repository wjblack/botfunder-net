extends Node2D

func _ready() -> void:
	$Fade.visible = true
	var bounds = $Bottom.get_rect()
	$Broomba/Camera2D.limit_top = bounds.position.y
	$Broomba/Camera2D.limit_left = bounds.position.x
	$Broomba/Camera2D.limit_bottom = bounds.end.y
	$Broomba/Camera2D.limit_right = bounds.end.x
	
func _physics_process(delta: float) -> void:
	if $Fade.visible:
		var tex: GradientTexture1D = $Fade.texture
		if tex.gradient.get_offset(0) > 0.05:
			tex.gradient.set_offset(0, tex.gradient.get_offset(0) * 0.95)
		else:
			$Fade.modulate.a -= 0.05
			if $Fade.modulate.a < 0.05:
				$Fade.visible = false
				$BGM.play(0.0)
	elif $Chopper.visible and $Chopper.position.y > $Broomba.position.y:
		$Chopper.position.x -= 10
		$Chopper.position.y -= 10
	elif $Chopper.rotation > 0:
		$Chopper.rotation -= 0.02
	elif $Chopper.position.y > -300:
		$Broomba.visible = true
		$Chopper.position.y -= 10
	else:
		$Chopper.visible = false


func _on_bgm_finished() -> void:
	print("Restart BGM")
	$BGM.play(0.0)
