extends StaticBody2D

@export var bone_scene: PackedScene    

var used := false

@onready var ui = get_tree().get_first_node_in_group("ui")
@onready var sprite: Sprite2D = $Sprite2D   

func hit_from_below() -> void:
	if used:
		return
	used = true
	
	print("BOX HIT!")
	# spawn a bone popup
	if bone_scene:
		var bone := bone_scene.instantiate()
		bone.global_position = global_position
		get_tree().current_scene.add_child(bone)

		var tween := bone.create_tween()
		tween.tween_property(bone, "position:y", bone.position.y - 32, 0.25)
		tween.tween_callback(Callable(bone, "queue_free"))

	if ui:
		ui.add_score(1)
