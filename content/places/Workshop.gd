extends Places

@onready var machines = $Machines
var design_mode = false

signal changed_mode(mode)
signal request_valid_slot(source)

func set_design_mode(mode: bool):
	design_mode = mode
	for machine in machines.get_children():
		machine.set_design_mode(mode)
	changed_mode.emit(mode)

func _on_slot_request(source):
	request_valid_slot.emit(source)

func _on_tools_clicked(_button):
	set_design_mode(not design_mode)

func _on_door_clicked(_button):
	set_design_mode(false)
	request_scene_change.emit(TOWN)

func _on_ladder_clicked(_button):
	request_scene_change.emit(BEDROOM)
