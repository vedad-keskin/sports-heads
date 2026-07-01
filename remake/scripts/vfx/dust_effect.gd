extends Node2D
class_name DustEffect

static func spawn(parent: Node2D, pos: Vector2, color: Color = Color(0.8, 0.75, 0.5, 0.6)) -> void:
	var p := Polygon2D.new()
	p.color = color
	p.polygon = PackedVector2Array([
		Vector2(-4, 0), Vector2(0, -3), Vector2(4, 0), Vector2(0, 3)
	])
	p.global_position = pos
	p.z_index = 5
	parent.add_child(p)
	var tw := parent.create_tween()
	tw.tween_property(p, "modulate:a", 0.0, 0.4)
	tw.tween_callback(p.queue_free)
