extends CharacterBody2D

const SPEED := 120.0
const JUMP_VELOCITY := -350.0
const GRAVITY := 500.0

@export var lives := 3
@export var invuln_time := 1.0  

var invuln := 0.0
var spawn_pos := Vector2.ZERO

@onready var ui = get_tree().get_first_node_in_group("ui")

func _ready() -> void:
	spawn_pos = global_position
	$Camera2D.make_current()


func _physics_process(delta: float) -> void:
	var dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = dir * SPEED

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

	if invuln > 0.0:
		invuln -= delta

	_check_enemy_collision()
	_check_box_hit()

func _check_enemy_collision() -> void:
	if invuln > 0.0:
		return

	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider != null and collider.is_in_group("enemy"):
			var n := collision.get_normal()
			if n.y > -0.5:
				take_hit()
				break


func _check_box_hit() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider != null and collider.has_method("hit_from_below"):
			var n := collision.get_normal()
			if n.y > 0.5:
				collider.hit_from_below()
				velocity.y = 0.0
				break

func take_hit() -> void:
	if invuln > 0.0:
		return

	lives -= 1

	if ui:
		ui.lose_life(1)

	invuln = invuln_time

	if lives > 0:
		velocity = Vector2.ZERO
		global_position = spawn_pos
	else:
		get_tree().reload_current_scene()

func _on_bone_pick_up_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$BonePickup.queue_free()
		print("Bone collected!")
