extends CanvasLayer

signal start_game

func _on_start_pressed():
	$Start.hide()
	$GameOver.hide()
	$Score.show()
	$Title.hide()
	start_game.emit()


func update_score(new_score):
	$Score.text = str(new_score)
	
func show_game_over(final_score):
	$Score.hide()
	$GameOver.text = "Game Over\nScore: " + str(final_score)
	$GameOver.show()
	$Start.show()
