extends "res://content/places/Places.gd"

@onready var basics = $Basics
@onready var specials = $Specials

func _ready():
	TimeManager.day_advanced.connect(_on_day_advanced)
	$Basics/Fire.setup(ItemManager.create("orb_fire"), randi_range(10, 25), randi_range(5, 15))
	$Basics/Water.setup(ItemManager.create("orb_water"), randi_range(10, 25), randi_range(5, 15))
	$Basics/Air.setup(ItemManager.create("orb_air"), randi_range(10, 25), randi_range(5, 15))
	$Basics/Earth.setup(ItemManager.create("orb_earth"), randi_range(10, 25), randi_range(5, 15))

func _on_back_clicked(_button):
	request_scene_change.emit(TOWN)

func _on_fox_clicked(_button):
	Overlay.display_dialogue("test")

func _on_day_advanced(_day):
	pass
