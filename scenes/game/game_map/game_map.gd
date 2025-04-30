class_name GameMap extends Node2D

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

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

func get_origin_position() -> Vector2i:
	return astar_grid.region.position

# Takes in global positions to find local positions on astar grid.
func find_path(start_position: Vector2i, end_position: Vector2i) -> Array[Vector2i]:
	start_point = ground_layer.local_to_map(start_position)
	end_point = ground_layer.local_to_map(end_position)
	path = astar_grid.get_id_path(start_point, end_point)
	return path

# Returns global position of cell using astar_grid coordinates.
func get_cell_global_position(cell: Vector2i) -> Vector2:
	return ground_layer.map_to_local(cell)

# Returns astar_grid coordinates according to passed global position.
func get_cell_grid_position(_global_position: Vector2i) -> Vector2:
	return ground_layer.local_to_map(_global_position)

# Returns center of cell position from passed global position
func get_snap_position(_global_position: Vector2i) -> Vector2:
	var grid_position: Vector2i = get_cell_grid_position(_global_position)
	return get_cell_global_position(grid_position)

func is_point_walkable(local_position: Vector2) -> bool:
	var map_position: Vector2i = ground_layer.local_to_map(local_position)
	if astar_grid.is_in_boundsv(map_position):
		return not astar_grid.is_point_solid(map_position)
	return false

func flood_fill(cell: Vector2i, max_distance: int) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	var stack: Array[Vector2i] = [cell]

	while not stack.is_empty():
		var current: Vector2i = stack.pop_back()

		if not astar_grid.is_within_bounds(current):
			continue
		if current in array:
			continue

		var difference: Vector2i = (current - cell).abs()
		var distance: int = int(difference.x + difference.y)
		if distance > max_distance:
			continue

		array.append(current)

		for direction: Vector2i in DIRECTIONS:
			var coordinates: Vector2i = current + direction
			# if is_occupied(coordinates):
			# 	continue
			if coordinates in array:
				continue

			# This is where we extend the stack.
			stack.append(coordinates)
	return array
