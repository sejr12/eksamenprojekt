extends Area2D

# The amount of damage the hazard does
const DAMAGE_AMOUNT = 50

# Called when another body enters the area
func _on_DamageArea_body_entered(body):
	if body.is_in_group("player"):  # Check if the body is the player
		body.take_damage(DAMAGE_AMOUNT)  # Call the take_damage function on the player
