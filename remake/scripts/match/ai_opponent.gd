extends RefCounted
class_name AiOpponent

const PlayerBody = preload("res://scripts/match/player_body.gd")
const GameBall = preload("res://scripts/match/game_ball.gd")

var ai_level: float = 5.0
var point_timer: float = 0.0
var opp_right_cap: float = 400.0

func update(delta: float, opp: PlayerBody, ball: GameBall, oppxspeed: float) -> float:
	point_timer += delta
	if point_timer < 25.0:
		if point_timer < 8.0:
			opp_right_cap = 400.0
		elif point_timer < 16.0:
			opp_right_cap = 500.0
		elif point_timer < 25.0:
			opp_right_cap = 600.0
	else:
		opp_right_cap = 700.0
	if int(ai_level) % 3 == 0:
		opp_right_cap = 1000.0

	if opp.frozen or opp.bombed:
		return oppxspeed

	var bx := ball.global_position.x
	var ox := opp.global_position.x
	var speed := 30.0 + opp.pu_speed * 20.0
	speed *= 1.0 + ai_level / 20.0

	if bx < ox + 20 and ox > 75 and bx < opp_right_cap:
		oppxspeed -= speed * delta * 60.0
	elif bx > ox + 25 and bx < opp_right_cap:
		oppxspeed += speed * delta * 60.0

	if bx < ox or (bx < ox + 80 and ball.global_position.y < opp.global_position.y - 30 and ball.linear_velocity.x < 0):
		if opp.global_position.y + 20 >= GameConstants.GROUND_Y - 10:
			opp.linear_velocity.y = -175.0 + -40.0 * (ai_level / 10.0) + opp.pu_jump * -50.0

	oppxspeed *= pow(GameConstants.MOVE_FRICTION, delta * 60.0)
	opp.linear_velocity.x = oppxspeed
	opp.linear_velocity.y += 10.0 * delta * 60.0
	return oppxspeed
