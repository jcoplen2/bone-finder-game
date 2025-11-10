extends CharacterBody2D

const SPEED := 40.0
const GRAVITY := 900.0
const BOUNCE := -260.0

@export var roam_distance := 120.0  

var dir := 1
var start_x := 0.0
var flip_cd := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var stomp_area: Area2D = $StompArea

func _ready() -> void:
	start_x = global_position.x
	stomp_area.body_entered.connect(_on_stomp_area_body_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = SPEED * dir
	move_and_slide()

	flip_cd = max(flip_cd - delta, 0.0)

	if flip_cd == 0.0:
		for i in get_slide_collision_count():
			var n := get_slide_collision(i).get_normal()
			if abs(n.x) > 0.5 and (n.x * dir) < 0:
				dir *= -1
				sprite.flip_h = dir > 0
				flip_cd = 0.25
				global_position.x += -n.x * 2.0
				break

	if dir == 1 and global_position.x > start_x + roam_distance:
		dir = -1
		sprite.flip_h = dir > 0
	elif dir == -1 and global_position.x < start_x - roam_distance:
		dir = 1
		sprite.flip_h = dir > 0

func _on_stomp_area_body_entered(body: Node) -> void:
	if body.name == "CharacterBody2D":
		if "velocity" in body:
			body.velocity.y = BOUNCE
		queue_free()
