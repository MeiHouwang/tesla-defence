extends Node2D

var ttl = 1
var time = 0

func _ready():
	set_process(true)


func _process(delta):
	time += delta
	if time > ttl:
		queue_free()

