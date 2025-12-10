extends Node

class Character:
	const FRIEND = "friend"
	const CROC = "croc"
	const OWL = "owl"
	const POSTBOX = "postbox"
	const FOX = "fox"
	const PLAYER = "player"

class Emotion:
	const NEUTRAL = "neutral"
	const HAPPY = "happy"
	const SAD = "sad"
	const ANGRY = "angry"
	const CONFUSED = "confused"
	const SHOCKED = "shocked"
	const EMBARASSED = "embarassed"
	const DIGUSTED = "disgust"
	const SLEEPY = "sleepy"

class Line:
	var character:String
	var emotion:String
	var text:String = "dialogue.error.line_undefined"
	
	func _init(character_:String, emotion_:String):
		character = character_
		emotion = emotion_

var ALL_DIALOGUES:Dictionary = {}

func _ready():
	register("test", [[
		Line.new(Character.CROC, Emotion.NEUTRAL),
		Line.new(Character.OWL, Emotion.NEUTRAL),
		Line.new(Character.OWL, Emotion.NEUTRAL),
		Line.new(Character.FOX, Emotion.NEUTRAL),
		Line.new(Character.CROC, Emotion.NEUTRAL)
	]])
	register("postbox", [[
		Line.new(Character.OWL, Emotion.NEUTRAL),
		Line.new(Character.FOX, Emotion.NEUTRAL),
		Line.new(Character.OWL, Emotion.NEUTRAL)
	]])

## The lines should be a nested Array of alternative sequences of lines
func register(id:StringName, lines:Array):
	var bundle_counter = 1
	for bundle in lines:
		var option_counter = 1
		for line in bundle:
			line.text = "dialogue.%s.%d.%d" % [id, bundle_counter, option_counter]
			option_counter += 1
		bundle_counter += 1
	ALL_DIALOGUES[id] = lines

func get_dialogue(id:StringName):
	return ALL_DIALOGUES.get(id, [[Line.new(Character.FRIEND, Emotion.CONFUSED)]]).pick_random()
