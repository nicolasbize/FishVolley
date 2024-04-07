extends Label

signal click

@export var hover_color : Color
@export var click_color : Color
@export var normal_color : Color

func _ready():
	connect("mouse_entered", on_mouse_hover.bind())
	connect("mouse_exited", on_mouse_exit.bind())
	connect("gui_input", on_gui_input.bind())

func on_mouse_hover():
	set("theme_override_colors/font_color", hover_color)
	GameSounds.play(GameSounds.Sound.MenuNav)
	
func on_mouse_exit():
	set("theme_override_colors/font_color", normal_color)

func on_gui_input(e:InputEvent):
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		GameSounds.play(GameSounds.Sound.MenuSelect)
		emit_signal("click")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
