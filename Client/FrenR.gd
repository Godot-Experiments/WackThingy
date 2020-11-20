extends RigidBody2D

var move_speed := 10
var jump_speed := 256
var rotation_speed := 176

onready var hand = $Hand
onready var forearm = $Skeleton2D/Hip/Chest/Arm/Forearm
onready var arm = $Skeleton2D/Hip/Chest/Arm

func _ready():
	bounce = .2
	gravity_scale = 8
#	Engine.time_scale = .1

func _process(delta):

	var ang = get_local_mouse_position().angle()
	var forearm_ang = forearm.look_at(get_global_mouse_position())
	forearm.rotation = clamp(forearm.rotation, -2.4, -.75)
	#
	arm.rotation = ang + .5
	hand.position = lerp(hand.position, (get_local_mouse_position()).clamped(100), .25 )
	
	if Input.is_action_just_pressed("ui_up"):
		var dir = Vector2(0, -jump_speed)
		move(dir)
	if Input.is_action_pressed("ui_down"):
		var dir = Vector2(0, move_speed)
		move(dir)
	elif Input.is_action_pressed("ui_left"):
#		$Polygons.scale.x = .4
		move(Vector2(-move_speed, -.1))
	elif Input.is_action_pressed("ui_right"):
		move(Vector2(move_speed, -.1))
#		$Polygons.scale.x = -.4
	if rotation != 0:
		apply_torque_impulse(-rotation * rotation_speed)
	if Input.is_action_pressed("ui_left_click"):
		apply_torque_impulse(-rotation_speed)
	elif Input.is_action_pressed("ui_right_click"):
		apply_torque_impulse(rotation_speed)
	hand.move_and_collide(Vector2.ZERO)
#	$text = str(forearm_ang)
	
func move(dir):
	apply_impulse(Vector2(0, 0), dir)
	apply_impulse(Vector2(0, 0), dir)


var bonccs := 0
func _on_HeadArea_body_entered(body):
	if body is StaticBody2D:
		bonccs += 1
		$UI/Announcement.text = "Bruu yu let ***** boncc her hed " + str(bonccs) + " times"
