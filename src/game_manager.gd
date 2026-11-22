extends Node2D

@onready var player = $Player
@onready var initial_logo = $Logo
@onready var bg_music = $BackgroundMusic

@onready var start_screen = $UI/StartScreen
@onready var start_button = $UI/StartScreen/StartButton
@onready var game_over_screen = $UI/GameOverScreen
@onready var score_label = $UI/GameOverScreen/ScoreLabel
@onready var time_label = $UI/GameOverScreen/TimeLabel
@onready var roast_label = $UI/GameOverScreen/RoastLabel
@onready var restart_button = $UI/GameOverScreen/RestartButton

var logo_scene = preload("res://character_body_2d.tscn")
var dvd_texture = preload("res://assets/images/logos/dvd_logo.png")
var hackclub_texture = preload("res://assets/images/logos/hackclub_logo.png")

const BASE_SPAWN_INTERVAL := 6
const MIN_SPAWN_INTERVAL := 4
const MAX_LOGOS := 12

var is_playing = false
var time_alive = 0.0
var score = 0
var spawn_timer = 0.0
var logo_count = 1

var roasts = [
	"Cornered by a screensaver. Tragic.",
	"The logo finally hit the corner... and you.",
	"Physics: 1. You: 0.",
	"You had four whole directions to choose from.",
	"That bounce was completely personal.",
	"It's just a DVD logo. How hard can it be?",
	"Did you try not touching it?"
]

func _ready() -> void:
	start_screen.visible = true
	game_over_screen.visible = false
	start_button.pressed.connect(start_game)
	restart_button.pressed.connect(restart_game)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			if not is_playing and start_screen.visible:
				start_game()
			elif game_over_screen.visible:
				restart_game()

func start_game() -> void:
	is_playing = true
	start_screen.visible = false
	player.is_active = true
	initial_logo.is_active = true
	bg_music.play()

func _process(delta: float) -> void:
	if not is_playing:
		return

	time_alive += delta
	spawn_timer += delta
	score = int(time_alive * 10)

	var current_interval = max(MIN_SPAWN_INTERVAL, BASE_SPAWN_INTERVAL - (logo_count - 1) * 0.15)
	if spawn_timer >= current_interval and logo_count < MAX_LOGOS:
		spawn_timer = 0.0
		spawn_logo()

func spawn_logo() -> void:
	var logo = logo_scene.instantiate()

	var is_hackclub = randf() < 0.5
	var speed_boost = 1.0 + min(time_alive * 0.005, 0.35)

	if is_hackclub:
		logo.logo_texture = hackclub_texture
		var s = randf_range(0.8, 1.15)
		logo.scale = Vector2(s, s)
		logo.speed_multiplier = randf_range(1.05, 1.35) * speed_boost
	else:
		logo.logo_texture = dvd_texture
		var s = randf_range(1.3, 1.9)
		logo.scale = Vector2(s, s)
		logo.speed_multiplier = randf_range(0.95, 1.25) * speed_boost

	logo.is_active = true
	add_child(logo)
	logo_count += 1

func on_player_hit() -> void:
	is_playing = false
	for logo in get_tree().get_nodes_in_group("logos"):
		logo.is_active = false

func show_game_over() -> void:
	score_label.text = "SCORE: " + str(score)
	time_label.text = "TIME: " + str(snappedf(time_alive, 0.1)) + "s"
	roast_label.text = '"' + roasts.pick_random() + '"'
	game_over_screen.visible = true

func restart_game() -> void:
	get_tree().reload_current_scene()
