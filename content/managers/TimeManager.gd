extends Node

const PHASE_LENGTH = 120 # Seconds

const MORNING = 0
const NOON = PHASE_LENGTH
const EVENING = PHASE_LENGTH * 2
const NIGHT = PHASE_LENGTH * 3
const SLEEP = PHASE_LENGTH * 4

var time:float = MORNING
var day:int = 0

signal time_advanced(new_time, by)
signal phase_advanced(new_phase)
signal day_advanced(new_day)

func advance_time(amount:float):
	## Advance time by a set amount
	var old_phase = get_phase()
	var actual_amount = amount * (1 - clamp((time - SLEEP)/PHASE_LENGTH*2, 0, 1))
	time += actual_amount
	time_advanced.emit(time, actual_amount)
	var new_phase = get_phase()
	if new_phase != old_phase: phase_advanced.emit(new_phase)

func advance_phase():
	## Advance time until the next phase
	if time >= SLEEP: return
	advance_time(get_phase() + PHASE_LENGTH - time)

func advance_day():
	## Advance time until morning and start a new day
	var by = SLEEP + PHASE_LENGTH - time
	time = 0.
	day += 1
	time_advanced.emit(0., by)
	phase_advanced.emit(MORNING)
	day_advanced.emit(day)

func get_global_time():
	return day * 5 * PHASE_LENGTH + time

func get_phase():
	return floori(time / PHASE_LENGTH) * PHASE_LENGTH

func get_phase_ratio():
	return time / PHASE_LENGTH
