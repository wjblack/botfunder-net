extends Area2D


func _on_presents_timer_timeout() -> void:
	$BotfinderPresents.visible = true


func _on_sysinfo_timer_timeout() -> void:
	$SwitchSystemInfo.visible = true


func _on_start_timer_timeout() -> void:
	$ClickToStart.visible = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		visible = false
