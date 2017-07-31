extends Node2D

var t = preload("res://enemy/junk.png")

var junks = []

class Junklet:
	var pos = Vector2()
	var type = 0

func _ready():
	#var j = Junklet.new()
	#j.type = randi() % 8
	#j.pos = Vector2(randi() % 1200, randi() % 700)
	#junks.append(j)
	pass


func _draw():
	for j in junks:
		draw_texture_rect_region(t, Rect2(j.pos, Vector2(32,32)), Rect2((j.type % 4) * 64,(int(j.type) / 4) * 64,64,64))


func add_junk(pos, t):
	var j = Junklet.new()
	j.type = t
	j.pos = pos
	junks.append(j)
	update()

func clear_junk():
	junks.clear()

