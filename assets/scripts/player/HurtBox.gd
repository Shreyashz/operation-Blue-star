class_name HurtBox extends Area3D


func _ready() -> void:
	connect("area_entered", _on_take_damage)

func _on_take_damage(hitbox:Area3D)-> void:
	if hitbox.has_meta("damage"):
		if owner.has_method("punched"):
			owner.punched(hitbox.get_meta("damage"))
