extends KinematicBody


export var SPEED := 7.0
export var JUMP_STRENGTH := 20.0
export var GRAVITY := 50.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: MeshInstance = $MeshInstance

func _ready():
	print("player just spawned!")

func _physics_process(delta: float) -> void:	
	var move_direction = get_input_vector()
	apply_movement(move_direction)
	apply_gravity(delta)
	jump()
	land()
	_velocity = move_and_slide(_velocity,Vector3.UP)
	
func _process(delta: float) -> void:
	_spring_arm.translation	= translation
	_model.translation = translation

func get_input_vector():
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_raw_strength("ui_left")
	move_direction.z = Input.get_action_strength("ui_down") - Input.get_action_raw_strength("ui_up")
	
	return move_direction.normalized()

func apply_movement(move_direction):
	_velocity.x = move_direction.x * SPEED
	_velocity.z = move_direction.z * SPEED
	
	
func apply_gravity(delta):
	_velocity.y -= GRAVITY * delta
	

func jump():
	if is_on_floor() and Input.is_action_pressed("jump"):
		_velocity.y = JUMP_STRENGTH

func land():
	if is_on_floor() and _snap_vector == Vector3.ZERO:
		_snap_vector = Vector3.DOWN
