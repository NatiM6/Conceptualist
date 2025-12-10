extends Node

func set_dynamic(sprite:CanvasItem):
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://textures/ui/outline.gdshader")
	display(sprite, false)

func display(sprite:CanvasItem, visible:bool):
	sprite.material.set_shader_parameter("visible", visible)

func set_static(outline:Sprite2D, type:ItemManager.Type):
	match type:
		ItemManager.Type.ORB: outline.texture = load("res://textures/inventory_items/orb_outline.tres")
