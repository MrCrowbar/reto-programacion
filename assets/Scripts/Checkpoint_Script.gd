extends Light2D
signal checkpoint_entered
var flag = 0
func _on_Area2D_body_entered(body):
	if flag == 0:
		self.color = Color(0.117, 0.890, 0.780)
		self.flag = 1
		emit_signal("checkpoint_entered")