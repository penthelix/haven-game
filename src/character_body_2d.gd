extends CharacterBody2D

const BASE_SPEED := 300.0

var speed_multiplier := 1.0
var logo_texture: Texture2D = null

@onready var sprite: Sprite2D = $DvdLogo
@onready var col_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if logo_texture and sprite:
		sprite.texture = logo_texture
		if "hackclub" in logo_texture.resource_path.to_lower():
			var box := RectangleShape2D.new()
			box.size = Vector2(46, 46)
			col_shape.shape = box
			col_shape.position = Vector2.ZERO

	var vp := get_viewport_rect().size
	var margin_x := 45.0 * scale.x
	var margin_y := 45.0 * scale.y

	var player = get_parent().get_node_or_null("Player")
	var chosen_pos := Vector2.ZERO
	for attempt in 10:
		chosen_pos = Vector2(
			randf_range(margin_x, vp.x - margin_x),
			randf_range(margin_y, vp.y - margin_y)
		)
		if player == null or chosen_pos.distance_to(player.global_position) > 200.0:
			break
	position = chosen_pos

	var dirs := [
		Vector2(1,  1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1,  1).normalized(),
		Vector2(-1, -1).normalized(),
	]
	velocity = dirs[randi() % 4] * BASE_SPEED * speed_multiplier


func _physics_process(delta: float) -> void:
	var data := move_and_collide(velocity * delta)
	if data:
		velocity = velocity.bounce(data.get_normal())

		var collider := data.get_collider()
		if collider.has_method("_on_hit_logo"):
			collider._on_hit_logo()
