extends Node2D

onready var Sound = $SoundTrack

var count = 0
var color = 0.0
var game_count = 0
var sound_vol = -80.0
var arr_vol = []
var red = 0
var end_count = 0

onready var sonidos = [
	"res://assets/Sonidos/Miedo/Edits/tema_principal_var.ogg",
	"res://assets/Sonidos/Miedo/Edits/tema_principal.ogg",
	"res://assets/Sonidos/Miedo/Edits/guitarrita_menu1.ogg",
	"res://assets/Sonidos/Miedo/Edits/sonido_percusivo.ogg",
	"res://assets/Sonidos/Miedo/Edits/conspiracion_menu.ogg"]

func _ready():
	Sound.volume_db = sound_vol
	Sound.stream = load(sonidos[0])
	Sound.bus = "SonidoBase"
	modulate = Color(0,0,0,1)
	Sound.play()
	$CanvasModulate.visible = true
	$FadeInTimer.start()
	$HUD/Control/Sprite.modulate = Color(0.1,0.1,0.7)

func _on_Pause_exit_game():
	$FadeOutTimer.start()

func _on_FadeInTimer_timeout():
	count += 1
	color += 1/50.0
	sound_vol += (sound_vol * -1.6)
	modulate = Color(color,color,color,1)
	Sound.volume_db = abs(sound_vol)*-1.0
	arr_vol.push_back(abs(sound_vol))
	if count >= 50:
		$FadeInTimer.stop()
		count = 0

func _on_FadeOutTimer_timeout():
	count += 1
	color -= 1/50.0
	sound_vol -= (sound_vol * 1.6)
	modulate = Color(color,color,color,1)
	Sound.volume_db = arr_vol[50-count] * -1
	if count >= 50:
		count = 0
		sound_vol = -80.0
		$FadeOutTimer.stop()
		$CanvasModulate.visible = false
		Sound.stop()
		$HUD/Control.visible = false
		Scene_Changer.goto_scene("res://assets/Scenes/Menu.tscn")
		queue_free()

func _on_Player_flare():
	$HUD/Control/Label.text = str($Player.no_lights)

func _on_checkpoint_entered():
	$GameTimer.wait_time = 60
	if $Player.no_lights < 5:
		$Player.no_lights = 5
		_on_Player_flare()

func _on_GameTimer_timeout():
	game_count += 1
	if game_count == 8:
		Sound.stop()
		Sound.bus = "Master"
		AudioServer.set_bus_volume_db (0,-18.0)
		Sound.stream = load(sonidos[3])
		Sound.play()
		$EndTimer.start()
		$GameTimer.stop()
		$Player.speed += 100
	if game_count == 6:
		Sound.stop()
		AudioServer.set_bus_volume_db (3,-30.0)
		Sound.stream = load(sonidos[2])
		Sound.play()
	if game_count == 3:
		Sound.stop()
		Sound.stream = load(sonidos[1])
		Sound.play()

func _on_EndTimer_timeout():
	end_count += 1
	print(end_count)
	if red == 0:
		red = 1
	elif red == 1:
		red = 0
	$CanvasModulate.color = Color(red,0,0,1)
	if end_count >= 100:
		$EndTimer.stop()
		$CanvasLayer/Pause/LabelOver.visible = true
		$CanvasLayer/Pause/LabelPausa.visible = false
		$CanvasLayer/Pause.toggle_pause()

func _on_CheckpointF_checkpoint_entered():
	Sound.stop()
	Sound.stream = load(sonidos[0])
	Sound.play()
	$CanvasLayer/Pause/LabelWin.visible = true
	$CanvasLayer/Pause/LabelPausa.visible = false
	$CanvasLayer/Pause.toggle_pause()