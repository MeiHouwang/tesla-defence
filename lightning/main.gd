extends Node2D

var ltn = preload("lightning.tscn")
var l
var dtime = 0

func _ready():
	randomize()
	l = ltn.instance()
	l.set_pos(Vector2(100,100))
	l.endpoint = Vector2(700, 400)
	add_child(l)
	
	set_process(true)


func _process(delta):
	dtime += delta
	#l.set_opacity( 1 - dtime)

