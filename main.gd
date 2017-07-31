extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	randomize()
	#full screen
	var options = get_node("/root/options_manager").read_options()
	if(options.has("full_screen")):
		OS.set_window_fullscreen(options.full_screen)
	
	#load first scene
	var global = get_node("/root/global")
	global.load_menu()
	#global.new_game()

