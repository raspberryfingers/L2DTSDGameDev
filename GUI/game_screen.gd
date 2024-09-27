extends CanvasLayer

@onready var collectable_label = $MarginContainer/VBoxContainer/HBoxContainer/Control/CollectableLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	CollectableManager.on_collectable_award_recieved.connect(on_collectable_award_recieved)

func _input(event):
	if event.is_action_pressed("pause"):
		GameManager.pause_game()

func on_collectable_award_recieved(total_award : int): 
	collectable_label.text = str(total_award)
