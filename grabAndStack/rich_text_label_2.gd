extends RichTextLabel

func _process(delta: float) -> void:
	text = str($"../EndGameTimer".time_left)
