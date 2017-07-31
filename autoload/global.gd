extends Node

var player = null
var game = null
var main_node = null
var tower_max_energy = 40
var player_max_charge = 100

var generator_location = Vector2(600, 100)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


#SCENE MANAGEMENT
func new_game():
	mod_scener.fastload("res://game/game.tscn")

func load_menu():
	mod_scener.fastload("res://menu/menu.tscn")
	
func quit():
	get_tree().quit()

func add_junk(pos, t):
	if game != null:
		game.add_junk(pos, t)

func damage_things(epos, f):
	if game != null:
		game.damage_things(epos, f)

func damage_generator(epos, f):
	if game != null:
		game.damage_generator(epos, f)


func game_over():
	print("GAME OVER")



func charging_sound(c):
	if game != null:
		game.update_sound_charging(c)

func tesla_sound(c):
	pass

