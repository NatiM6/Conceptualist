extends Node2D
class_name Game

@onready var inventory: Inventory = $Inventory
@onready var scene_viewer: Node2D = $SceneViewer
@onready var screen_anim: AnimationPlayer = $TransScreen/AnimationPlayer
@onready var clock_tape: Sprite2D = $DeskOverlay/Clock/Tape
@onready var money_label: Label = $DeskOverlay/Money
@onready var know_label: Label = $DeskOverlay/Knowledge

var current_scene = Places.TOWN

func _ready():
	GameManager.set_game_instance(self)
	_on_scene_change_request(Places.WORKSHOP)
	TimeManager.phase_advanced.connect(_on_phase_advanced)
	update()

func _process(delta):
	TimeManager.advance_time(delta)
	clock_tape.region_rect.position.x = TimeManager.get_phase_ratio() * 250. - 125.

func _on_workshop_changed_mode(mode):
	inventory.open(Inventory.Sides.BLUEPRINTS if mode else Inventory.Sides.ORBS)

func _on_inv_slot_request(source):
	var slot = inventory.get_empty_slot(source._item)
	if slot: source.place_into(slot)
	else: AudioManager.play_sound("block")

func _on_scene_slot_request(source):
	for scene in scene_viewer.get_children():
		if scene.scene_code == current_scene:
			scene.request_scene_slot(source)
			break

func _on_scene_change_request(target):
	if current_scene == target: return
	AudioManager.change_music(target)
	screen_anim.play("fadein")
	if target in [Places.SMITHY]: inventory.open(Inventory.Sides.BLUEPRINTS)
	else: inventory.open(Inventory.Sides.ORBS)
	await screen_anim.animation_finished
	current_scene = target
	for scene in scene_viewer.get_children():
		scene.visible = scene.scene_code == target
	screen_anim.play_backwards("fadein")

func _on_phase_advanced(_phase):
	screen_anim.play_backwards("fadein")

func update():
	money_label.text = str(GameManager.data.money)
	know_label.text = str(GameManager.data.knowledge)
