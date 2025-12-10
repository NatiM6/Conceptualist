extends Control
class_name Slot

@onready var icon:AnimatedSprite2D = $Icon
@onready var label:Label = $Label
@onready var outline:Sprite2D = $Outline

@export var slot_type:ItemManager.Type = ItemManager.Type.NONE
@export var amount:int = 0
@export var max_stack:int = 10

var item:ItemManager.Instance

signal slot_updated

class SOUNDS:
	const PLACE = "place"
	const TAKE = "take"
	const SWAP = "swap"

func _ready():
	OutlineManager.set_static(outline, slot_type)
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	update()

func update(extra = null):
	if amount < 1:
		icon.visible = false
		tooltip_text = ""
	else:
		icon.play(item.get_anim())
		icon.visible = true
		tooltip_text = item.get_tooltip()
	if amount > 1:
		label.visible = true
		label.text = str(amount)
	else: label.visible = amount > 1
	slot_updated.emit()
	if extra: extra.update()

func is_empty():
	return amount < 1

func is_full():
	return amount >= max_stack

func can_insert(new_item:ItemManager.Instance):
	if is_full(): return false
	if is_empty():
		return slot_type in [new_item.get_type(), ItemManager.Type.NONE]
	if ItemManager.compare(item, new_item): return true
	return false

func can_insert_from(slot):
	if slot.is_empty(): return false
	return can_insert(slot.item)

func can_swap_with(slot) -> bool:
	if slot.is_empty(): return false
	var slot_item_type = slot.item.get_type()
	if slot_type not in [slot_item_type, ItemManager.Type.NONE]: return false
	if slot_item_type not in [slot_type, ItemManager.Type.NONE]: return false
	if slot.amount > max_stack or amount > slot.max_stack: return false
	return true

func consume(n:int = 1):
	amount = max(0, amount - n)
	update()

## Sets items directly. Can delete items.
func set_item(new_item:ItemManager.Instance, n:int = 1):
	if slot_type != ItemManager.Type.NONE and new_item.get_type() != slot_type: return
	item = new_item
	amount = min(n, max_stack)
	update()

## Inserts an item and returns the amount that did not fit
func insert(new_item:ItemManager.Instance, n:int = 1) -> int:
	if not can_insert(new_item): return n
	item = new_item
	var space_left = max_stack - amount
	amount = min(max_stack, amount + n)
	n = max(n - space_left, 0)
	update()
	return n

func insert_from(slot):
	item = slot.item
	var items_moved = min(slot.amount, max_stack - amount)
	amount += items_moved
	slot.amount -= items_moved
	update(slot)

func swap_with(slot):
	var tmp = [item, amount]
	item = slot.item
	amount = slot.amount
	slot.item = tmp[0]
	slot.amount = tmp[1]
	update(slot)

func take_half_from(slot):
	item = slot.item
	var items_moved = min(ceil(slot.amount / 2.), max_stack - amount)
	amount += items_moved
	slot.amount -= items_moved
	update(slot)

func drop_one_from(slot):
	if not ItemManager.compare(item, slot.item):
		item = slot.item
	amount += 1
	slot.amount -= 1
	update(slot)

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if not event.pressed: return
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			if can_insert_from(Overlay.hand_slot):
				insert_from(Overlay.hand_slot)
				_play_sound(SOUNDS.PLACE)
			elif Overlay.hand_slot.can_insert_from(self):
				Overlay.hand_slot.insert_from(self)
				_play_sound(SOUNDS.TAKE)
			elif can_swap_with(Overlay.hand_slot):
				swap_with(Overlay.hand_slot)
				_play_sound(SOUNDS.SWAP)
			elif not Overlay.hand_slot.is_empty() or not is_empty():
				AudioManager.play_sound("block")
			Overlay.update_cursor()
		MOUSE_BUTTON_RIGHT:
			if can_insert_from(Overlay.hand_slot):
				drop_one_from(Overlay.hand_slot)
				_play_sound(SOUNDS.PLACE)
			elif Overlay.hand_slot.is_empty() and Overlay.hand_slot.can_insert_from(self):
				Overlay.hand_slot.take_half_from(self)
				_play_sound(SOUNDS.TAKE)
			else:
				AudioManager.play_sound("block")
			Overlay.update_cursor()

func _play_sound(sound:String):
	match item.get_type():
		ItemManager.Type.ORB:
			AudioManager.play_sound("orb/%s" % sound)
		ItemManager.Type.BLUEPRINT:
			AudioManager.play_sound("blueprint/%s" % sound)

func _on_hover():
	if not Overlay.hand_slot.is_empty() and Overlay.hand_slot.item.get_type() == slot_type or not is_empty():
		outline.visible = true

func _on_unhover():
	outline.visible = false

func _make_custom_tooltip(for_text):
	var tp_label = Label.new()
	tp_label.text = for_text
	tp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return tp_label
