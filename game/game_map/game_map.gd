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

# Takes in local positions to find local positions on astar grid.
func find_path(start_position: Vector2i, end_position: Vector2i) -> Array[Vector2i]:
	start_point = ground_layer.local_to_map(start_position)
	end_point = ground_layer.local_to_map(end_position)
	print(str(start_point) + " " + str(end_point))
	path = astar_grid.get_id_path(start_point, end_point)
	print(path)
	return path

# Returns local position of cell using astar_grid coordinates.
func get_local_position(cell: Vector2i) -> Vector2:
	return ground_layer.map_to_local(cell)

# Returns astar_grid coordinates according to passed local position.
func get_map_position(local_position: Vector2i) -> Vector2i:
	if ground_layer.get_used_rect().has_point(local_position):
		return get_origin_position()
	return ground_layer.local_to_map(local_position)

# Returns center of cell position from passed local position
func get_snap_position(_local_position: Vector2i) -> Vector2:
	var grid_position: Vector2i = get_map_position(_local_position)
	return get_local_position(grid_position)

func is_point_walkable(cell: Vector2) -> bool:
	if astar_grid.is_in_boundsv(cell):
		return not astar_grid.is_point_solid(cell)
	return false

func is_within_grid(local_position: Vector2) -> bool:
	var map_position: Vector2i = ground_layer.local_to_map(local_position)
	return astar_grid.is_in_boundsv(map_position)

func flood_fill(map_position: Vector2i, max_distance: int, ignore_solid: bool = true) -> Array[Vector2i]:
	var visited: Dictionary = {}
	var result: Array[Vector2i] = []
	var queue: Array = [map_position]
	visited[map_position] = 0

	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		var distance: int = visited[current]

		if distance > max_distance:
			continue

		result.append(current)

		for direction in DIRECTIONS:
			var neighbor: Vector2i = current + direction
			if visited.has(neighbor):
				continue
			if not astar_grid.is_in_boundsv(neighbor):
				continue
			if !ignore_solid and astar_grid.is_point_solid(neighbor):
				continue

			visited[neighbor] = distance + 1
			queue.append(neighbor)

	# Remove origin if you don't want it in the result
	result.erase(map_position)
	return result
