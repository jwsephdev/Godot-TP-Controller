extends CharacterBody3D


var lerp_speed = 10.0
var direction = Vector3.ZERO
var currentdir
const SPEED = 6.0
const JUMP_VELOCITY = 4.5

@export var Camera_Sensitivity = 0.3
@onready var player: CharacterBody3D = $"."
@onready var animation_player: AnimationPlayer = $Animations/AnimationPlayer

@onready var camera_mount: Node3D = $CameraMount
@onready var visuals: Node3D = $Visuals
@onready var spring_arm_3d: SpringArm3D = $CameraMount/SpringArm3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func MouseMove(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * Camera_Sensitivity)
		visuals.rotate_y(deg_to_rad(event.relative.x) * Camera_Sensitivity)
		camera_mount.rotate_x(deg_to_rad( -event.relative.y) * Camera_Sensitivity)
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-55), deg_to_rad(35))
		
		
func _input(event: InputEvent) -> void:
	MouseMove(event)
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		animation_player.play("falling")
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animation_player.play("falling")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		if is_on_floor_only():
			animation_player.play("Walk")
		visuals.look_at(position + direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if is_on_floor():
			animation_player.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide()
	
	
	move_and_slide()
