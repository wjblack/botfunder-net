extends CharacterBody2D

var SPEED = 500

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("le", "ri", "up", "dn")
	if velocity != Vector2.ZERO:
		# We're either rotating or moving
		var del = fposmod((velocity.angle() - rotation) + PI, TAU) - PI
		if abs(del) < 0.0001:
			velocity = velocity.normalized() * SPEED
			move_and_slide()
		elif del > 0.0:
			rotation += delta * 10
			del = fposmod((velocity.angle() - rotation) + PI, TAU) - PI
			if del < 0.0:
				rotation = velocity.angle()
		else:
			rotation -= delta * 10
			del = fposmod((velocity.angle() - rotation) + PI, TAU) - PI
			if del > 0.0:
				rotation = velocity.angle()
