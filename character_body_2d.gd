extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	velocity = Vector2(1, -1).normalized() * SPEED


func _physics_process(delta: float) -> void:
	var data = move_and_collide(velocity*delta)
	if data:
		velocity = velocity.bounce(data.get_normal())
