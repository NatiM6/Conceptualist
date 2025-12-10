extends Node

var data:Dictionary = {
	"money": 10,
	"knowledge": 0,
	"flags": {},
	"stored_orbs": {},
	"locale": "pl_PL"
}

var instance:Game

func set_game_instance(game:Game):
	instance = game

func store_orb(element:String, amount:int):
	if data.stored_orbs.has(element): data.stored_orbs[element] += amount
	else: data.stored_orbs[element] = max(0, amount)

func count_orb(element:String):
	return data.stored_orbs.get(element, 0)

func add_money(amount):
	data.money = maxi(0, data.money + amount)
	instance.update()
	AudioManager.play_sound("cash")

func add_knowledge(amount):
	data.knowledge = maxi(0, data.knowledge + amount)
	instance.update()
	AudioManager.play_sound("knowledge")

func get_context():
	return {
		"money": data.money,
		"knowledge": data.knowledge,
		"day": TimeManager.day,
		"phase": TimeManager.get_phase()
	}
