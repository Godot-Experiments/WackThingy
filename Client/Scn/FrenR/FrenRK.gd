extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 400
const STOP_FORCE = 1300
const JUMP_SPEED = 200
var walk: int
var velocity := Vector2()
var num_jumps := 0
onready var gravity = 500 
#ProjectSettings.get_setting("physics/2d/default_gravity")

export var ctrl := false

func _ready():
#	ctrl = is_network_master()
	$Cam.current = ctrl

remote func w(wa: int):
	walk = wa

remote func p(pos: Vector2) -> void:
	position = pos

remote func jump() -> void:
	velocity.y = -JUMP_SPEED

func _physics_process(delta):
	if ctrl and (Input.is_action_just_pressed("ui_right")
			or Input.is_action_just_pressed("ui_left") 
			or Input.is_action_just_released("ui_left") 
			or Input.is_action_just_released("ui_right") 
			):
		walk = WALK_FORCE * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		rpc("w", walk)
		rpc("p", position)
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
#	velocity = move_and_slide(velocity)

	# is_on_floor() must be called after movement code.
	if is_on_floor():
		num_jumps = 2

	if ctrl and Input.is_action_just_pressed("ui_up") and num_jumps >= 1:
		jump()
		rpc("jump")
		num_jumps -= 1

