extends "res://content/places/Places.gd"

@onready var requests = $RequestGrid
var Request = preload("res://content/inventory/request/Request.tscn")

func _ready():
	for _i in range(8):
		var req = Request.instantiate()
		req.completed.connect(_on_request_completed)
		requests.add_child(req)

func _on_back_clicked(_button):
	request_scene_change.emit(TOWN)

func _on_postbox_clicked(button):
	if Overlay.hand_slot.is_empty():
		Overlay.display_dialogue("postbox")
		return
	if button == MOUSE_BUTTON_MIDDLE: return
	var slot = Overlay.hand_slot
	if slot.item.get_type() != ItemManager.Type.ORB: return
	var amount = 1 if button == MOUSE_BUTTON_RIGHT else slot.amount
	GameManager.store_orb(slot.item.get_property("element"), amount)
	Overlay.hand_slot.consume(amount)
	Overlay.update_cursor()
	AudioManager.play_sound("postbox_put", 3)
	for request in requests.get_children():
		request.update()

func _on_request_completed():
	for req in requests.get_children():
		req.update()
