extends StaticBody2D

var ltn = preload("res://lightning/lightning.tscn")

var charger_l1 = null
var charger_l2 = null
var is_charging = 0
var player_charget_offset =  Vector2(0,-32)
var player_charget_offset2 =  Vector2(0,-64)

var d1
var d2

export var hp = 10.0
export var max_hp = 10.0

func _ready():
	d1 = get_node("d1")
	d2 = get_node("d2")
	update_damage()
	set_process(true)


func _process(delta):
	var ovlp = get_node("charger").get_overlapping_bodies()
	var charging_c = 0
	for b in ovlp:
		if "is_player" in b:
			if b.charge < global.player_max_charge:
				var c = b.get_charge_dps * delta
				b.charge += c
				charging_c = c
			if b.charge > global.player_max_charge:
				b.charge = global.player_max_charge
	update_charging_ltn(charging_c)


func damage():
	hp -= 1
	update_damage()

func update_damage():
	d1.set_opacity(1.0 - (hp / max_hp))
	d2.set_opacity(1.0 - (hp / max_hp))


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

