extends CharacterBody3D

@export var move_speed: float = 10.0
@export var move_range: float = 20.0  # How far left/right the player can move

func _ready():
	# Set the player's material to red
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	$MeshInstance3D.set_surface_override_material(0, material)

func _physics_process(delta):
	# Get input for left/right movement
	var input_dir = Input.get_axis("ui_left", "ui_right")

	# Move the player
	velocity.x = input_dir * move_speed

	# Clamp player position to stay within bounds
	position.x = clamp(position.x, -move_range, move_range)

	move_and_slide()
