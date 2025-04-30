class_name UnitOverlay extends TileMapLayer

func draw(cells: Array) -> void:
	clear()

	for cell in cells:
		set_cell(cell, 0, Vector2i(9, 6))
