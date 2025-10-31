extends Node2D

var chopper_target = null

func _ready() -> void:
	var bounds = get_viewport_rect()
	$IndustrialBackground/WorldBG.position = bounds.position

func _on_botfunder_presents_visibility_changed() -> void:
	if not $BotfunderPresents.visible:
		chopper_target = Vector2.ZERO

var bgspeed = null
var bgfspeed = null
var bgnspeed = null
var fgspeed = null

func _physics_process(delta: float) -> void:
	var SPEED = get_viewport().size.x / 3
	var target = get_local_mouse_position() + get_global_transform_with_canvas().get_origin()
	if target.x < 150:
		target.x = 150
	elif target.x > get_viewport().size.x-150:
		target.x = get_viewport().size.x-150
	if target.y < 0:
		target.y = 0
	elif target.y > get_viewport().size.y - 100:
		target.y = get_viewport().size.y - 100
	target -= get_global_transform_with_canvas().get_origin()
	$IndustrialBackground/WorldBG.material.set_shader_parameter("speed", bgspeed)
	$IndustrialBackground/WorldBGBuildingsFar.material.set_shader_parameter("speed", bgfspeed)
	$IndustrialBackground/WorldBGBuildingsNear.material.set_shader_parameter("speed", bgnspeed)
	$IndustrialBackground/WorldFG.material.set_shader_parameter("speed", fgspeed)
	if chopper_target != null:
		if abs($Chopper.position.x) < 1:
			chopper_target.y = get_viewport().size.y + 100
		target = chopper_target
		bgspeed *= (1-delta)
		bgfspeed *= (1-delta)
		bgnspeed *= (1-delta)
		fgspeed *= (1-delta)
	
	var angle = ($Chopper.position.x - target.x) / get_viewport().size.x * -PI/2
	$Chopper.rotation = angle
	$Chopper.position = $Chopper.global_position.move_toward(target, delta*SPEED)
	
	if $Chopper.position.y > get_viewport().size.y:
		var tex: GradientTexture1D = $Fade.texture
		if not $Fade.visible:
			$Fade.modulate.a = 0.05
			$Fade.visible = true
		elif $Fade.modulate.a < 1:
			$Fade.modulate.a += 0.05
		elif tex.gradient.get_offset(1) < 1.0:
			tex.gradient.set_offset(1, tex.gradient.get_offset(1) + 0.05)
			$BGM.volume_db -= 2
		elif tex.gradient.get_offset(0) < 1.0:
			tex.gradient.set_offset(0, tex.gradient.get_offset(0) + 0.05)
		else:
			var next_scene = preload("res://overworld.tscn")
			get_tree().change_scene_to_packed(next_scene)

func _on_industrial_background_ready() -> void:
	bgspeed = $IndustrialBackground/WorldBG.material.get_shader_parameter("speed")
	bgfspeed = $IndustrialBackground/WorldBGBuildingsFar.material.get_shader_parameter("speed")
	bgnspeed = $IndustrialBackground/WorldBGBuildingsNear.material.get_shader_parameter("speed")
	fgspeed = $IndustrialBackground/WorldFG.material.get_shader_parameter("speed")
