class_name EnemyTurn extends State

@export var player: Player
@export var game: Game
@export var game_map: GameMap

var queue: Array = []

func enter() -> void:
	queue = []
	var enemies: Array[Node] = game.enemies.get_children()
	for enemy in enemies:
		if enemy is Goblin:
			enemy.reset()
			queue.append(enemy)
			if !enemy.is_connected("actions_finished", cycle_through_enemies):
				enemy.connect("actions_finished", cycle_through_enemies)
	cycle_through_enemies()

func cycle_through_enemies() -> void:
	if queue.is_empty():
		transitioned.emit(self, "playerturn")
		return
	var enemy: Goblin = queue.pop_front()
	for action in enemy.actions:
		enemy.call(action, player.cell)

func exit() -> void:
	pass
