extends CharacterBody2D

const BASE_SPEED = 320.0

# TV screen playable inner bounds (inside the TV frame overlay):
const TV_BOUNDS_MIN = Vector2(112.0, 112.0)
const TV_BOUNDS_MAX = Vector2(1036.0, 560.0)

var is_active = false
var speed_multiplier = 1.0
var logo_texture: Texture2D = null

@onready var sprite = $DvdLogo
@onready var col_shape = $CollisionShape2D

func _ready() -> void:
	add_to_group("logos")

	var is_hackclub = false
	if logo_texture:
		sprite.texture = logo_texture
		if "hackclub" in logo_texture.resource_path.to_lower():
			is_hackclub = true
			var box = RectangleShape2D.new()
			box.size = Vector2(46, 46)
			col_shape.shape = box
			col_shape.position = Vector2.ZERO

	# Calculate safe spawn margins inside TV screen borders
	var half_w = (23.0 if is_hackclub else 25.0) * scale.x
	var half_h = (23.0 if is_hackclub else 15.0) * scale.y
	var margin_x = half_w + 35.0
	var margin_y = half_h + 35.0

	var min_x = TV_BOUNDS_MIN.x + margin_x
	var max_x = TV_BOUNDS_MAX.x - margin_x
	var min_y = TV_BOUNDS_MIN.y + margin_y
	var max_y = TV_BOUNDS_MAX.y - margin_y

	# Ensure min doesn't exceed max in edge scale cases
	if min_x > max_x:
		min_x = (TV_BOUNDS_MIN.x + TV_BOUNDS_MAX.x) * 0.5
		max_x = min_x
	if min_y > max_y:
		min_y = (TV_BOUNDS_MIN.y + TV_BOUNDS_MAX.y) * 0.5
		max_y = min_y

	var player = get_parent().get_node_or_null("Player")
	var chosen_pos = Vector2((TV_BOUNDS_MIN.x + TV_BOUNDS_MAX.x) * 0.5, (TV_BOUNDS_MIN.y + TV_BOUNDS_MAX.y) * 0.5)

	for i in 30:
		var candidate = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
		if player != null and candidate.distance_to(player.global_position) < 180.0 and i < 25:
			continue
		var test_transform = Transform2D(0.0, candidate)
		if test_move(test_transform, Vector2.ZERO):
			continue
		chosen_pos = candidate
		break

	position = chosen_pos

	var base_angles = [PI * 0.25, PI * 0.75, PI * 1.25, PI * 1.75]
	var angle = base_angles.pick_random() + randf_range(-0.2, 0.2)
	velocity = Vector2.from_angle(angle) * BASE_SPEED * speed_multiplier

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if velocity.length() < 50.0:
			var base_angles = [PI * 0.25, PI * 0.75, PI * 1.25, PI * 1.75]
			velocity = Vector2.from_angle(base_angles.pick_random()) * BASE_SPEED * speed_multiplier
		position += collision.get_normal() * 1.0

		var collider = collision.get_collider()
		if collider.has_method("_on_hit_logo"):
			collider._on_hit_logo()
