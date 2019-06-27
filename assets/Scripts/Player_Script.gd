extends KinematicBody2D

var Bullet = preload("res://assets/Scenes/Bullet.tscn")
export (int) var speed = 200
var velocity = Vector2()
var no_lights
signal flare

func get_input():
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed('MoveUP'):
		velocity = Vector2(speed,0).rotated(rotation)
	if Input.is_action_pressed('MoveBack'):
		velocity = Vector2(-speed,0).rotated(rotation)
	if Input.is_action_just_pressed("L_Click"):
		shoot()
	if Input.is_action_just_pressed("R_Click") and no_lights > 0:
		place_light()
		no_lights -= 1
		emit_signal("flare")

func shoot():
    var b = Bullet.instance()
    b.start($Muzzle.global_position, rotation)
    get_parent().add_child(b)

func place_light():
	var light = Bullet.instance()
	light.place($Muzzle.global_position, rotation)
	get_parent().add_child(light)

func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)

func start(pos):
	position = pos

func _ready():
	$Camera2D.current = true
	no_lights = 5

func _on_Pause_exit_game():
	$Camera2D.current = false
	queue_free()