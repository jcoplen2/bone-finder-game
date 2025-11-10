extends Area2D

@onready var ui = get_tree().get_first_node_in_group("ui")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		ui.add_score(1)
		queue_free()
		print("Bone collected!") 
