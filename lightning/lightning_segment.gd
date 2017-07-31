extends Node2D

var p1 = Vector2(0,0)
var p2 = Vector2(200,200)
var thickness = 1.0
var color = Color(0.8,0.8,1,1)

var tip_start
var tip_end
var segment

func _ready():
	tip_start = get_node("s_tip")
	tip_end = get_node("e_tip")
	segment = get_node("seg")
	update_segment()


func update_segment():
	tip_start.set_modulate(color)
	tip_end.set_modulate(color)
	segment.set_modulate(color)
	
	tip_start.set_pos(p1)
	tip_end.set_pos(p2)
	segment.set_pos(p1)
	
	segment.set_scale(Vector2((p2-p1).length(), thickness))
	tip_start.set_scale(Vector2(1, thickness))
	tip_end.set_scale(Vector2(-1, thickness))
	
	var angle = p1.angle_to_point(p2) + (PI/2.0)
	segment.set_rot(angle)
	tip_start.set_rot(angle)
	tip_end.set_rot(angle)
