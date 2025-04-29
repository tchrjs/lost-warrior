class_name GameMap extends Node2D

@export var ground_layer: TileMapLayer

# The object for pathfinding on 2D grids.
var astar_grid: AStarGrid2D

# Starting point of path.
var start_point: Vector2i
var end_point: Vector2i
var path: Array[Vector2i]

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = ground_layer.get_used_rect() # Area of astar grid.
	astar_grid.cell_size = ground_layer.tile_set.tile_size # Size of each cell.
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

# Takes in global positions to find local positions on astar grid.
func find_path(start_position: Vector2i, end_position: Vector2i) -> Array[Vector2i]:
	start_point = ground_layer.local_to_map(start_position)
	end_point = ground_layer.local_to_map(end_position)
	path = astar_grid.get_id_path(start_point, end_point)
	return path

# Use local position to get global position.
func get_target_position(selected_point: Vector2i) -> Vector2:
	return ground_layer.map_to_local(selected_point)

# Use global position to snap to local position.
func get_snap_position(selected_point: Vector2i) -> Vector2:
	var local_position = ground_layer.local_to_map(selected_point)
	return get_target_position(local_position)

func is_point_walkable(local_position: Vector2) -> bool:
	var map_position: Vector2i = ground_layer.local_to_map(local_position)
	if astar_grid.is_in_boundsv(map_position):
		return not astar_grid.is_point_solid(map_position)
	return false
