extends Area3D

@export var speed: float = 15.0

func _ready():
	# Set the obstacle's material to gray
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.GRAY
	$MeshInstance3D.set_surface_override_material(0, material)

func _process(delta):
	# Move the obstacle towards the player (negative Z direction)
	position.z -= speed * delta

	# Remove obstacle if it goes too far past the player
	if position.z < -50:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		# Signal collision to game manager
		get_tree().call_group("game_manager", "game_over")
