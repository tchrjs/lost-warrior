class_name GridOverlay extends TileMapLayer

var area: Array[Vector2i]

func draw(_cells: Array[Vector2i]) -> void:
	area = _cells
	clear()

	for cell in area:
		set_cell(cell, 0, Vector2i(9, 6))
