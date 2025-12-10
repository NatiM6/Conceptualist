extends AnimatedSprite2D

@onready var polygon = $Area2D/CollisionPolygon2D

signal clicked(button)

func _ready():
	OutlineManager.set_dynamic(self)

func _on_hover():
	OutlineManager.display(self, true)

func _on_unhover():
	OutlineManager.display(self, false)

func set_disabled(disable:bool):
	polygon.disabled = disable

func _on_clicked(_viewport, event, _shape_idx):
	if event is not InputEventMouseButton: return
	if not event.pressed: return
	if event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]:
		clicked.emit(event.button_index)
