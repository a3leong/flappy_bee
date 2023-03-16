extends Node

@export var max_flower_offset = 150
@export var flower_obstacle_scene: PackedScene
const flower_obstacle_emitter = preload("res://flower_obstacle.tscn")
var score = 0

func _ready():
	$bee.set_start_position($StartPosition.position)
	$BGM.play()

func _on_score_points(pts):
	print("pts scored: " + str(score) + ":" + str(pts))
	score += pts
	$HUD.update_score(score)

func _on_flower_spawn_timer_timeout():
	print("Spawn flower")
	var flower_obstacle = flower_obstacle_scene.instantiate()
	flower_obstacle.position = $FlowerSpawnPosition.position
	
	# Randomize the height of the flower
	flower_obstacle.position.y += randi_range(-max_flower_offset, max_flower_offset);
	print(str(flower_obstacle.position))
	flower_obstacle.connect("score_points", _on_score_points)
	add_child(flower_obstacle)

func _on_hud_start_game():
	start_game()

func start_game():
	print("Game started")
	if !$BGM.playing:
		$BGM.play()
	get_tree().call_group("flower_obstacle_group", "queue_free")
	$FlowerSpawnTimer.start()
	$bee.start($StartPosition.position)
	score = 0
	$HUD.update_score(score)

func end_game():
	$HUD.show_game_over(score)
	$DeadSFX.play()
	$BGM.stop()

func _on_bee_hit():
	end_game()


func _on_deathzone_body_entered(body):
	if body.name == "bee":
		end_game()
		$bee.die()
