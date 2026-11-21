extends CharacterBody2D

const SPEED = 300.0

@onready var anim := $AnimatedSprite2D

var dead := false


func _physics_process(_delta: float) -> void:
	if dead:
		return

<<<<<<< Updated upstream
func _physics_process(_delta: float) -> void:
=======
>>>>>>> Stashed changes
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
	anim.play("lose")
	# Play once then freeze — CONNECT_ONE_SHOT auto-disconnects after firing
	anim.animation_finished.connect(_freeze_game, CONNECT_ONE_SHOT)


func _freeze_game() -> void:
	get_tree().paused = true
