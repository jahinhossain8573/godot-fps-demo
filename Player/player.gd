extends CharacterBody3D

@export var player_speed : float = 9

@export var mouse_sensitivity : float = 0.003

#Assigns the parent Node3D of the player's camera
@export var CameraController : Node3D = null

#Assigns the camera itself
@export var Camera : Camera3D = null

@export var Raycast : RayCast3D = null

@export var gun_position : Vector3 = Vector3.ZERO

var is_firing = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$"CameraController/Gun Mesh".position = gun_position
	$"CameraController/Gun Mesh".rotation = Vector3.ZERO

#Input not defined under "Input Map" in project settings
func _unhandled_input(event: InputEvent) -> void:
	#Check for mouse movement
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		CameraController.rotate_x(event.relative.y * mouse_sensitivity)
		CameraController.rotation.x = clamp(CameraController.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta: float) -> void:
	#Initialised player direction
	var direction : Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction = -Camera.global_transform.basis.z
		direction.y = 0

	if Input.is_action_pressed("move_backward"):
		direction = Camera.global_transform.basis.z
		direction.y = 0

	if Input.is_action_pressed("move_left"):
		direction = -Camera.global_transform.basis.x

	if Input.is_action_pressed("move_right"):
		direction = Camera.global_transform.basis.x
	
	velocity = direction.normalized()
	move_and_slide()
	
	if Input.is_action_just_pressed("trigger"):
		shoot()
		$"CameraController/Gun Mesh/Timer".start()
	
	if Input.is_action_just_released("trigger"):
		$"CameraController/Gun Mesh/Timer".stop()
	
	if Input.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func shoot() -> void:
	$AnimationPlayer.play("Gun Displacement")
	if Raycast.is_colliding():
		print("Trigger!")


func _on_timer_timeout() -> void:
	shoot()
