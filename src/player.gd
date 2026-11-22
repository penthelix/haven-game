extends CharacterBody2D

const SPEED = 300.0

@onready var anim := $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

const MY_SOUND = preload("res://assets/sound/loss.mp3")

var dead := false


func _physics_process(_delta: float) -> void:
	if dead:
		return

	var direction := Vector2(
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
	velocity = Vector2.ZERO

	var bg_music := get_node_or_null("../BackgroundMusic")
	if bg_music and bg_music is AudioStreamPlayer2D:
		bg_music.stop()

	if audio_player:
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
		audio_player.global_position = global_position
		audio_player.stream = MY_SOUND
		audio_player.play()

	anim.play("lose")

	var gm := get_parent()
	if gm and gm.has_method("notify_game_over"):
		gm.notify_game_over()

	anim.animation_finished.connect(_freeze_game, CONNECT_ONE_SHOT)


func _freeze_game() -> void:
	get_tree().paused = true
