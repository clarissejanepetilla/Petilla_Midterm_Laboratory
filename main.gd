extends Node
@export var enemy_scene: PackedScene
var score

func _ready():
	new_game()

func game_over():
	$scoreTimer.stop()
	$enemyTimer.stop()
	$HUD.show_game_over()
	$music.stop()
	$death.play()

func new_game():
	get_tree().call_group("enemy", "queue_free")
	score = 0
	$Player.start($startPosition.position)
	$startTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$music.play()

func _on_score_timer_timeout():
	score +=1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$enemyTimer.start()
	$scoreTimer.start()

func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $enemyPath/enemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	var direction = enemy_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 300.0),0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	add_child(enemy)
