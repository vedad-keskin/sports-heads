extends Control

signal navigate(screen: GameState.Screen)

func _ready() -> void:
	$VBox/Text.text = """CONTROLS

Player 1 (Right): Arrow keys, Up = jump, P = kick
Player 2 (Left): A/D move, W jump, Space kick

Power-ups spawn every ~7 seconds.
Collect by hitting the ball into them.

Timers use real seconds — gameplay is smooth at any FPS.
"""
	$VBox/Back.pressed.connect(func(): navigate.emit(GameState.Screen.MAIN_MENU))
