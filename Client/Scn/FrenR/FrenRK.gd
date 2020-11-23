extends KinematicBody2D

const respawn_ui := preload("res://Scn/Respawn.tscn")

const laser_s = preload("res://Scn/Laser.tscn")

const AMMO_MAX := 6
var ammo := AMMO_MAX

const WALK_FORCE = 600
const WALK_MAX_SPEED = 800
const JUMP_SPEED = 1600
const STOP_FORCE = 100
const WALK_THRESH = WALK_FORCE * 0.2
const MAX_JUMPS = 3

var shot: bool = false
var walk: int
var velocity := Vector2()
var num_jumps := 0
onready var gravity = 80
#ProjectSettings.get_setting("physics/2d/default_gravity")


remote var d: int = 0
var smoothing := .9
var right_clicked: bool = false

onready var ammo_bar = $UI2/Ammo
#onready var ammo_tag = $UI2/AmmoTag
onready var reload = $ReloadTime
onready var hand = $Upperarm/Forearm/Hand
#onready var upperarm_k = $Upperarm/Kinematic
#onready var forearm_k = $Upperarm/Forearm/Kinematic
onready var upperarm = $Upperarm
onready var forearm = $Upperarm/Forearm
onready var health = $UI/Health
onready var tag = $UI/Tag
onready var ground_detect = $GroundDetect
onready var mouse = $Mouse

const UARM_ROT_OFF = .71


export var ctrl := false

var hp := 10

var flipped: bool = false
var team: int

func setup(t: int, c: int) -> void:
	team = t
#	chara = c

func _ready():
	ctrl = is_network_master()
	$Cam.current = ctrl
	add_to_group(gamestate.DAMAGEABLE)
	if not ctrl:
		health.material = null
		tag.material = null
		tag.text = gamestate.players[get_network_master()][0]
		$UI2.queue_free()
	match team:
		0:
			modulate = Color("a3f3d5")
		1:
			modulate = Color("c5a3f3")
	update_hp()


const txt_part_s := preload("res://Scn/FX/TxtParticle.tscn")
func dmg(d: int):
	var t = txt_part_s.instance()
	t.position = global_position
	get_node("/root").add_child(t)
	hp -= d
	update_hp()
	if ctrl:
		if hp <= 0:
			rpc("die")

func update_hp():
	health.value = hp
	for pid in gamestate.other_players:
		rpc_id(pid, "h", hp)

remote func h(he: int):
	hp = he

remotesync func die():
	if is_network_master():
		get_node("/root").add_child(respawn_ui.instance())
	queue_free()

remote func w(wa: int):
	walk = wa

remote func p(pos: Vector2) -> void:
	position = pos

remote func jump() -> void:
	velocity.y = -JUMP_SPEED


func flip_left(left: bool):
	if not flipped and left:
		flipped = true
		scale.x = -1
		if ctrl:
			for id in gamestate.other_players:
				rpc_id(id, "fl", left)
		$UI.scale.x = -1
	elif flipped and not left:
		flipped = false
		scale.x = -1
		if ctrl:
			for id in gamestate.other_players:
				rpc_id(id, "fl", left)
		$UI.scale.x = 1

remote func fl(left: bool) -> void:
	flip_left(left)

export var extents = 2500

func _physics_process(delta):
	if ctrl and (Input.is_action_just_pressed("ui_right")
			or Input.is_action_just_pressed("ui_left") 
			or Input.is_action_just_released("ui_left") 
			or Input.is_action_just_released("ui_right") 
			):
		walk = WALK_FORCE * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		for id in gamestate.other_players:
			rpc_id(id, "w", walk)
		rpc("p", position)
		if Input.is_action_just_pressed("ui_left"):
			flip_left(true)
		elif Input.is_action_just_pressed("ui_right"):
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
	if ctrl:
		if position.y >= extents:
			rpc("die")
		if is_on_floor():
			num_jumps = MAX_JUMPS
		if Input.is_action_just_pressed("ui_up") and num_jumps >= 1:
			jump()
			for id in gamestate.other_players:
				rpc_id(id, "jump")
			num_jumps -= 1
		if Input.is_action_just_pressed("reload"):
			reload()
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

func shoot() -> void:
	if ammo >= 1 and $ReloadTime.is_stopped():
		var laser = laser_s.instance()
		laser.setup(
			$Upperarm/Forearm/Hand.global_position,
			$Upperarm/Forearm/Hand.global_position - $Upperarm/Forearm.global_position,
			self,
			team
		)
		get_tree().get_root().add_child(laser)
		forearm.rotation = lerp(forearm.rotation, -2.8, smoothing/2)
		ammo -= 1
		if ammo <= 0:
			reload()
		if ctrl:
			ammo_bar.value = ammo


remote func s() -> void:
	shot = true
#	forearm_k.move_and_collide(Vector2.ZERO)
#	upperarm_k.move_and_collide(Vector2.ZERO)


func reset_arm(smooth: float) -> void:
	forearm.rotation = lerp(forearm.rotation, -.9, smooth)
	upperarm.position = upperarm.position.linear_interpolate(Vector2(-12, 3), smooth)


func reload() -> void:
	reload.start()
	anim.play("Reload")


onready var anim = $Anim

func _on_ReloadTime_timeout():
	ammo = AMMO_MAX
	


