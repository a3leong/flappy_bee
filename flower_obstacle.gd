extends Node2D

@export var speed = 300
signal score_points

func _process(delta):
	position.x -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Flower deleted")
	queue_free()


func _on_score_area_body_entered(body):
	score_points.emit(1)
