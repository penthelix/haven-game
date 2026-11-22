extends CharacterBody2D

const SPEED = 350.0

@onready var anim = $AnimatedSprite2D
@onready var audio_player = $"../AudioStreamPlayer2D"
@onready var bg_music = $"../BackgroundMusic"

const LOSS_SOUND = preload("res://assets/sound/loss.mp3")

var is_active = false
var dead = false

func _physics_process(_delta: float) -> void:
	if dead or not is_active:
		return

	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		anim.play("run")
		anim.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		anim.play("idle")

	move_and_slide()

func _on_hit_logo() -> void:
	if dead:
		return
	dead = true
	is_active = false
	velocity = Vector2.ZERO

	bg_music.stop()

	audio_player.stream = LOSS_SOUND
	audio_player.play()
	audio_player.finished.connect(_on_loss_sound_finished)

	anim.play("lose")

	get_parent().on_player_hit()

func _on_loss_sound_finished() -> void:
	get_parent().show_game_over()
