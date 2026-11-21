extends CharacterBody2D

const SPEED = 300.0

func _ready() -> void:
	# Choose pos
	var width =  get_viewport_rect().size.x
	var height = get_viewport_rect().size.y
	@warning_ignore("narrowing_conversion")
	var x_coord = randi_range(0.1 * width, 0.9 * width)
	@warning_ignore("narrowing_conversion")
	var y_coord = randi_range(0.1 * height, 0.9 * height)
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
