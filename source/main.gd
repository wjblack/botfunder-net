extends Node2D


func _on_botfunder_presents_visibility_changed() -> void:
	if not $BotfunderPresents.visible:
		print("Start this thing")
