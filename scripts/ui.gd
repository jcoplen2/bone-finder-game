extends CanvasLayer

var lives = 3
var score = 0

@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel

func _ready() -> void:
	score_label.text = "Score: " + str(score)
	lives_label.text = "Lives: " + str(lives)
	Global.score = score   # sync at start

func add_score(amount: int) -> void:
	score += amount
	score_label.text = "Score: " + str(score)
	Global.score = score   # keep global in sync

func lose_life(amount: int) -> void:
	lives -= amount
	lives_label.text = "Lives: " + str(lives)
