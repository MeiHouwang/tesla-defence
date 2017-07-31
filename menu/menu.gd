extends Node2D

var selected = 0

var timer = 0
var totime = 1.0

func _ready():
	get_node("StreamPlayer").play()
	set_process_input(true)



func _on_b_options_pressed():
	pass # replace with function body



func _on_HomepageLink_pressed():
	OS.shell_open("http://noro.itch.io")


func _on_start_pressed():
	set_start()
	#global.new_game()



func _on_quit_pressed():
	global.quit()


func set_start():
	timer = 0
	get_node("buttons/Node2D/AnimatedSprite").set_animation("a2")
	set_process(true)


func _process(delta):
	timer += delta
	if timer > totime:
		global.new_game()
		set_process(false)
	get_node("ColorFrame").set_opacity(timer)


func _input(event):
	if (event.type==InputEvent.KEY):
		if event.is_action("ui_up"):
			if event.pressed == true:
				if selected == 1:
					selected = 0
					get_node("buttons/Node2D").set_pos(Vector2(135,45))
					get_node("SamplePlayer").play("b")
		if event.is_action("ui_down"):
			if event.pressed == true:
				if selected == 0:
					selected = 1
					get_node("buttons/Node2D").set_pos(Vector2(135,155))
					get_node("SamplePlayer").play("b")
		if event.is_action("ui_accept"):
			if event.pressed == true:
				if selected == 0:
					get_node("SamplePlayer").play("zap01")
					get_node("buttons/start").set_pressed(true)
					_on_start_pressed()
				else:
					get_node("buttons/quit").set_pressed(true)
					_on_quit_pressed()
