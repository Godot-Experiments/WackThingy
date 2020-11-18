extends RigidBody2D

const BALANCE := 100

var move_speed := 5
var jump_speed := 100
var rotation_speed := 96
var bonccs := 0

onready var Record : Label = $UI/Record
onready var hand = $Hand
onready var forearm = $Skeleton2D/Hip/Chest/Arm/Forearm
onready var arm = $Skeleton2D/Hip/Chest/Arm
func _process(delta):

	var ang = get_local_mouse_position().angle()
	var forearm_ang = forearm.look_at(get_global_mouse_position())
	forearm.rotation = clamp(forearm.rotation, -2.4, -.75)
	#
	arm.rotation = ang + .5
	hand.position = lerp(hand.position, (get_local_mouse_position()).clamped(128), .25 )
	
	if Input.is_action_just_pressed("ui_up"):
		var dir = Vector2(0, -jump_speed)
		move(dir)
	if Input.is_action_pressed("ui_down"):
		var dir = Vector2(0, move_speed)
		move(dir)
	elif Input.is_action_pressed("ui_left"):
#		$Polygons.scale.x = .4
		move(Vector2(-move_speed, 0))
	elif Input.is_action_pressed("ui_right"):
		move(Vector2(move_speed, 0))
#		$Polygons.scale.x = -.4
	if rotation != 0:
		apply_torque_impulse(-rotation * BALANCE)
	if Input.is_action_pressed("ui_left_click"):
		apply_torque_impulse(-rotation_speed)
	elif Input.is_action_pressed("ui_right_click"):
		apply_torque_impulse(rotation_speed)
	hand.move_and_collide(Vector2.ZERO)

	
func move(dir):
	apply_impulse(Vector2.ZERO, dir)
	apply_impulse(Vector2.ZERO, dir)

func _ready():
	bounce = .2
#	Engine.time_scale = .1

func _on_HeadArea_body_entered(body):
	if body is StaticBody2D:
		bonccs += 1
		Record.text = "Bruu yu let ****** boncc her hed " + str(bonccs) + " times"
