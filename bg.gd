extends ParallaxBackground

var speed = 100

func _process(delta: float) -> void:
	scroll_base_offset.x -= speed*delta
