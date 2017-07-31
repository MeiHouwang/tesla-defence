extends Node2D

var f = 0

var ttl = 0.5
var time = 0

func _ready():
	if f == 0:
		get_node("p3").set_emitting(true)
		get_node("p4").set_emitting(true)
	elif f == 1:
		get_node("p2").set_emitting(true)
	else:
		get_node("p1").set_emitting(true)
	set_process(true)


func _process(delta):
	time += delta
	if time > ttl:
		queue_free()

