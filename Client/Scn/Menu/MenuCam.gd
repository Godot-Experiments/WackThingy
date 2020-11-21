extends Camera2D


export (float) var magnitude : float = 2
export (float) var duration : float = 0.2
export (float, EASE) var DAMP_EASING = 1.0
var shake : bool = false

func _ready() -> void:
	$Duration.wait_time = duration

func _on_Duration_timeout() -> void:
	shake = false
	self.offset = Vector2()

func startShake(mag := 4, dur := duration, easing := DAMP_EASING) -> void:
		shake = true
		self.magnitude = mag
		self.duration = dur
		self.DAMP_EASING = easing
		$Duration.start()

const CAM_OFF_MAX: int = 300

func _input(event) -> void:
	if event is InputEventMouseButton:
		startShake()

func _physics_process(_delta: float) -> void:
	if shake:
		var damping = ease($Duration.time_left / $Duration.wait_time, DAMP_EASING)
		self.offset = Vector2(
			rand_range(-magnitude, magnitude) * damping,
			rand_range(-magnitude, magnitude) * damping)
	var mp = get_local_mouse_position()
	position = lerp(position, Vector2(mp.x * .4, mp.y * .8), .005)
