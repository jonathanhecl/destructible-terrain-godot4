extends Node

const WIDTH := 1152
const HEIGHT := 648

var collision := []

func init_map(line: Array):
	for x in range(WIDTH):
		collision.append([])
		for y in range(HEIGHT):
			if line[x] > y:
				collision[x].append(false)
			else:
				collision[x].append(true)

func collision_normal(pos: Vector2) -> Vector2:
	if pos.x <= 0:
		return Vector2.RIGHT
	if pos.x >= WIDTH:  
		return Vector2.LEFT
	if pos.y <= 0:
		return Vector2.DOWN
	if pos.y >= HEIGHT:
		return Vector2.UP
	if collision[pos.x][pos.y]:
		return Vector2.ONE
		
	var normal := Vector2.ZERO
	for direction in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var observed_pixel: Vector2 = pos + direction
		if (observed_pixel.x < 0
			or observed_pixel.x >= WIDTH
			or observed_pixel.y < 0
			or observed_pixel.y >= HEIGHT
			or collision[observed_pixel.x][observed_pixel.y]):
			normal += direction * -1
	return normal.normalized()

func explosion(pos: Vector2, radius: int) -> void:
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if Vector2(x, y).length() > radius:
				continue
			var pixel = pos + Vector2(x,y)
			if pixel.x < 0 or pixel.x >= WIDTH:
				continue
			if pixel.y < 0 or pixel.y >= HEIGHT:
				continue
			collision[pixel.x][pixel.y] = false
