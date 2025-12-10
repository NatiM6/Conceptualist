extends Node2D
class_name Movable

enum Direction {
	DOWN, UP, LEFT, RIGHT
}

const OPEN = 0
## Offset from the open position in pixels
@export var CLOSED:int = 300

var offset:Vector2
var target_pos:float = 0
## Direction this object moves in when hiding/closing
@export var direction:Direction
## Percentage of distance travelled each frame
@export_range(0.01, 1.0, 0.01) var speed:float = 0.3

signal state_changed

func _ready():
	offset = position

func _process(_delta):
	var axis = _get_axis()
	position[axis] = lerp(position[axis], target_pos + offset[axis], speed)

func _get_axis():
	return "y" if direction in [Direction.UP, Direction.DOWN] else "x"

func _signed(state):
	return state if direction in [Direction.DOWN, Direction.RIGHT] else -state

func _set_state(state):
	var dirty = not _is_state(state)
	target_pos = _signed(state)
	if dirty: state_changed.emit()

func _is_state(state):
	return target_pos == _signed(state)

func open_show():
	_set_state(OPEN)

func close_hide():
	_set_state(CLOSED)

func flip_state():
	_set_state(CLOSED if _is_state(OPEN) else OPEN)

func snap_open():
	_set_state(OPEN)
	_snap()

func snap_close():
	_set_state(CLOSED)
	_snap()

func _reached(state):
	var axis = _get_axis()
	var delta = position[axis] - offset[axis] - _signed(state)
	return abs(delta) < 0.1

func _snap():
	var axis = _get_axis()
	position[axis] = target_pos + offset[axis]

func is_open():
	return _reached(OPEN)

func is_closed():
	return _reached(CLOSED)

func is_opening():
	return _is_state(OPEN)

func is_closing():
	return _is_state(CLOSED)

func is_stopped():
	return is_open() or is_closed()
