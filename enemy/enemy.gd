extends KinematicBody2D

var debris = preload("res://enemy/debris.tscn")

var speed = 50
var dir = Vector2(0,-1)

var face_dir = 0
var active_ray = null
var active_ray2 = null

var hp = 10
var attack_time = 0
var attack_status = 0

var attack_var_time_of_attack = 1.1
var attack_var_time_of_get_attack = 1.2

var status = 0
	# 0 - moving
	# 1 - attacking
	# 2 - moving to generator
	# 3 - final attack
var gen_target = Vector2(600,100)

var dead = 0
var kill_timer = 0


var sound_footstep = 0
var sound_time = 0
var sound_delay = 0.5

func _ready():
	sound_footstep = randi() % 3
	add_to_group("enemies")
	set_process(true)
	start_moving()


func _process(delta):
	if status == 0:
		var m = dir * speed * delta
		move(m)
		var o = check_obstacles()
		if o == 1 or o == 2:
			set_attack()
		if o == 3:
			set_attack(1)
		sound_time += delta
		if sound_time > sound_delay:
			sound_time -= sound_delay
			play_footstep()
	if status == 1:
		attack_time -= delta
		if attack_time < 0:
			process_attack()
		if attack_status == 0:
			if attack_time < attack_var_time_of_attack:
				damage_things()
	if status == 2:
		var m = dir * speed * delta
		move(m)
		check_gen_target()
		var o = check_obstacles()
		if o == 1 or o == 2:
			set_attack()
		if o == 3:
			set_attack(1)
		sound_time += delta
		if sound_time > sound_delay:
			sound_time -= sound_delay
			play_footstep()
	if status == 3:
		attack_time -= delta
		if attack_time < 0:
			process_attack_generator()
		if attack_status == 0:
			if attack_time < attack_var_time_of_get_attack:
				damage_generator()
	if status == 99:
		kill_timer -= delta
		if kill_timer < 0:
			queue_free()
	if hp <= 0 and dead == 0:
		killed()

func check_gen_target():
	if face_dir == 0:
		if get_pos().y <= gen_target.y:
			if get_pos().x > gen_target.x:
				face_dir = 1
			else:
				face_dir = 2
			start_moving()
	if face_dir == 1:
		if get_pos().x <= gen_target.x:
			face_dir = 0
			start_moving()
	if face_dir == 2:
		if get_pos().x >= gen_target.x:
			face_dir = 0
			start_moving()

func start_moving():
	if face_dir == 0:
		# walk up
		dir = Vector2(0,-1)
		get_node("AnimationPlayer").play("walk_up")
		active_ray = get_node("rayu")
		active_ray2 = get_node("rayu1")
	if face_dir == 1:
		# walk left
		dir = Vector2(-1,0)
		get_node("AnimationPlayer").play("walk_side")
		active_ray = get_node("rayl")
		active_ray2 = get_node("rayl1")
	if face_dir == 2:
		# walk right
		dir = Vector2(1,0)
		set_scale(Vector2(-1,1))
		get_node("AnimationPlayer").play("walk_side")
		active_ray = get_node("rayl")
		active_ray2 = get_node("rayl1")

func check_obstacles():
	var result = 0
	if active_ray.is_colliding() or active_ray2.is_colliding():
		var o = active_ray.get_collider()
		var o2 = active_ray2.get_collider()
		if o != null:
			#print(o.get_name())
			if o.get_name() == "front":
				result = 1
			elif o.get_name().find("tower") != -1:
				result = 2
			elif o.get_name() == "gen":
				result = 3
			else:
				result = 4
		if o2 != null:
			#print(o2.get_name())
			if o2.get_name() == "front":
				result = 1
			elif o2.get_name().find("tower") != -1:
				result = 2
			elif o2.get_name() == "gen":
				result = 3
			else:
				if result == 0:
					result = 4
	return result



func set_attack(is_gen=0):
	if is_gen:
		status = 3
	else:
		status = 1
	get_node("AnimationPlayer").stop()

func process_attack():
	var o = check_obstacles()
	if o == 1 or o == 2:
		attack_time = 2
		attack_status = 0
		if face_dir == 0:
			get_node("AnimationPlayer").play("attack_up")
		else:
			get_node("AnimationPlayer").play("attack_side")
	else:
		set_gen_target()
		status = 2
		start_moving()

func process_attack_generator():
	attack_time = 2
	attack_status = 0
	if face_dir == 0:
		get_node("AnimationPlayer").play("attack_up")
	else:
		get_node("AnimationPlayer").play("attack_side")

func set_gen_target():
	gen_target = global.generator_location
	if face_dir == 0:
		gen_target.y += randf() * 60 - 30
	else:
		gen_target.x += randf() * 100 - 50

func damage_things():
	attack_status = 1
	global.damage_things(get_pos(), face_dir)
	get_node("SamplePlayer").play("h")

func damage_generator():
	attack_status = 1
	global.damage_generator(get_pos(), face_dir)
	get_node("SamplePlayer").play("h")

func fire():
	get_node("zap").set_hidden(false)

func stop_fire():
	get_node("zap").set_hidden(true)


func damage(d):
	hp -= d

func killed():
	var c = 10 + (randi() % 16)
	while c > 0:
		var d = debris.instance()
		d.set_pos(get_pos())
		d.speed = Vector2(randf()*100-50, randf()*100-50)
		d.type = randi() % 8
		d.vpos = -randf() * 64
		get_parent().add_child(d)
		c -= 1
	dead = 1
	kill_timer = 0.2
	status = 99
	set_hidden(true)
	remove_from_group("enemies")

func play_footstep():
	if sound_footstep == 0:
		get_node("SamplePlayer").play("f1")
	elif sound_footstep == 1:
		get_node("SamplePlayer").play("f2")
	else:
		get_node("SamplePlayer").play("f3")

