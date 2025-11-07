extends CharacterBody3D

@export var move_speed: float = 10.0
@export var move_range: float = 5.0  # How far left/right the player can move
@export var mouse_speed_multiplier: float = 2.0  # Speed multiplier for mouse movement

var mouse_active: bool = false
var target_x: float = 0.0

func _ready():
	# Set the player's material to a random pastel color
	var material = StandardMaterial3D.new()

	# Generate random pastel color (high saturation, high value)
	var hue = randf()  # Random hue (0.0 to 1.0)
	var saturation = randf_range(0.3, 0.5)  # Lower saturation for pastel
	var value = randf_range(0.85, 1.0)  # High value for pastel brightness

	material.albedo_color = Color.from_hsv(hue, saturation, value)
	$MeshInstance3D.set_surface_override_material(0, material)

func _input(event):
	# Handle mouse clicks and touch
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_active = event.pressed
			if event.pressed:
				update_target_from_screen_position(event.position)
	elif event is InputEventScreenTouch:
		mouse_active = event.pressed
		if event.pressed:
			update_target_from_screen_position(event.position)
	elif event is InputEventMouseMotion and mouse_active:
		update_target_from_screen_position(event.position)
	elif event is InputEventScreenDrag:
		update_target_from_screen_position(event.position)

func update_target_from_screen_position(screen_pos: Vector2):
	# Get the camera
	var camera = $Camera3D
	if not camera:
		return

	# Project screen position to world space on the player's Z plane
	var from = camera.project_ray_origin(screen_pos)
	var direction = camera.project_ray_normal(screen_pos)

	# Calculate where the ray intersects the plane at player's Z position
	# Ray equation: point = from + t * direction
	# Plane equation: z = player.position.z
	# Solve for t: from.z + t * direction.z = player.position.z
	if abs(direction.z) > 0.001:  # Avoid division by zero
		var t = (position.z - from.z) / direction.z
		var world_pos = from + direction * t
		target_x = clamp(world_pos.x, -move_range, move_range)

func _physics_process(_delta):
	var input_velocity = 0.0

	# Check for keyboard input first
	var input_dir = Input.get_axis("ui_right", "ui_left")

	if input_dir != 0.0:
		# Keyboard has priority - use keyboard input
		input_velocity = input_dir * move_speed
		mouse_active = false  # Disable mouse control when keyboard is used
	elif mouse_active:
		# Use mouse/touch control
		var distance_to_target = target_x - position.x
		var distance_abs = abs(distance_to_target)

		# Speed based on distance: closer = slower, farther = faster
		# Normalize distance to [0, 1] range based on move_range
		var normalized_distance = clamp(distance_abs / move_range, 0.0, 1.0)
		var speed = normalized_distance * move_speed * mouse_speed_multiplier

		# Move towards target
		if distance_abs > 0.1:  # Dead zone to prevent jitter
			input_velocity = sign(distance_to_target) * speed
		else:
			input_velocity = 0.0

	# Apply velocity
	velocity.x = input_velocity

	# Clamp player position to stay within bounds
	position.x = clamp(position.x, -move_range, move_range)

	move_and_slide()
