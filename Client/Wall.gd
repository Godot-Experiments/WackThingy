extends StaticBody2D


#const SIZE := 2048
#const SIZE_Y := 128

#func _ready():
#	$HitBox.shape.extents.x = SIZE
#	$Img.rect_min_size.x = SIZE * 2
#	$Img.margin_left = -SIZE
#	$Img.margin_top = -SIZE_Y
#	$Img.margin_right = SIZE
#	$Img.margin_bottom = SIZE_Y
#	$Occluder.occluder.polygon = [Vector2(-SIZE, -SIZE_Y), Vector2(-SIZE, SIZE_Y), Vector2(SIZE, SIZE_Y), Vector2(SIZE, -SIZE_Y)]
