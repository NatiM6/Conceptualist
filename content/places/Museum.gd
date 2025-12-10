extends "res://content/places/Places.gd"

func _on_back_clicked(_button):
	request_scene_change.emit(TOWN)
