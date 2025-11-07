extends CharacterBody3D

@export var move_speed: float = 10.0
@export var move_range: float = 5.0  # How far left/right the player can move

func _ready():
	# Set the player's material to a random pastel color
	var material = StandardMaterial3D.new()

	# Generate random pastel color (high saturation, high value)
	var hue = randf()  # Random hue (0.0 to 1.0)
	var saturation = randf_range(0.3, 0.5)  # Lower saturation for pastel
	var value = randf_range(0.85, 1.0)  # High value for pastel brightness

	material.albedo_color = Color.from_hsv(hue, saturation, value)
	$MeshInstance3D.set_surface_override_material(0, material)

func _physics_process(delta):
	# Get input for left/right movement
	var input_dir = Input.get_axis( "ui_right", "ui_left",)

	# Move the player
	velocity.x = input_dir * move_speed

	# Clamp player position to stay within bounds
	position.x = clamp(position.x, -move_range, move_range)

	move_and_slide()
