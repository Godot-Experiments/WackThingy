extends RigidBody2D

var move_speed := 10
var flipped := false
var jump_speed := 256
var rotation_speed := 512
var smoothing := .9
var bonccs := 0

onready var hand = $Upperarm/Forearm/Hand
onready var upperarm_k = $Upperarm/Kinematic
onready var forearm_k = $Upperarm/Forearm/Kinematic
onready var upperarm = $Upperarm
onready var forearm = $Upperarm/Forearm

onready var ground_detect = $GroundDetect



func _ready():
	bounce = .2
	gravity_scale = 8
#	Engine.time_scale = .1

var right_clicked: bool = false
func _physics_process(delta):
	chk_input()
	chk_hand_input()

var num_jumps: int = 2
func chk_input() -> void:
	var is_on_ground : bool = ground_detect.is_colliding()
	if is_on_ground:
		num_jumps = 2
	if Input.is_action_just_pressed("ui_up") and num_jumps >= 1:
		var dir = Vector2(0, -jump_speed)
		move(dir)
		num_jumps -= 1
#		print(has_jump)
	if Input.is_action_pressed("ui_down"):
		var dir = Vector2(0, move_speed)
		move(dir)
	if Input.is_action_pressed("ui_left"):
		flip(false)
#		scale.x = 1
		move(Vector2(-move_speed, -.01))
	if Input.is_action_pressed("ui_right"):
		move(Vector2(move_speed, -.01))
		flip(true)
		
	if rotation != 0:
		apply_torque_impulse(-rotation * rotation_speed)

func chk_hand_input() -> void:
#	$Hand/Hand2.rotation = forearm.rotation
	var rot : float = upperarm.get_local_mouse_position().angle() 
#	var ang = rot * 3
#	forearm.rotation =  clamp(ang, -2.9, -.5)
#	hand.rotation += clamp(rot, -smoothing, smoothing)
	upperarm.rotation += rot * smoothing #clamp(rot, -smoothing, smoothing)
	var wrapped : float = wrapf(upperarm.global_rotation, 0, 2*PI)
#	if 2 <= wrapped and wrapped <= 5:
#		forearm.rotation = lerp(forearm.rotation, -2.5, smoothing)
	if Input.is_action_pressed("left_click"):
		forearm.rotation = lerp(forearm.rotation, 0, smoothing)
		upperarm.position = upperarm.position.linear_interpolate(Vector2(8, -2), smoothing)
	elif Input.is_action_pressed("right_click"):
		forearm.rotation = lerp(forearm.rotation, -2.5, smoothing/2)
	elif Input.is_action_just_released("right_click"):
		right_clicked = true
		$SpikeTime.start()
		reset_arm(smoothing)
	elif right_clicked:
		reset_arm(smoothing)
	else: 
		reset_arm(smoothing / 4)


	forearm_k.move_and_collide(Vector2.ZERO)
	upperarm_k.move_and_collide(Vector2.ZERO)


func reset_arm(smooth: float) -> void:
	forearm.rotation = lerp(forearm.rotation, -.9, smooth)
	upperarm.position = upperarm.position.linear_interpolate(Vector2(-13, 5), smooth)

func _on_SpikeTime_timeout():
	right_clicked = false
	
func move(dir):
	apply_impulse(Vector2(0, 0), dir)
	apply_impulse(Vector2(0, 0), dir)

func flip(left: bool):
	if left:
		scale.x = 1
#	else:
#		scale.x = -1

func _on_HeadArea_body_entered(body):
	if body is StaticBody2D:
		bonccs += 1
		$UI/Announcement.text = "Bruu yu let ***** boncc her hed " + str(bonccs) + " times"



