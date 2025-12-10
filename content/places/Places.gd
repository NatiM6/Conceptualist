extends Node2D
class_name Places

const WORKSHOP = "workshop"
const TOWN = "town"
const MUSEUM = "museum"
const POSTBOX = "postbox"
const SMITHY = "smithy"
const ORBSHOP = "orbshop"
const BEDROOM = "bedroom"

@export var scene_code:String

@warning_ignore("unused_signal")
signal request_scene_change(target)

func request_scene_slot(_source):
	pass
