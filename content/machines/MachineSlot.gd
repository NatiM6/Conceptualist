extends Node2D

@onready var machine_slot:Node2D = $Machine

var design_mode:bool = true

func set_design_mode(mode:bool):
	design_mode = mode
	if not _is_vacant(): get_machine().set_design_mode(mode)

func _is_vacant():
	return machine_slot.get_child_count() == 0

func place_machine(blueprint:ItemManager.Instance):
	if not _is_vacant(): return
	var machine = Machine.create(blueprint.get_property("machine"), blueprint.get_property("level"))
	machine_slot.add_child(machine)

func get_machine():
	return machine_slot.get_child(-1)

func build_blueprint():
	if _is_vacant(): return
	var machine = get_machine()
	return ItemManager.create("blueprint_%s" % machine._type, {"level":machine._level})

func take_machine():
	if _is_vacant(): return
	var blueprint = build_blueprint()
	machine_slot.remove_child(get_machine())
	return blueprint

func _on_clicked(_viewport, event, _shape_idx): # When managing machines
	if not design_mode: return
	if not (event is InputEventMouseButton and event.pressed): return
	if not _is_vacant() and not get_machine().is_empty(): return
	if event.button_index == MOUSE_BUTTON_LEFT: pick_up()

func pick_up():
	if not Overlay.hand_slot.is_empty():
		if Overlay.hand_slot.item.get_type() != ItemManager.Type.BLUEPRINT:
			AudioManager.play_sound("machine/block")
			return
		var held_item = Overlay.hand_slot.item
		if _is_vacant():
			place_machine(held_item)
			Overlay.hand_slot.consume()
			AudioManager.play_sound("machine/place")
		elif Overlay.hand_slot.can_insert(build_blueprint()):
			Overlay.hand_slot.insert(take_machine())
			AudioManager.play_sound("machine/take")
	elif not _is_vacant():
		Overlay.hand_slot.insert(take_machine())
		AudioManager.play_sound("machine/take")
