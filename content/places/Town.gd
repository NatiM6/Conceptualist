extends Places

func _ready():
	TimeManager.phase_advanced.connect(_on_phase_advanced)
	_update_clickables(TimeManager.get_phase())

func _on_phase_advanced(phase):
	_update_clickables(phase)

func _update_clickables(phase):
	return
	$Figure.visible = phase in [TimeManager.SLEEP]
	$Smithy.visible = phase in [TimeManager.MORNING, TimeManager.NOON, TimeManager.EVENING]
	$Museum.visible = phase in [TimeManager.EVENING, TimeManager.NIGHT]

func _on_museum_clicked(_button):
	request_scene_change.emit(MUSEUM)

func _on_smithy_clicked(_button):
	Overlay.display_dialogue("test")
	#request_scene_change.emit(SMITHY)

func _on_postbox_clicked(_button):
	request_scene_change.emit(POSTBOX)

func _on_figure_clicked(_button):
	request_scene_change.emit(ORBSHOP)

func _on_workshop_clicked(_button):
	request_scene_change.emit(WORKSHOP)
