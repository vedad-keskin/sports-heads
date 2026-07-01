extends RigidBody2D
class_name PlayerBody

enum Side { HERO, OPP }

@export var side: Side = Side.HERO
@export var head_color: Color = Color.YELLOW

var xspeed: float = 0.0
var frozen: bool = false
var bombed: bool = false
var leg_broken: bool = false
var pu_speed: float = 1.0
var pu_jump: float = 1.0
var head_scale: float = 1.0

var _kick_pressed_prev: bool = false

func _ready() -> void:
	gravity_scale = 1.0
	lock_rotation = true
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = GameConstants.HEAD_RADIUS
	col.shape = shape
	add_child(col)
	var vis := Polygon2D.new()
	vis.color = head_color
	var pts: PackedVector2Array = []
	for i in range(16):
		var a := i * TAU / 16.0
		pts.append(Vector2(cos(a), sin(a)) * GameConstants.HEAD_RADIUS)
	vis.polygon = pts
	add_child(vis)
	contact_monitor = true
	max_contacts_reported = 4

func apply_movement_input(left: bool, right: bool, jump: bool, kick: bool, upgrades: Array, delta: float) -> void:
	if frozen or bombed:
		return
	var rush := float(upgrades[1]) if upgrades.size() > 1 else 0.0
	var back := float(upgrades[2]) if upgrades.size() > 2 else 0.0
	var jump_up := float(upgrades[0]) if upgrades.size() > 0 else 0.0
	var kick_up := float(upgrades[3]) if upgrades.size() > 3 else 0.0

	if left:
		xspeed -= (GameConstants.MOVE_ACCEL + rush * 30.0 + pu_speed * 30.0) * delta * 60.0
	if right:
		if global_position.x < 720:
			xspeed += (GameConstants.MOVE_ACCEL + back * 30.0 + pu_speed * 30.0) * delta * 60.0

	var on_ground := global_position.y >= GameConstants.GROUND_Y - GameConstants.HEAD_RADIUS - 2.0
	if jump and on_ground:
		AudioManager.play_sfx("jump")
		var vy := GameConstants.JUMP_IMPULSE + jump_up * -30.0 + pu_jump * -50.0
		linear_velocity.y = vy

	xspeed *= pow(GameConstants.MOVE_FRICTION, delta * 60.0)
	linear_velocity.x = xspeed
	linear_velocity.y += GameConstants.GRAVITY_EXTRA * delta * 60.0

	_kick_pressed_prev = kick

func set_head_scale(s: float) -> void:
	head_scale = s
	scale = Vector2.ONE * s
