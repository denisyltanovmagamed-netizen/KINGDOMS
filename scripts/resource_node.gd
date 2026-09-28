extends Area3D

var selected := false
@onready var visual: MeshInstance3D = $Visual
var normal_material: Material
var selected_material: StandardMaterial3D

func _ready() -> void:
	normal_material = visual.material_override

	selected_material = StandardMaterial3D.new()
	selected_material.albedo_color = Color(0.95, 0.75, 0.20)
	selected_material.roughness = 0.75

func select() -> void:
	selected = true
	visual.material_override = selected_material
	print("Ресурс выбран")

func deselect() -> void:
	selected = false
	visual.material_override = normal_material
