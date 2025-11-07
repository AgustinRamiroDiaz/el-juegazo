extends StaticBody3D

func _ready():
	# Set the floor's material to white
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	$MeshInstance3D.set_surface_override_material(0, material)
