extends Node2D

@onready var back: Sprite2D = $Background
const TRANSPARENT := Color(0,0,0,0)
var line := []

func _ready():
	randomize()
	generate_map()

func generate_map():
	var back_data: Image = back.texture.get_image()
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.fractal_octaves = 1
	noise.fractal_lacunarity = 170.0
	noise.fractal_gain = 2
	for x in range(back_data.get_width()):
		var high = ((noise.get_noise_2d(x, 0)+ 1) * back_data.get_height() * 0.3) + back_data.get_height() * 0.18
		line.append(high)
		for y in range(high):
			back_data.set_pixelv(Vector2(x, y), TRANSPARENT)
	back.texture = ImageTexture.create_from_image(back_data)
