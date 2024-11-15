extends Node2D

## Gets the main scene "Game"
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")
	
## Quits the game
func _on_quit_pressed():
	get_tree().quit()
