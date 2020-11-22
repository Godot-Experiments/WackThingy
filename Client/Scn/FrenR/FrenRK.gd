extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 800
const JUMP_SPEED = 1600
const STOP_FORCE = 100
const WALK_THRESH = WALK_FORCE * 0.2
const MAX_JUMPS = 3
var walk: int
var velocity := Vector2()
var num_jumps := 0
onready var gravity = 80



remote var d: int = 0
var smoothing := .9
var right_clicked: bool = false
onready var hand = $Upperarm/Forearm/Hand
#onready var upperarm_k = $Upperarm/Kinematic
#onready var forearm_k = $Upperarm/Forearm/Kinematic
onready var upperarm = $Upperarm
onready var forearm = $Upperarm/Forearm

onready var ground_detect = $GroundDetect
onready var mouse = $Mouse

const UARM_ROT_OFF = .71
#ProjectSettings.get_setting("physics/2d/default_gravity")

export var ctrl := false

var hp := 10

var team

func setup(t: int, c: int) -> void:
	team = t
#	chara = c

func _ready():
	ctrl = is_network_master()
	$Cam.current = ctrl
	add_to_group(gamestate.DAMAGEABLE)

func dmg(d: int):
	if ctrl:
		hp -= 1
		if hp <= 0:
			rpc("die")

remotesync func die():
	queue_free()

remote func w(wa: int):
	walk = wa

remote func p(pos: Vector2) -> void:
	position = pos

remote func jump() -> void:
	velocity.y = -JUMP_SPEED

var flipped: bool = false

func flip_left(left: bool):
	if not flipped and left:
		flipped = true
		scale.x = -1
		for id in gamestate.players:
			rpc_id(id, "fl", left)
	elif flipped and not left:
		flipped = false
		scale.x = -1
		for id in gamestate.players:
			rpc_id(id, "fl", left)

remote func fl(left: bool) -> void:
	flip_left(left)

func _physics_process(delta):

	if ctrl and (Input.is_action_just_pressed("ui_right")
			or Input.is_action_just_pressed("ui_left") 
			or Input.is_action_just_released("ui_left") 
			or Input.is_action_just_released("ui_right") 
			):
		walk = WALK_FORCE * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		for id in gamestate.players:
			rpc_id(id, "w", walk)
		rpc("p", position)
		if Input.is_action_just_pressed("ui_left"):
			flip_left(true)
		elif Input.is_action_pressed("ui_right"):
			flip_left(false)

	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_THRESH:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE)
	else:
		velocity.x += walk
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)


	if ctrl and (Input.is_action_just_pressed("ui_down")
			or Input.is_action_just_released("ui_down") 
			):
		d = Input.get_action_strength("ui_down") 
		rset("d", d)
		rpc("p", position)

	# Apply gravity.
	velocity.y += gravity + d


	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
#	velocity = move_and_slide(velocity)

	# is_on_floor() must be called after movement code.
	if is_on_floor():
		num_jumps = MAX_JUMPS

	if ctrl and Input.is_action_just_pressed("ui_up") and num_jumps >= 1:
		jump()
		for id in gamestate.players:
			rpc_id(id, "jump")
		num_jumps -= 1
	
	chk_hand_input()


remote func ur(rot: float):
	upperarm.rotation = rot + UARM_ROT_OFF

func chk_hand_input() -> void:
	if ctrl:
		var rot : float = mouse.get_local_mouse_position().angle() 
		mouse.rotation += rot * smoothing
		upperarm.rotation = mouse.rotation + UARM_ROT_OFF #clamp(rot, -smoothing, smoothing)
		var wrapped : float = wrapf(upperarm.global_rotation, 0, 2*PI)
		rpc("ur", mouse.rotation)
#		if Input.is_action_just_pressed("right_click"):
#			forearm.rotation = lerp(forearm.rotation, 0, smoothing)
#			upperarm.position = upperarm.position.linear_interpolate(Vector2(8, -2), smoothing)
		if Input.is_action_just_pressed("left_click"):
			shoot()
			rpc("s")
		else: 
			reset_arm(smoothing / 8)
	else:
		if shot:
			shoot()
			shot = false
		else: 
			reset_arm(smoothing / 8)

const laser_s = preload("res://Scn/Laser.tscn")
func shoot() -> void:
	var laser = laser_s.instance()
	laser.setup(
		$Upperarm/Forearm/Hand.global_position,
		$Upperarm/Forearm/Hand.global_position - $Upperarm/Forearm.global_position,
		self,
		team
	)
	get_tree().get_root().add_child(laser)
	forearm.rotation = lerp(forearm.rotation, -2.8, smoothing/2)

var shot: bool = false
remote func s() -> void:
	shot = true
#	forearm_k.move_and_collide(Vector2.ZERO)
#	upperarm_k.move_and_collide(Vector2.ZERO)


func reset_arm(smooth: float) -> void:
	forearm.rotation = lerp(forearm.rotation, -.9, smooth)
	upperarm.position = upperarm.position.linear_interpolate(Vector2(-12, 3), smooth)















