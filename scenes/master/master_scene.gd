extends Node2D

const GodotLogoScreen := preload("res://scenes/ui/logo_screen/logo_screen.tscn")
const FishLogoScreen := preload("res://scenes/ui/logo_screen/fishfest_logo.tscn")
const MainMenuScreen := preload("res://scenes/ui/title_screen/menu_screen.tscn")
const Transition := preload("res://scenes/ui/transition/transition.tscn")
const SettingsScreen := preload("res://scenes/ui/options_screen/settings_screen.tscn")
const PlayerSelectScreen := preload("res://scenes/ui/player_select/player_select_screen.tscn")
const GameScene := preload("res://scenes/game/game.tscn")

enum State {None, GodotLogo, FishLogo, MainMenu, PlayerSelect, TournamentScreen, InGame, Settings, Ending}

func _ready():
	transition_state(State.GodotLogo)
	GameMusic.play_track(GameMusic.Track.MainMenu)

func transition_state(state:State):
	if state == State.GodotLogo:
		var scene = GodotLogoScreen.instantiate()
		scene.connect("finished", on_godot_logo_finish.bind(scene))
		add_child(scene)
	elif state == State.FishLogo:
		var scene = FishLogoScreen.instantiate()
		scene.connect("finished", show_main_menu.bind(scene))
		add_child(scene)
	elif state == State.MainMenu:
		GameMusic.play_track(GameMusic.Track.MainMenu)
		var scene = MainMenuScreen.instantiate()
		scene.connect("button_click", on_main_menu_click.bind(scene))
		add_child(scene)

func on_godot_logo_finish(prev_scene):
	transition_state(State.FishLogo)
	prev_scene.queue_free()

func show_main_menu(prev_scene):
	transition_state(State.MainMenu)
	prev_scene.queue_free()

func on_main_menu_click(prev_scene, option):
	var transition = Transition.instantiate()
	transition.connect("ready_for_content", on_ready_for_menu_content.bind(prev_scene, option))
	add_child(transition)

func on_ready_for_menu_content(option, prev_scene):
	if option == MenuScreen.MenuOption.Settings:
		var scene = SettingsScreen.instantiate()
		scene.connect("done", transition_to_main_menu.bind(scene))
		add_child(scene)
		prev_scene.queue_free()
	elif option == MenuScreen.MenuOption.Exhibition or option == MenuScreen.MenuOption.Local1v1:
		var scene = PlayerSelectScreen.instantiate()
		scene.initialize_screen(option)
		scene.connect("back", transition_to_main_menu.bind(scene))
		scene.connect("start_game", transition_to_game.bind(scene))
		add_child(scene)
		prev_scene.queue_free()
	
func transition_to_main_menu(prev_scene):
	var transition = Transition.instantiate()
	transition.connect("ready_for_content", show_main_menu.bind(prev_scene))
	add_child(transition)
	
func transition_to_game(setup, char1, char2, prev_scene):
	var transition = Transition.instantiate()
	transition.connect("ready_for_content", start_game.bind(setup, char1, char2, prev_scene))
	add_child(transition)

func start_game(setup, char1, char2, prev_scene):
	var scene = GameScene.instantiate()
	scene.setup(setup, char1, char2)
	scene.connect("complete", transition_to_main_menu.bind(scene))
	add_child(scene)
	prev_scene.queue_free()
