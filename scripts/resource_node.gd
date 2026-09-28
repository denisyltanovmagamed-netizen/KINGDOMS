extends Area3D

var selected := false
@onready var visual: MeshInstance3D = $Visual

var normal_material: Material
var selected_material: StandardMaterial3D

func _ready() -> void:
	collision_layer = 1
	collision_mask = 1
	input_ray_pickable = true

	normal_material = visual.material_override

	selected_material = StandardMaterial3D.new()
	selected_material.albedo_color = Color(0.95, 0.75, 0.20, 1.0)
	selected_material.roughness = 0.75

	input_event.connect(_on_input_event)

func _on_input_event(
	_camera: Camera3D,
	event: InputEvent,
	_position: Vector3,
	normal: Vector3,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select()

func select() -> void:
	selected = true
	visual.material_override = selected_material
	print("Ресурс выбран")

func deselect() -> void:
	selected = false
	visual.material_override = normal_material
