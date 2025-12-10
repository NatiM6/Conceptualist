extends Node2D

enum scene {
	OPTIONS
}
@export var target_scene:scene
var selected = false
var target_y_anim:float = -80
var movable:Node2D

signal clicked(tab, scene)

func _ready():
	movable = $Movable
	movable.position.x = -80
	$Movable/Icon.frame = scene

func _process(_delta):
	movable.position.x = lerp(movable.position.x, target_y_anim, 0.2)

func _clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		select()
		clicked.emit(self, scene)

func _on_hover():
	if not selected:
		target_y_anim = -20
		# Play a clack

func _on_unhover():
	if not selected:
		target_y_anim = -80
		# Play a clack

func hide_tab():
	selected = false
	target_y_anim = -80

func select():
	target_y_anim = 0
	selected = true
