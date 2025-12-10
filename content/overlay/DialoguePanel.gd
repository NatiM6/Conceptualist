extends Movable

@onready var text:RichTextLabel = $Background/MarginContainer/Text
@onready var charA:Portrait = $CharA
@onready var charB:Portrait = $CharB

var dialogue:Array
var timer:float = 0.
var last_charA:bool = false

signal dialogue_finished

func _ready():
	super()
	snap_close()

func _process(delta):
	super(delta)
	if not is_open(): return
	timer += delta
	text.visible_characters = floor(timer / ConfigManager.TEXT_SPEED)

func display(dialogue_id:StringName):
	dialogue = DialogueManager.get_dialogue(dialogue_id).duplicate()
	display_next()
	open_show()

func display_next():
	var line = dialogue.pop_front()
	if line:
		timer = 0.
		text.visible_characters = 0
		text.text = tr(line.text).format(GameManager.get_context()).format({"id": line.text})
		# TODO: I can feel that this if could have been done better
		var use_charA = false
		if not charB.visible or charB.is_char(line.character):
			use_charA = false
		elif charA.is_char(line.character):
			use_charA = true
		else:
			use_charA = not last_charA
		(charA if use_charA else charB).display(line.character, line.emotion)
		(charB if use_charA else charA).deactivate()
		last_charA = use_charA
	else:
		charA.visible = false
		charB.visible = false
		close_hide()
		dialogue_finished.emit()

func skip_text():
	if not is_open(): return
	var text_len = text.text.length()
	if text.visible_characters >= text_len:
		display_next()
	else:
		timer = text_len * ConfigManager.TEXT_SPEED

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if not event.pressed: return
	skip_text()
