extends Control

func _ready() -> void:
	var bones := Global.score

	# hide both to start
	$WinLabel.visible = false
	$LoseLabel.visible = false

	if bones < 3:
		$LoseLabel.visible = true
	else:
		$WinLabel.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://intro.tscn")
