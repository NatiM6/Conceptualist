extends Movable
class_name Inventory

class Sides:
	const ORBS = "orb"
	const BLUEPRINTS = "bp"

var target_side:String = Sides.ORBS
var current_side:String = target_side

@onready var orb_slots:Array = $Slots/Orbs.get_children()
@onready var bp_slots:Array = $Slots/Blueprints.get_children()

signal request_valid_slot(source)

func _ready():
	super._ready()
	
	# Code below is deletable, it just populates for debug
	for child in orb_slots:
		if not randi_range(0, 1):
			child.set_item(ItemManager.create("orb_%s" % ItemManager.ALL_ELEMENTS.pick_random()), randi_range(1, 10))
	for child in bp_slots:
		if not randi_range(0, 1):
			child.set_item(ItemManager.create("blueprint_%s" % ["merger"].pick_random(), {"level": 0}), randi_range(1, 10))

func _process(_delta):
	super._process(_delta)
	if current_side != target_side and is_closed():
		for node in get_tree().get_nodes_in_group(current_side):
			node.visible = false
		for node in get_tree().get_nodes_in_group(target_side):
			node.visible = true
		current_side = target_side
		open(current_side)

func open(side):
	if side == current_side:
		if not is_opening():
			AudioManager.play_sound("inventory/open")
		open_show()
	else:
		target_side = side
		if not is_closing():
			AudioManager.play_sound("inventory/close")
		close_hide()

func _on_slot_clicked(slot, button):
	match button:
		MOUSE_BUTTON_LEFT: slot.pick_up()
		MOUSE_BUTTON_RIGHT: request_valid_slot.emit(slot)

func get_empty_slot(type):
	var slots:Array
	match type:
		ItemManager.Type.ORB: slots = orb_slots
		ItemManager.Type.BLUEPRINT: slots = bp_slots
	for slot:Slot in slots:
		if slot.is_empty():
			return slot
	return null

## Inserts an item and returns the amount that did not fit
func insert(item:ItemManager.Instance, amount:int = 1) -> int:
	var slots:Array
	var empty_slots:Array
	match item.get_type():
		ItemManager.Type.ORB: slots = orb_slots
		ItemManager.Type.BLUEPRINT: slots = bp_slots
	for slot:Slot in slots:
		if not amount: break
		if slot.is_empty():
			empty_slots.append(slot)
		else:
			amount = slot.insert(item, amount)
	for slot:Slot in empty_slots:
		if not amount: break
		amount = slot.insert(item, amount)
	return amount
