extends Control

@onready var icon = $Icon
@onready var label:Label = $Label
var element:String
var amount:int

func _ready():
	update()
	icon.play("orb_%s" % element)
	tooltip_text = ItemManager.create("orb_%s" % element).get_tooltip()

func setup(new_element:String, new_amount:int):
	element = new_element
	amount = new_amount

func update():
	var target = GameManager.count_orb(element)
	label.text = "%d/%d" % [target, amount]
	if target >= amount:
		label.set("theme_override_colors/font_color",Color.LIME_GREEN)
	else:
		label.set("theme_override_colors/font_color",Color.BLACK)

func is_fulfilled():
	return GameManager.count_orb(element) >= amount
