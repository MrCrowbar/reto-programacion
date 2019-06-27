extends Control
var pause_state
signal exit_game

func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()

func _on_Exit_pressed():
	toggle_pause()
	emit_signal("exit_game")

func toggle_pause():
	pause_state = not get_tree().paused
	get_tree().paused = pause_state
	visible = pause_state