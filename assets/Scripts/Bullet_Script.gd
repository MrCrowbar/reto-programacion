extends KinematicBody2D

export var speed = 750
var velocity = Vector2()
var init_energy = 1.0

func start(pos,dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed,0).rotated(rotation)
	var c = Color(0.7,0.1,0.1)
	$Light2D.set_color(c)
	$Light2D.set_energy(init_energy)

func place(pos,dir):
	rotation = dir
	position = pos
	velocity = Vector2(0,0).rotated(rotation)
	var c = Color(0.1,0.1,0.7)
	$Light2D.set_color(c)
	$Light2D.set_energy(3)

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if velocity.x != 0 or velocity.y != 0:
		life_Span()
	if collision:
		velocity = velocity.bounce(collision.normal)

func life_Span():
	var time_left = $Timer.get_time_left()
	$Light2D.set_energy(init_energy + (2/(time_left+1)))
	if time_left <= 0:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()