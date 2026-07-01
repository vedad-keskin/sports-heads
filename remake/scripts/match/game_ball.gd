extends RigidBody2D
class_name GameBall

signal touched(side: String)

var pu_size: float = 1.0
var pu_bouncy: float = 1.0
var last_touch_side: String = "hero"

func _ready() -> void:
	gravity_scale = 1.0
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	_rebuild_shape()

func notify_touch(side: String) -> void:
	if last_touch_side != side:
		touched.emit(side)
	last_touch_side = side
	if linear_velocity.length() > 200:
		AudioManager.play_sfx("kick")

func _rebuild_shape() -> void:
	for c in get_children():
		if c is CollisionShape2D or c is Polygon2D:
			c.queue_free()
	var r := GameConstants.BALL_RADIUS + pu_size * 5.0
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = r
	col.shape = shape
	add_child(col)
	var vis := Polygon2D.new()
	vis.color = Color.WHITE
	var pts: PackedVector2Array = []
	for i in range(12):
		var a := i * TAU / 12.0
		pts.append(Vector2(cos(a), sin(a)) * r)
	vis.polygon = pts
	add_child(vis)
	var mat := PhysicsMaterial.new()
	mat.bounce = 0.3 + pu_bouncy * 0.3
	physics_material_override = mat

func reset_ball_props(size_m: float, bounce_m: float) -> void:
	pu_size = size_m
	pu_bouncy = bounce_m
	var pos := global_position
	var vel := linear_velocity
	var ang := angular_velocity
	_rebuild_shape()
	global_position = pos
	linear_velocity = vel
	angular_velocity = ang
