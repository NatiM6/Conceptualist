extends Control

@onready var icon:AnimatedSprite2D = $Icon
@onready var price_label:Label = $Price
@onready var stock_label:Label = $Stock
var stock_left:int
var price:int
var item:ItemManager.Instance

func _ready():
	$Pocket.play("pocket")

func setup(new_item:ItemManager.Instance, new_price:int, stock:int):
	item = new_item
	price = new_price
	stock_left = stock
	icon.play(item.get_anim())
	price_label.text = "$%d" % price
	update()

func _on_clicked(button):
	if price > GameManager.data.money or not stock_left:
		AudioManager.play_sound("block")
		return
	match(button):
		MOUSE_BUTTON_LEFT:
			if not Overlay.hand_slot.can_insert(item):
				AudioManager.play_sound("block")
				return
			if Input.is_key_pressed(KEY_SHIFT):
				@warning_ignore("integer_division")
				var max_buy = floori(GameManager.data.money / price)
				max_buy = min(max_buy, stock_left, Overlay.hand_slot.max_stack - Overlay.hand_slot.amount)
				var bought = max_buy - Overlay.hand_slot.insert(item, max_buy)
				Overlay.update_cursor()
				GameManager.add_money(-price*bought)
				stock_left -= bought
			else:
				GameManager.add_money(-price)
				Overlay.hand_slot.insert(item)
				Overlay.update_cursor()
				stock_left -= 1
		MOUSE_BUTTON_RIGHT:
			if Input.is_key_pressed(KEY_SHIFT):
				@warning_ignore("integer_division")
				var max_buy = floori(GameManager.data.money / price)
				max_buy = min(max_buy, stock_left)
				var bought = max_buy - GameManager.instance.inventory.insert(item, max_buy)
				GameManager.add_money(-price*bought)
				stock_left -= bought
			else:
				GameManager.add_money(-price)
				GameManager.instance.inventory.insert(item)
				stock_left -= 1
	update()
	AudioManager.play_sound("cash")

func update():
	stock_label.text = "%d" % stock_left
