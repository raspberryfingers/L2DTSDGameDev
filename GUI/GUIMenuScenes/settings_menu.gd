extends CanvasLayer

@onready var window_mode_option_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowModeOptionButton
@onready var resolution_mode_option_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResolutionModeOptionButton2

var window_modes : Dictionary = {"Fullscreen" : DisplayServer.WINDOW_MODE_FULLSCREEN,
								 "Window" : DisplayServer.WINDOW_MODE_WINDOWED,
								 "Window Maximised" : DisplayServer.WINDOW_MODE_MAXIMIZED }
								
var resolutions : Dictionary = {"320x180 " : Vector2i(320, 180),
								"480x270 " : Vector2i(480, 270),
								"640x360 " : Vector2i(640, 360),
								"854x480 " : Vector2i(640, 360),
								"1280x720 " : Vector2i(1280, 720)}

# Called when the node enters the scene tree for the first time.
func _ready():
	for window_mode in window_modes: 
		window_mode_option_button.add_item(window_mode)
		
	for resolution in resolutions:
		resolution_mode_option_button.add_item(resolution)


func _on_window_mode_option_button_item_selected(index):
	var window_mode = window_modes.get(window_mode_option_button.get_item_text(index)) as int
	print("window ", window_mode )


func _on_resolution_mode_option_button_2_item_selected(index):
	var resolution = resolutions.get(resolution_mode_option_button.get_item_text(index)) as int 
	print("resolution ", resolution)


func _on_main_menu_button_pressed():
	GameManager.main_menu()
	queue_free()
