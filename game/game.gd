extends Node

var char_res = preload("res://2DChar/char.tscn")
var char = null
var generator = null

var enemy1 = preload("res://enemy/enemy.tscn")
var puff = preload("res://game/puff.tscn")
var sparks = preload("res://game/sparks.tscn")

var etimer = 100
var time_next = 1.0

var current_level = null
var level_map = {}
var wall_hp = 5
var wall_max_hp = 5

var game_over_time = 0
var game_over_time1 = 3.0
var game_status = 0


var is_charging = 0

func _ready():
	char = char_res.instance()
	global.player = char
	global.game = self
	current_level = get_node("game_field/level_place/level")
	global.generator_location = get_node("game_field/level_place/level/char_place/gen").get_pos() + Vector2(0,32)
	generator = current_level.get_node("char_place/gen")
	fill_level()
	place_char()
	set_process(true)
	#add_enemy(Vector2(0,350), 2)
	#add_enemy(Vector2(780,700), 0)


func load_level(lname):
	pass

func fill_level():
	var tmap = current_level.get_node("front")
	for y in range(22):
		for x in range(38):
			var c = tmap.get_cell(x,y)
			if c == 0 or c == 1:
				var index = x + (y * 1000)
				level_map[index] = [c, wall_hp]
	#print (str(level_map))

func place_char():
	if char != null:
		get_node("game_field/level_place/level/char_place").add_child(char)
		char.set_pos(get_node("game_field/level_place/level/start").get_pos())


func _process(delta):
	etimer += delta
	if etimer > time_next:
		etimer = 0
		time_next = 0.6 + randf()
		if randf() > 0.6:
			add_enemy(Vector2(350 + 550*randf(), 700), 0)
		elif randf() > 0.5:
			add_enemy(Vector2(0,150 + 300*randf()), 2)
		else:
			add_enemy(Vector2(1200,150 + 300*randf()), 1)
	if game_status == 0:
		update_ind()
	elif game_status == 1:
		#game over
		game_over_time += delta
		if game_over_time > game_over_time1:
			game_over_time = game_over_time1
		var a = game_over_time / game_over_time1
		get_node("gameover").set_opacity(a)

func add_enemy(pos, face_dir, etype=0):
	var e = enemy1.instance()
	e.set_pos(pos)
	e.face_dir = face_dir
	if face_dir == 0:
		#up
		pass
	elif face_dir == 1:
		#left
		e.dir = Vector2(-1,0)
	elif face_dir == 2:
		#right
		e.dir = Vector2(1,0)
	get_node("game_field/level_place/level/enemies").add_child(e)


func update_ind():
	if char != null:
		var c = abs(char.charge) / global.player_max_charge
		#get_node("c").set_text(str(char.charge))
		get_node("ind/c").set_region_rect(Rect2(0,256 - 256*c,256,256*c))
		get_node("ind/c").set_pos(Vector2(0,256 - 256*c))

func add_junk(pos, t):
	get_node("game_field/level_place/level/junk").add_junk(pos, t)


func damage_things(epos, face_dir):
	var cellx = int(epos.x) / 32
	var celly = int(epos.y) / 32
	if face_dir == 0:
		damage_hline(cellx, celly-2)
		damage_hline(cellx, celly-3)
	if face_dir == 1:
		damage_vline(cellx-1, celly-1)
	if face_dir == 2:
		damage_vline(cellx+1, celly-1)

func damage_hline(x,y):
	damage_wall(x,y)
	damage_wall(x+1,y)
	damage_wall(x-1,y)

func damage_vline(x,y):
	damage_wall(x,y)
	damage_wall(x,y+1)
	damage_wall(x,y-1)

func damage_wall(x,y):
	var index = x + (y * 1000)
	if index in level_map:
		level_map[index][1] -= 1
		if level_map[index][1] <= 0:
			current_level.get_node("front").set_cell(x,y, 5)
		elif level_map[index][1] < (wall_max_hp * 0.3):
			current_level.get_node("front").set_cell(x,y, 4)
		elif level_map[index][1] < (wall_max_hp * 0.5):
			current_level.get_node("front").set_cell(x,y, 3)
		elif level_map[index][1] < (wall_max_hp * 0.8):
			current_level.get_node("front").set_cell(x,y, 2)
		#print (level_map[index][1])
		var p = puff.instance()
		p.set_pos(Vector2(x*64 + 32, y*64 + 128))
		current_level.get_node("front").add_child(p)
	#level_map[index] = [c, wall_hp]

func damage_generator(epos, face_dir):
	var s = sparks.instance()
	s.f = face_dir
	if face_dir == 0:
		s.set_pos(epos + Vector2(0,-50))
	elif face_dir == 1:
		s.set_pos(epos + Vector2(-40,-40))
	else:
		s.set_pos(epos + Vector2(40,-40))
	get_node("game_field").add_child(s)
	generator.damage()
	if generator.hp <= 0:
		# Game Over
		if game_over_time == 0:
			global.game_over()
			game_status = 1
			game_over_time = 0
			set_process_input(true)

func _input(event):
	if (event.type==InputEvent.KEY):
		if game_status == 1:
			if event.is_action("ui_accept") or event.is_action("ui_cancel"):
				if event.pressed == true:
					global.load_menu()



func update_sound_charging(c):
	if is_charging == 1:
		if c == 0:
			get_node("stream_charge").stop()
			is_charging = 0
	else:
		if c == 1:
			get_node("stream_charge").play()
			is_charging = 1

