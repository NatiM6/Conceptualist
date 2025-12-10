extends Node

const MUSIC_PATH = "res://audio/music/"
const SOUND_PATH = "res://audio/sounds/"
var music_player:AudioStreamPlayer

var current_music:String
var target_music:String

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "BGM"
	music_player.stream = load("res://audio/music/menu.mp3")
	music_player.volume_db = -80
	music_player.play()

func _process(delta):
	var fading = target_music != current_music
	if not fading and music_player.volume_db >= _db(0.5): return
	var target_volume = clampf(_volume(music_player.volume_db) + delta * (-1 if fading else 1) * 2, 1e-4, 0.5)
	music_player.volume_db = _db(target_volume)
	if target_volume == 1e-4:
		current_music = target_music
		music_player.stream = load(MUSIC_PATH + target_music + ".mp3")
		music_player.play()

func change_music(title:String):
	target_music = title

func _volume(db):
	return 10 ** (db / 20)

func _db(volume):
	return 20 * log(volume) / log(10)

func play_sound(title:String, pool:int = 1):
	var temp_player = AudioStreamPlayer.new()
	add_child(temp_player)
	temp_player.bus = "SFX"
	if pool > 1:
		temp_player.stream = load(SOUND_PATH + title + str(randi_range(1, pool)) + ".mp3")
	else:
		temp_player.stream = load(SOUND_PATH + title + ".mp3")
	temp_player.connect("finished", temp_player.queue_free)
	temp_player.play()
