extends Node

static var total_award_amount : int = 0

signal on_collectable_award_recieved

func give_pickup_award(collectable_award : int):
	total_award_amount += collectable_award
	on_collectable_award_recieved.emit(total_award_amount)
