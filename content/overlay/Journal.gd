extends Movable

@onready var left = $Pages/Left
@onready var right = $Pages/Right

func _ready():
	super._ready()
	snap_close()
