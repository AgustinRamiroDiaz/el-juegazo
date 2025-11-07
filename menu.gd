extends Control

func _ready():
	pass

func _on_play_button_pressed():
	# Load and switch to the game scene
	get_tree().change_scene_to_file("res://main.tscn")
