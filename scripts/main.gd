extends Node3D

@onready var camera: Camera3D = $Camera3D

var rotating := false
var last_mouse_position := Vector2.ZERO

const CAMERA_SPEED := 25.0
const ZOOM_SPEED := 4.0
const ROTATION_SPEED := 0.3
const MIN_HEIGHT := 10.0
const MAX_HEIGHT := 60.0
const MAP_SIZE := 100.0

func _ready() -> void:
	print("KINGDOMS запущен")

func _process(delta: float) -> void:
	move_camera(delta)

func move_camera(delta: float) -> void:
	if camera == null:
		return

	var direction := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.z += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0

	if direction.length() > 0.0:
		direction = direction.normalized()
		camera.position += direction * CAMERA_SPEED * delta
		limit_camera_position()

func limit_camera_position() -> void:
	camera.position.x = clamp(camera.position.x, -MAP_SIZE, MAP_SIZE)
	camera.position.z = clamp(camera.position.z, -MAP_SIZE, MAP_SIZE)
	camera.position.y = clamp(camera.position.y, MIN_HEIGHT, MAX_HEIGHT)

func _unhandled_input(event: InputEvent) -> void:
	if camera == null:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera.position.y -= ZOOM_SPEED
			limit_camera_position()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera.position.y += ZOOM_SPEED
			limit_camera_position()

		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			rotating = event.pressed
			last_mouse_position = event.position

		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_resource(event.position)

	elif event is InputEventMouseMotion and rotating:
		var mouse_delta: Vector2 = event.position - last_mouse_position
		last_mouse_position = event.position
		camera.rotate_y(-mouse_delta.x * ROTATION_SPEED * 0.01)

func select_resource(screen_position: Vector2) -> void:
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 500.0

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result := get_world_3d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		return

	var collider = result.get("collider")
	if collider is Area3D and collider.has_method("select"):
		collider.select()
