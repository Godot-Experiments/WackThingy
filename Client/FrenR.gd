extends RigidBody2D

var move_speed := 10
var jump_speed := 256
var rotation_speed := 512

onready var hand = $Hand
onready var forearm = $Skeleton2D/Hip/Chest/Arm/Forearm
onready var arm = $Skeleton2D/Hip/Chest/Arm

func _ready():
	bounce = .2
	gravity_scale = 8
#	Engine.time_scale = .1

var smoothing := .25

func _physics_process(delta):

#	var ang = forearm.get_local_mouse_position().angle()
#	forearm.rotation =  clamp(lerp(forearm.rotation, ang, smoothing), -2.4, -.75)
#	$Hand/Hand2.rotation = forearm.rotation
#	var rot : float = hand.get_local_mouse_position().angle() * smoothing
#	hand.rotation += clamp(rot, -smoothing, smoothing)
#	arm.rotation += clamp(rot, -smoothing, smoothing)

	
	if Input.is_action_just_pressed("ui_up"):
		var dir = Vector2(0, -jump_speed)
		move(dir)
	if Input.is_action_pressed("ui_down"):
		var dir = Vector2(0, move_speed)
		move(dir)
	elif Input.is_action_pressed("ui_left"):
		flip(false)
#		scale.x = 1
		move(Vector2(-move_speed, -.1))
	elif Input.is_action_pressed("ui_right"):
		move(Vector2(move_speed, -.1))
		flip(true)
		
	if rotation != 0:
		apply_torque_impulse(-rotation * rotation_speed)
	if Input.is_action_pressed("left_click"):
		apply_torque_impulse(-rotation_speed)
	elif Input.is_action_pressed("right_click"):
		apply_torque_impulse(rotation_speed)
	hand.move_and_collide(Vector2.ZERO)
#	$text = str(forearm_ang)
	
func move(dir):
	apply_impulse(Vector2(0, 0), dir)
	apply_impulse(Vector2(0, 0), dir)

func flip(left: bool):
	if left:
		$BodyHitbox.scale.x = 1
#		$HeadArea.scale.x = 1
		$Skeleton2D.scale.x = .4
		$Polygons.scale.x = .4
		$Hand.scale.x = 1
		$HeadArea.position.x = -3.5
		$Jacket.rect_scale.x = 1
		$Jacket2.rect_scale.x = 1
	else:
		$BodyHitbox.scale.x = -1
#		$HeadArea.scale.x = -1
		$Skeleton2D.scale.x = -.4
		$Polygons.scale.x = -.4
		$Hand.scale.x = -1
		$HeadArea.position.x = 3.5
		$Jacket.rect_scale.x = -1
		$Jacket2.rect_scale.x = -1

var bonccs := 0
func _on_HeadArea_body_entered(body):
	if body is StaticBody2D:
		bonccs += 1
		$UI/Announcement.text = "Bruu yu let ***** boncc her hed " + str(bonccs) + " times"
