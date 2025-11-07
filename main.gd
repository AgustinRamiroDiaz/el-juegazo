extends Node3D

@export var obstacle_scene: PackedScene
@export var spawn_distance: float = 100.0  # How far ahead to spawn obstacles
@export var spawn_range: float = 5.0  # Random X position range (matches floor width)

var game_active: bool = true

func _ready():
	add_to_group("game_manager")

	# Load the obstacle scene
	obstacle_scene = load("res://obstacle.tscn")

func _on_spawn_timer_timeout():
	if not game_active:
		return

	# Spawn a new obstacle
	var obstacle = obstacle_scene.instantiate()

	# Set random X position within range
	var random_x = randf_range(-spawn_range, spawn_range)
	obstacle.position = Vector3(random_x, 1, spawn_distance)

	add_child(obstacle)

func game_over():
	if not game_active:
		return

	game_active = false
	print("Game Over! You hit an obstacle!")

	# Stop spawning
	$SpawnTimer.stop()

	# Remove player from scene
	$Player.queue_free()

	# Show game over UI
	$GameOverUI.visible = true

func _on_retry_button_pressed():
	# Reload the current scene to restart the game
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	# Return to main menu
	get_tree().change_scene_to_file("res://menu.tscn")
