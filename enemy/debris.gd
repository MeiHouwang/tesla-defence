extends Node2D

var pos
var speed = Vector2(0,0)
var vspeed = -500
var vpos = 0
var g = 2000

var type = 0
var r = Rect2(0,0,64,64)

func _ready():
	r = Rect2((type % 4) * 64,(int(type) / 4) * 64,64,64)
	get_node("Sprite").set_region_rect(r)
	pos = get_pos()
	set_process(true)


func _process(delta):
	vspeed += g * delta
	vpos += vspeed * delta
	pos += speed * delta
	
	set_pos(pos)
	if vspeed > 0:
		if vpos > 0:
			# finish
			vpos = 0
			set_process(false)
			global.add_junk(get_pos(), type)
			queue_free()
	get_node("Sprite").set_pos(Vector2(0,vpos))
