extends Node2D

@onready var player: CharacterBody2D = $Player

@onready var initial_logo: CharacterBody2D = $Logo

var logo_scene: PackedScene = preload("res://character_body_2d.tscn")

const DVD_TEXTURE = preload("res://assets/images/logos/dvd_logo.png")
const HACKCLUB_TEXTURE = preload("res://assets/images/logos/hackclub_logo.png")

const BASE_LOGO_SPEED    := 300.0   # pixels/sec for the first logo
const SPAWN_INTERVAL     := 15.0    # seconds between each new logo
const MAX_LOGOS          := 6       # max so its nothing crazy

const DVD_SCALE_MIN      := 1.4
const DVD_SCALE_MAX      := 2.2

const HACKCLUB_SCALE_MIN := 0.75
const HACKCLUB_SCALE_MAX := 1.15

var time_alive   := 0.0
var score        := 0
var logo_count   := 1               # the initial logo counts as 1
var spawn_timer  := 0.0
var game_over    := false


func _ready() -> void:
	initial_logo.speed_multiplier = 1.0


func _process(delta: float) -> void:
	if game_over:
		return

	time_alive  += delta
	spawn_timer += delta

	score = int(pow(time_alive, 1.4) * 10)

	if spawn_timer >= SPAWN_INTERVAL and logo_count < MAX_LOGOS:
		spawn_timer = 0.0
		_spawn_logo()


func _spawn_logo() -> void:
	var logo: CharacterBody2D = logo_scene.instantiate()

	var is_hackclub := randf() < 0.5
	var tex: Texture2D = HACKCLUB_TEXTURE if is_hackclub else DVD_TEXTURE
	logo.logo_texture = tex

	var s: float
	if is_hackclub:
		s = randf_range(HACKCLUB_SCALE_MIN, HACKCLUB_SCALE_MAX)
		var size_factor: float = (s - HACKCLUB_SCALE_MIN) / (HACKCLUB_SCALE_MAX - HACKCLUB_SCALE_MIN)
		var speed_from_size: float = lerp(1.3, 0.9, size_factor)
		logo.speed_multiplier = speed_from_size * randf_range(0.9, 1.15)
	else:
		s = randf_range(DVD_SCALE_MIN, DVD_SCALE_MAX)
		var size_factor: float = (s - DVD_SCALE_MIN) / (DVD_SCALE_MAX - DVD_SCALE_MIN)
		var speed_from_size: float = lerp(1.3, 0.85, size_factor)
		logo.speed_multiplier = speed_from_size * randf_range(0.9, 1.15)

	logo.scale = Vector2(s, s)

	add_child(logo)
	logo_count += 1

func notify_game_over() -> void:
	game_over = true

func get_score() -> int:
	return score
