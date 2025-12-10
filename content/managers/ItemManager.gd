extends Node

enum Type {
	NONE, RECIPE, ORB, BLUEPRINT
}

class Instance:
	var id:String
	var data:Dictionary = {}
	
	func _init(id_:String, data_:Dictionary):
		id = id_
		data = data_
	
	func get_property(key):
		if data.has(key): return data[key]
		return ItemManager.ALL_ITEMS.get(id, {
			"type": Type.NONE,
			"name": "Unknown Item",
			"desc": "Did you break something?"
		}).get(key, null)
	
	# QoL functions
	func get_name():
		return get_property("name")
	func get_desc():
		return get_property("desc")
	func get_type():
		return get_property("type")
	func get_anim():
		match get_type():
			Type.BLUEPRINT: return "%s_%s" % [id, get_property("level")]
		return id
	func get_tooltip():
		return "%s - Lv. %d\n%s" % [get_name(), get_property("level"), get_desc()]

var ALL_ITEMS = {}
var ALL_ELEMENTS = []

func _ready():
	register(Type.BLUEPRINT, "merger", "", {"machine": "merger"})
	
	register(Type.ORB, "Null", "Nothingness and lack of itself.\nSome say its own existence makes it disappear.", {"element":"null","level":0})
	register(Type.ORB, "Fire", "Heat and decay.\nOne of the basic concepts.", {"element":"fire","level":0})
	register(Type.ORB, "Water", "Viscosity and moisture.\nOne of the basic concepts.", {"element":"water","level":0})
	register(Type.ORB, "Air", "Flow and dryness.\nOne of the basic concepts.", {"element":"air","level":0})
	register(Type.ORB, "Earth", "Sturdiness and dirt.\nOne of the basic concepts.", {"element":"earth","level":0})
	
	register(Type.ORB, "Steam", "", {"element":"steam","level":1})
	register(Type.ORB, "Alcohol", "", {"element":"alcohol","level":1})
	register(Type.ORB, "Dust", "", {"element":"dust","level":1})
	
	register(Type.ORB, "Sand", "", {"element":"sand","level":2})

func register(type, item_name, desc, extra_data = {}):
	var id = _make_id(type, item_name, extra_data)
	ALL_ITEMS[id] = {
		"type": type,
		"name": item_name,
		"desc": desc
	}.merged(extra_data)
	match type:
		Type.ORB:
			ALL_ELEMENTS.append(extra_data.get("element", "zero"))

func _make_id(type:int, item_name:String, extra_data:Dictionary):
	match type:
		Type.ORB: return "orb_" + extra_data["element"].replace(' ', '_')
		Type.RECIPE: return "recipe_" + extra_data["recipe"].replace(' ', '_')
		Type.BLUEPRINT: return "blueprint_" + extra_data["machine"].replace(' ', '_')
	return item_name.to_lower().replace(' ', '_')

func create(id:String, data:Dictionary = {}):
	return Instance.new(id, data)

func compare(item1:ItemManager.Instance, item2:ItemManager.Instance):
	if item1 == null or item2 == null: return false
	return item1.id == item2.id and item1.data == item2.data
