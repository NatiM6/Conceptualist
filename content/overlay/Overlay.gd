extends Node2D

@onready var cursor:AnimatedSprite2D = $Cursor
@onready var hand_slot:Slot = $Cursor/Slot
@onready var blocker:Panel = $Blocker
@onready var dlg_panel:Movable = $DialoguePanel
@onready var journal:Movable = $Journal

signal dialogue_finished

class Cursor:
	const POINT = "point"
	const GRAB_ORB = "orb"
	const GRAB_BLUEPRINT = "blueprint"
	const BLOCK = "block"

func _ready():
	dlg_panel.state_changed.connect(update_blocker)
	journal.state_changed.connect(update_blocker)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	update_cursor()
	get_parent().move_child.call_deferred(self, -1)

func _process(_delta):
	cursor.position = get_global_mouse_position()

func set_cursor(cursor_shape:String):
	cursor.play(cursor_shape)

func update_cursor():
	if not hand_slot.is_empty():
		match hand_slot.item.get_type():
			ItemManager.Type.ORB: set_cursor(Cursor.GRAB_ORB)
			ItemManager.Type.BLUEPRINT: set_cursor(Cursor.GRAB_BLUEPRINT)
	else: set_cursor(Cursor.POINT)

func display_dialogue(dialogue_id:StringName):
	dlg_panel.display(dialogue_id)

func _on_dialogue_finished():
	dialogue_finished.emit()

func swap_item(slot:Control):
	if slot.item.get_type() == ItemManager.ItemType.ORB: set_cursor(Cursor.GRAB_ORB)
	else: set_cursor(Cursor.GRAB_BLUEPRINT)

func update_blocker():
	blocker.visible = dlg_panel.is_opening() or journal.is_opening()
	get_tree().paused = blocker.visible

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	if not event.pressed: return
	match event.keycode:
		KEY_SPACE:
			if dlg_panel.is_opening():
				dlg_panel.skip_text()
			else:
				journal.flip_state()
