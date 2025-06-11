extends CharacterBody3D

var lerp_speed = 10.0
var direction = Vector3.ZERO

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var Camera_Sensitivity = 0.3

@onready var camera_mount: Node3D = $camera_mount
@onready var visuals: Node3D = $visuals


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func MouseMove(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * Camera_Sensitivity)
		visuals.rotate_y(deg_to_rad(event.relative.x) * Camera_Sensitivity)
		camera_mount.rotate_x(deg_to_rad( -event.relative.y) * Camera_Sensitivity)
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-70), deg_to_rad(15))
		
		
func _input(event: InputEvent) -> void:
	MouseMove(event)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	if direction:
		
		
		visuals.look_at(position + direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
