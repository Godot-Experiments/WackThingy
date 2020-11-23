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

var messages := ["The Dark sure is scary, huh?", "Where did your failure bring you? Back here. Lol.", 
	"Need a hand? I think you have only one. That shoots lasers. Don't ask why, idk.", 
	"Does louder = funnier? Well, I have no sound, so", "In this world, it's y33t or be y33ted.", 
	"Did you ever hear the tragedy of tuba boss fight music? It's not a story I will tell you.", 
	"Yo mama theme song so good, it emphasizes how bad you are at not getting Shek'd.", 
	"Onion News Network is so reliable.", "Squish that cat.", "Are you my computer? Because you just got shut down.",
	"Oblivion NPC dialogue is your mind after you got Shek'd.", "I like dogs."]
var msg_len := messages.size()

onready var died = $Respawn/CanvasLayer/Died
func _on_MsgSwitch_timeout():
	randomize()
	died.text = messages[randi() % msg_len]
	died.modulate = Color("ffbef9")
