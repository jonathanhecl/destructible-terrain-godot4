extends Node2D

const GRAVITY = 0.1

var dir: Vector2

func init(_dir: Vector2):
	dir = _dir.normalized() * max(2, _dir.length() * 0.01)
	
func _process(delta):
	$Label.text = str(ceil($Timer.time_left))
	
func _physics_process(delta):
	if $Timer.time_left <= 0:
		return
	dir.y += GRAVITY / max(dir.length(), 1)
	move_granade()
	pass
	
func move_granade():
	var velocity = dir
	while abs(velocity.y) > 0:
		var new_position = position + (Vector2.DOWN * sign(velocity.y) * min(abs(velocity.y), 1.0))
		var normal = get_parent().current_map.collision_normal(new_position)
		velocity.y -= min(1.0, abs(velocity.y)) * sign(velocity.y)
		if normal == Vector2.ONE:
			break
		if sign(normal.y) != 0 and sign(dir.y) != sign(normal.y):
			dir.y *= -0.5
			velocity.y *= -0.5
		if sign(normal.x) != 0 and sign(dir.x) != sign(normal.x):
			dir.x *= -0.8
			velocity.x *= -0.8
		position = new_position
	while abs(velocity.x) > 0:
		var new_position = position + (Vector2.RIGHT * sign(velocity.x) * min(abs(velocity.x), 1.0))
		var normal = get_parent().current_map.collision_normal(new_position)
		velocity.x -= min(1.0, abs(velocity.x)) * sign(velocity.x)
		if normal == Vector2.ONE:
			break
		if sign(normal.y) != 0 and sign(dir.y) != sign(normal.y):
			dir.y *= -0.5
			velocity.y *= -0.5
		if sign(normal.x) != 0 and sign(dir.x) != sign(normal.x):
			dir.x *= -0.8
			velocity.x *= -0.8
		position = new_position
	
func _on_timer_timeout():
	get_parent().current_map.explosion(position, 80)
	self.queue_free()
