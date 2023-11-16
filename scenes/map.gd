extends Node2D

@onready var back: Sprite2D = $Back
@onready var front: Sprite2D = $Front

const TRANSPARENT := Color(0,0,0,0)
var line := []

func _ready():
	randomize()
	generate_map()
	$Collision.init_map(line)
	
func collision_normal(pos: Vector2) -> Vector2:
	return $Collision.collision_normal(pos)

func generate_map():
	var front_data: Image = front.texture.get_image()
	var back_data: Image = back.texture.get_image()
	
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	noise.seed = randi()
	noise.frequency = 0.01
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5
	
	for x in range(front_data.get_width()):
		var high = ((noise.get_noise_2d(x, 0)+ 1) * front_data.get_height() * 0.3) + front_data.get_height() * 0.18
		line.append(high)
		for y in range(high):
			front_data.set_pixelv(Vector2(x, y), TRANSPARENT)
			back_data.set_pixelv(Vector2(x, y), TRANSPARENT)
			
	front.texture = ImageTexture.create_from_image(front_data)
	back.texture = ImageTexture.create_from_image(back_data)

func explosion(pos: Vector2, radius: int) -> void:
	$Collision.explosion(pos, radius)
	var front_data: Image = front.texture.get_image()
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if Vector2(x, y).length() > radius:
				continue
			var pixel = pos + Vector2(x,y)
			if pixel.x < 0 or pixel.x >= front_data.get_width():
				continue
			if pixel.y < 0 or pixel.y >= front_data.get_height():
				continue
			front_data.set_pixelv(pixel, TRANSPARENT)
	radius -= 20
	var back_data: Image = back.texture.get_image()
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if Vector2(x, y).length() > radius:
				continue
			var pixel = pos + Vector2(x,y)
			if pixel.x < 0 or pixel.x >= back_data.get_width():
				continue
			if pixel.y < 0 or pixel.y >= back_data.get_height():
				continue
			back_data.set_pixelv(pixel, TRANSPARENT)
			
	front.texture = ImageTexture.create_from_image(front_data)
	back.texture = ImageTexture.create_from_image(back_data)
	
