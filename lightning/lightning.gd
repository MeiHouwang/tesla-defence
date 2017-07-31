extends Node2D

var lseg = preload("res://lightning/lightning_segment.tscn")

var segments = []
var seg_num = 0

var lcolor = Color(0.7,0.9,1,1)

var endpoint = Vector2(800, 500)

var segment_midlen = 20

var thickness = 0.3

func _ready():
	create_segments()

func change():
	remove_segments()
	create_segments()

func create_segments():
	var normal = Vector2(endpoint.y, -endpoint.x).normalized()
	var len = endpoint.length()
	var positions = []
	for i in range(len / segment_midlen):
		positions.append(randf())
	positions.sort()
	
	var Sway = 80.0
	var Jaggedness = 1.0 / Sway
	
	var prevPoint = Vector2(0,0)
	var prevDisplacement = 0
	var prevPos = 0
	for pos in positions:
		var scale = (len * Jaggedness) * (pos - prevPos);
		var envelope = 1
		if pos > 0.95:
			envelope = 20 * (1 - pos)
		var displacement = rand_range(-Sway,Sway);
		displacement -= (displacement - prevDisplacement) * (1 - scale);
		displacement *= envelope;
		
		var point = pos * endpoint + displacement * normal;
		add_segment(prevPoint, point)
		prevPoint = point
		prevDisplacement = displacement
		prevPos = pos
	add_segment(prevPoint, endpoint)

func add_segment(v1, v2):
	var l = lseg.instance()
	l.p1 = v1
	l.p2 = v2
	l.color = lcolor
	l.thickness = thickness
	segments.append(l)
	seg_num += 1
	add_child(l)
	return l

func remove_segments():
	for l in segments:
		remove_child(l)
	segments.clear()
