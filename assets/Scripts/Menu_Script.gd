extends Control

var count = 0
export var fade_count = 5.0
var color = 0.0
var toggle

func _ready():
	modulate = Color(0,0,0,1)
	$Camera2D.current = true
	$CanvasModulate.visible = true
	$Introduction.visible = false
	$Sonido_Menu.play()
	$FadeInTimer.start()

func _process(delta):
	$Luz.position = get_global_mouse_position()

func _on_Exit_Button_pressed():
	get_tree().quit()

func _on_Start_Button_pressed():
	$FadeOutTimer.start()

func _on_HowTo_Button_pressed():
	toggle = not $TileMap.visible
	$TileMap.visible = toggle
	$Start_Button.visible = toggle
	$Exit_Button.visible = toggle
	$Introduction.visible = not toggle
	if toggle:
		$HowTo_Button.text = "Cómo jugar"
		$Luz/Light2D.shadow_enabled = true
	else:
		$HowTo_Button.text = "Volver al menú"
		$Luz/Light2D.shadow_enabled = false

func _on_FadeOutTimer_timeout():
	count += 1
	color -= 1/(fade_count*10)
	$Sonido_Menu.volume_db = (color-0.1)
	modulate = Color(color,color,color,1)
	if count >= fade_count * 10:
		count = 0
		$FadeOutTimer.stop()
		$CanvasModulate.visible = false
		$Camera2D.current = false
		$Sonido_Menu.stop()
		Scene_Changer.goto_scene("res://assets/Scenes/Main.tscn")
		queue_free()

func _on_FadeInTimer_timeout():
	count += 1
	color += 1/50.0
	$Sonido_Menu.volume_db = color
	modulate = Color(color,color,color,1)
	if count >= 50:
		$FadeInTimer.stop()
		count = 0