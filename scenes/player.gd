extends Node2D

var res_granade = preload("res://scenes/granade.tscn")

var jump = 0
var jump_dir = 0
var current_map

func _ready():
	current_map = get_parent().current_map

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var grenade = res_granade.instantiate()
		grenade.position = position + Vector2.UP * 12
		grenade.init(get_global_mouse_position() - global_position + Vector2.UP * 12)
		get_parent().add_child(grenade)

func _physics_process(delta: float) -> void:
	if jump > 0:
		var valid_pos = position
		for dir in [Vector2(jump_dir, 0), Vector2(jump_dir, -1), Vector2(jump_dir, -2), Vector2(jump_dir, -3), Vector2(jump_dir, -4), Vector2(jump_dir, -5)]:
			var pos = (position + dir) 
			if current_map.collision_normal(pos) == Vector2.ZERO:
				valid_pos = pos
		jump -= 0.5
		position = valid_pos
		return
	var walk = jump_dir
	if current_map.collision_normal(position + Vector2.DOWN) != Vector2.ZERO:
		jump_dir = 0
		if Input.is_action_just_pressed("ui_accept"):
			if jump == 0:
				jump_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
				jump = 10
		walk = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var valid_pos = position
	for dir in [Vector2(walk, -3), Vector2(walk, -2), Vector2(walk, -1), Vector2(walk, 0), Vector2(walk, 1), Vector2(walk, 2), Vector2(walk, 3)]:
		var pos = (position + dir) 
		if current_map.collision_normal(pos) == Vector2.ZERO:
			valid_pos = pos
	position = valid_pos
