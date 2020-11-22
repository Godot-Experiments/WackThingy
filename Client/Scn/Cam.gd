extends Camera2D


const cam_move := 10
func _ready():
	current = true

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_W:
			position.y -= zoom.length() * cam_move
		elif event.scancode == KEY_S:
			position.y += zoom.length() * cam_move
		elif event.scancode == KEY_D:
			position.x += zoom.length() * cam_move
		elif event.scancode == KEY_A:
			position.x -= zoom.length() * cam_move
	elif event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			position = lerp(position, get_local_mouse_position(), .25)
			zoom *= .9
		if event.button_index == BUTTON_WHEEL_DOWN:
			position = lerp(position, get_local_mouse_position(), .25)
			zoom *= 1.1
