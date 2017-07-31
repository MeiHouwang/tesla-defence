extends Node2D

var ltn = preload("res://lightning/lightning.tscn")

var energy = 0
var max_energy = 100

var dps = 10
var battlerange = 400
var is_shooting = 0
var is_overcharged = 0

var firefrom = Vector2(0,0)
var target = null
var lightning = null
var charger_l1 = null
var charger_l2 = null
var is_charging = 0

var ind_timer = 0
var ind_state = 0

const ind_start = 45
const ind_len = 60

var ind_offset = Vector2(0,0)
var player_charget_offset =  Vector2(0,-32)
var player_charget_offset2 =  Vector2(0,-64)

var sound_status = 0
var sound_time = 0

func _ready():
	set_process(true)
	energy = global.tower_max_energy
	max_energy = global.tower_max_energy
	firefrom = get_node("tip").get_global_pos()
	ind_offset = get_node("ind1").get_pos()
	get_node("SamplePlayer").set_default_volume(0.5)


func _process(delta):
	if is_shooting:
		if check_target():
			if energy > 0:
				damage_target(delta)
				update_lightning()
			else:
				energy = 0
				is_shooting = 0
				stop_fire()
			if target.hp <= 0:
				is_shooting = 0
				stop_fire()
		else:
			is_shooting = 0
			stop_fire()
	else:
		if energy > 0:
			target = null
			var target_dist = 99999999
			for e in get_tree().get_nodes_in_group("enemies"):
				var epos = e.get_pos()
				var newdist = firefrom.distance_to(epos)
				if newdist <= battlerange:
					if target == null:
						target = e
						target_dist = newdist
					else:
						if newdist < target_dist:
							target = e
							target_dist = newdist
			if target != null:
				is_shooting = 1
				#print ("Energy left : " + str(energy))
				fire()
	if sound_status == 1:
		if is_shooting:
			sound_time += delta
			if sound_time > 0.32:
				sound_status = 2
				get_node("SamplePlayer").stop_all()
				get_node("SamplePlayer").play("zap03")
	var ovlp = get_node("charger").get_overlapping_bodies()
	var charging_c = 0
	for b in ovlp:
		if "is_player" in b:
			if energy<max_energy and b.charge > 0:
				var c = b.charge_dps * delta
				energy += c
				b.charge -= c
				charging_c = c
	update_indication(delta)
	update_charging_ltn(charging_c)

func check_target():
	if (target.dead):
		return 0
	else:
		return 1

func fire():
	get_node("zap").set_hidden(false)
	target.fire()
	lightning = ltn.instance()
	lightning.set_pos(get_node("tip").get_pos())
	lightning.endpoint = target.get_pos() - get_node("tip").get_global_pos()
	add_child(lightning)
	sound_status = 1
	sound_time = 0
	get_node("SamplePlayer").play("zap02")

func update_lightning():
	lightning.endpoint = target.get_pos() - get_node("tip").get_global_pos()
	lightning.change()

func stop_fire():
	get_node("zap").set_hidden(true)
	target.stop_fire()
	remove_child(lightning)
	lightning = null
	sound_status = 0
	get_node("SamplePlayer").stop_all()

func damage_target(delta):
	var damage = delta * (dps + dps*is_overcharged)
	target.damage(damage)
	energy -= damage

func update_indication(delta):
	ind_timer += delta
	if ind_timer > 0.05:
		ind_timer -= 0.05
		ind_state = (ind_state + 1) % 2
	if ind_state == 0:
		get_node("ind1").set_hidden(true)
		get_node("ind2").set_hidden(false)
	else:
		get_node("ind1").set_hidden(false)
		get_node("ind2").set_hidden(true)
	var p = 1.0 - (energy / max_energy)
	var offset = p * ind_len
	get_node("ind1").set_pos(Vector2(0, (ind_start + offset)*0.5) + ind_offset)
	get_node("ind2").set_pos(Vector2(0, (ind_start + offset)*0.5) + ind_offset)
	get_node("ind1").set_region_rect(Rect2(0,ind_start + offset,128,ind_len - offset))
	get_node("ind2").set_region_rect(Rect2(0,ind_start + offset,128,ind_len - offset))

func update_charging_ltn(c):
	if is_charging:
		if c == 0:
			get_node("c").remove_child(charger_l1)
			charger_l1 = null
			is_charging = 0
			global.charging_sound(is_charging)
		else:
			charger_l1.endpoint = global.player.get_pos() + player_charget_offset - get_node("c").get_global_pos()
			charger_l1.change()
	else:
		if c != 0:
			is_charging = 1
			charger_l1 = ltn.instance()
			charger_l1.segment_midlen = 10
			charger_l1.thickness = 0.2
			charger_l1.lcolor = Color(0.7,1,0.9,1)
			charger_l1.set_pos(Vector2(0,0))
			charger_l1.endpoint = global.player.get_pos() + player_charget_offset - get_node("c").get_global_pos()
			get_node("c").add_child(charger_l1)
			global.charging_sound(is_charging)
	

