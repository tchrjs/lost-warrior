class_name GameMap extends Node

@export var ground_layer: TileMapLayer

# The object for pathfinding on 2D grids.
var astar_grid: AStarGrid2D

# Starting point of path.
var start_point: Vector2i
var end_point: Vector2i

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = ground_layer.get_used_rect() # Area of astar grid.
	astar_grid.cell_size = ground_layer.tile_set.tile_size # Size of each cell.
	astar_grid.update()

# Takes in global positions to find local positions on astar grid.
func find_path(start_position: Vector2i, end_position: Vector2i) -> void:
	start_point = ground_layer.local_to_map(start_position)
	end_point = ground_layer.local_to_map(end_position)

	var id_path: Array[Vector2i] = astar_grid.get_id_path(start_point, end_point)
	print(id_path)

func is_point_walkable(local_position: Vector2) -> bool:
	var map_position: Vector2i = ground_layer.local_to_map(local_position)
	if astar_grid.is_in_boundsv(map_position):
		return not astar_grid.is_point_solid(map_position)
	return false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_point_walkable(event.position):
			find_path(Vector2i(55, 35), event.position)
