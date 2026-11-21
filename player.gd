extends CharacterBody2D

const SPEED = 300.0

@onready var anim := $AnimatedSprite2D


func _physics_process(delta: float) -> void:
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
