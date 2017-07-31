extends KinematicBody2D

var is_player = 1

var MOVE_FORCE = 20000.0
var BREAK_FORCE = 80.0

var current_speed = Vector2(0,0)

var charge = 100
var charge_dps = 20
var get_charge_dps = 30

var face_dir = 0
var is_moving = 0

var sound_delay = 0.2
var sound_time = 0

func _ready():
	charge = global.player_max_charge
	set_fixed_process(true)


func _fixed_process(delta):
	update_indicators()
	var mov_vec = Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		mov_vec.x += 1
	if Input.is_action_pressed("ui_left"):
		mov_vec.x -= 1
	if Input.is_action_pressed("ui_up"):
		mov_vec.y -= 1
	if Input.is_action_pressed("ui_down"):
		mov_vec.y += 1
	mov_vec = mov_vec.normalized()
	
	var add_speed = mov_vec * MOVE_FORCE * delta;
	var brake_speed = -(current_speed * BREAK_FORCE * delta);
	current_speed += add_speed + brake_speed
	
	if current_speed.length() < 1:
		current_speed = Vector2(0,0)
	
	var move_vector = current_speed * delta;
	move_vector = move(move_vector)
	
	if is_colliding():
		var n = get_collision_normal()
		move_vector = n.slide(move_vector)
		current_speed = n.slide(current_speed)
		move(move_vector)
	
	if current_speed.length() != 0:
		if is_moving:
			if mov_vec.length() != 0:
				var new_face_dir = 0
				if mov_vec.y > 0:
					new_face_dir = 1
				elif mov_vec.x > 0:
					new_face_dir = 2
				elif mov_vec.x < 0:
					new_face_dir = 3
				if new_face_dir != face_dir:
					face_dir = new_face_dir
					start_run_animation(face_dir)
		else:
			is_moving = 1
			face_dir = 0
			if mov_vec.y > 0:
				face_dir = 1
			elif mov_vec.x > 0:
				face_dir = 2
			elif mov_vec.x < 0:
				face_dir = 3
			start_run_animation(face_dir)
		sound_time -= delta
		if sound_time < 0:
			sound_time += sound_delay
			get_node("SamplePlayer").play("step")
	else:
		if is_moving:
			is_moving = 0
			get_node("AnimationPlayer").stop()
			if face_dir == 0:
				get_node("sp").set_frame(0)
			if face_dir == 1:
				get_node("sp").set_frame(3)
			if face_dir == 2:
				get_node("sp").set_frame(6)
			if face_dir == 3:
				get_node("sp").set_frame(6)

func start_run_animation(fdir):
	get_node("sp").set_scale(Vector2(0.5, 0.5))
	if fdir == 0:
		get_node("AnimationPlayer").play("up")
	if fdir == 1:
		get_node("AnimationPlayer").play("down")
	if fdir == 2:
		get_node("sp").set_scale(Vector2(-0.5, 0.5))
		get_node("AnimationPlayer").play("side")
	if fdir == 3:
		get_node("AnimationPlayer").play("side")


func update_indicators():
	get_node("zap").set_opacity(abs(charge) / global.player_max_charge)
