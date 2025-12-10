extends Node2D
class_name Machine

const MERGER = "merger"
const INFUSER = "infuser"
const EXTRACTOR = "extractor"
const DISTILLER = "distiller"
const INVERTER = "inverter"
const COMPRESSOR = "compressor"
const DECONSTRUCTOR = "deconstructor"

@onready var inputs = $Input.get_children()
@onready var catalysts = $Catalyst.get_children()
@onready var outputs = $Output.get_children()
@onready var sprite:AnimatedSprite2D = $Machine
@onready var progress:ProgressBar = $ProgressBar

@export var _type:String

var _level
var time_left:float = 0
var time_to_process:float = 1
var design_mode = false

func _ready():
	for arr in [inputs, catalysts]:
		for slot in arr:
			slot.slot_updated.connect(_on_input_updated)
	for slot in outputs:
		slot.slot_updated.connect(_on_output_updated)
	sprite.play("%s_idle" % _type)
	TimeManager.time_advanced.connect(_on_time_advanced)

func _process(_delta):
	progress.value = (1 - time_left / time_to_process) if time_left else 0.

func set_design_mode(mode):
	design_mode = mode

func is_empty():
	for slots in [inputs, catalysts, outputs]:
		for slot in slots:
			return slot.is_empty()
	return true

func is_working():
	return time_left > 0

func _check_slot(slot):
	return not slot.is_empty()

func _can_start():
	return not outputs.any(_check_slot) and inputs.all(_check_slot)

func _start():
	$Input.visible = false
	$Catalyst.visible = false
	sprite.play("%s_working" % _type)
	var orb_level = inputs.reduce(func(_max, slot): return max(_max, abs(slot.item.get_property("level"))), 0)
	time_to_process = ceil(10 * (orb_level+1) / (_level+1))
	time_left = time_to_process

func _finish_processing():
	var input_orbs = []
	for slots in [inputs, catalysts]:
		for slot in slots:
			input_orbs.append(slot.item.get_property("element"))
			slot.consume()
	var output_orbs = RecipeManager.get_output(_type, input_orbs)
	for slot in outputs:
		if output_orbs.is_empty(): break
		slot.set_item(ItemManager.create("orb_%s" % output_orbs.pop_front()))
	sprite.play("%s_finished" % _type)
	$Output.visible = true

func _on_input_updated():
	if _can_start():
		_start()

func _on_output_updated():
	if not outputs.any(_check_slot):
		$Input.visible = true
		$Catalyst.visible = true
		$Output.visible = false
		sprite.play("%s_idle" % _type)

static func create(type:String, level:int):
	var instance:Node2D = load("res://content/machines/%sMachine.tscn" % type.capitalize()).instantiate()
	instance._level = level
	return instance

func _on_time_advanced(_time, by):
	if time_left > 0:
		time_left = max(0, time_left - by)
		if time_left == 0: _finish_processing()
