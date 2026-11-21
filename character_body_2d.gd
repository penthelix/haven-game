extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _physics_process(delta: float) -> void:
	# Add the gravity. Don't need this.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity = Vector2(1, -1).normalized() * SPEED

	move_and_slide()
