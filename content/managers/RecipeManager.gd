extends Node

var RECIPE_LIST = {}
var RECIPE_BY_ITEM = {}

func _ready():
	add_recipe(Machine.MERGER, ["air", "water"], ["steam"])
	add_recipe(Machine.MERGER, ["fire", "water"], ["alcohol"])
	add_recipe(Machine.MERGER, ["air", "earth"], ["dust"])
	
	add_recipe(Machine.MERGER, ["dust", "earth"], ["sand"])

func get_output(machine:String, input:Array):
	var sorted = input.duplicate()
	sorted.sort()
	return RECIPE_LIST.get(machine, {}).get(JSON.stringify(sorted), ["null"]).duplicate()

func add_recipe(machine_type, input, output):
	if not RECIPE_LIST.has(machine_type): RECIPE_LIST[machine_type] = {}
	
	input.sort()
	var recipe_id = JSON.stringify(input)
	RECIPE_LIST[machine_type][JSON.stringify(input)] = output
	for item in input + output:
		if not RECIPE_BY_ITEM.has(item):
			RECIPE_BY_ITEM[item] = []
		RECIPE_BY_ITEM[item].append({
			"id": recipe_id,
			"machine": machine_type
		})
	
	if machine_type == Machine.MERGER:
		var new_input = output.duplicate()
		new_input.append("null")
		add_recipe(Machine.EXTRACTOR, new_input, input) # Add a reversing recipe
