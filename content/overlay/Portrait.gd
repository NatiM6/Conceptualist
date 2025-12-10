extends Movable
class_name Portrait

@onready var body:AnimatedSprite2D = $Body
@onready var face:AnimatedSprite2D = $Face

func _ready():
	super()

func display(character, emotion) -> void:
	body.play("%s_body" % character)
	face.play("%s_%s" % [character, emotion])
	activate()

func activate():
	open_show()
	modulate = Color.WHITE
	visible = true

func deactivate():
	close_hide()
	modulate = Color.WEB_GRAY

func is_char(character):
	return character in body.animation
