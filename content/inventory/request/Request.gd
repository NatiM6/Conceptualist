extends Control

@onready var partials = $Partials
@onready var label:Label = $Reward
var PartialRequest = preload("res://content/inventory/request/PartialRequest.tscn")
var reward:int = 0

signal completed

func _ready():
	for _i in range(randi_range(1, 3)):
		var part = PartialRequest.instantiate()
		var element = ItemManager.ALL_ELEMENTS.pick_random()
		var amount = randi_range(1, 8)
		part.setup(element, amount)
		partials.add_child(part)
		reward += amount * 2 ^ ItemManager.create("orb_%s" % element).get_property("level")
	label.text = "$%s" % reward

func update():
	for child in partials.get_children():
		child.update()

func is_fulfilled():
	for partial in partials.get_children():
		if not partial.is_fulfilled(): return false
	return true

func _on_clicked(_button):
	if is_fulfilled():
		AudioManager.play_sound("cash")
		GameManager.add_money(reward)
		for partial in partials.get_children():
			GameManager.store_orb(partial.element, -partial.amount)
		completed.emit()
		queue_free()
	else:
		AudioManager.play_sound("block")
