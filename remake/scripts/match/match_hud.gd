extends Control

@onready var score_label: Label = $ScoreLabel
@onready var timer_label: Label = $TimerLabel
@onready var banner_label: Label = $BannerLabel
@onready var countdown_label: Label = $CountdownLabel

func refresh(hero: int, opp: int, time_left: float, countdown: float, playing: bool, banner: String, banner_t: float) -> void:
	score_label.text = "%d - %d" % [hero, opp]
	if time_left > 9000.0:
		timer_label.text = "∞"
	else:
		timer_label.text = "%d" % int(ceil(time_left))
	if not playing and countdown > 0.0:
		countdown_label.text = str(int(ceil(countdown)))
		countdown_label.visible = true
	else:
		countdown_label.visible = false
	if banner_t > 0.0:
		banner_label.text = banner
		banner_label.visible = true
	else:
		banner_label.visible = false
