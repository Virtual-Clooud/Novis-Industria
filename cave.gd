extends Spatial
func _process(delta):
	if Input.is_action_pressed("Enter"):
		$text.visible = false
