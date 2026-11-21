extends CharacterBody2D

const SPEED = 300.0

func _ready() -> void:
	# Choose pos
	var x_coord = randi_range(0, get_viewport_rect().size.x)
	var y_coord = randi_range(0, get_viewport_rect().size.y)
	position = Vector2(x_coord, y_coord)

	# Choose dir
	var rotations = floor(randf_range(0, 4))
	var dir = Vector2(1, 1).normalized()
	while rotations > 0:
		dir.rotated(PI/2)
		rotations -=1
	velocity = dir * SPEED


func _physics_process(delta: float) -> void:
	var data = move_and_collide(velocity * delta)
	if data:
		velocity = velocity.bounce(data.get_normal())
		# If we hit the player, trigger their lose state
		var collider = data.get_collider()
		if collider.has_method("_on_hit_logo"):
			collider._on_hit_logo()
