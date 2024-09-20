extends CharacterBody3D


@export var SPEED = 10.0
@export var JUMP_SPEED = 4.5
@export var JUMP_COMBO = 10
@export var BOUNCE_SPEED = 3.0
@export var GRAVITY_ACCELERATION = 19.8

var current_jump_count = 0
var is_rushing = 0

signal die

func handle_movement() -> Vector3:
	var direction = Vector3.ZERO;
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z += 1
	if Input.is_action_pressed("move_backward"):
		direction.z -= 1
	# handle rush
	self.is_rushing = 1 if Input.is_action_pressed("rush") else 0
	var norm: Vector3 = direction.normalized()
	return norm

func handle_squash() -> bool:
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		# If collide with the ground
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("mob"):
			var collider_mob = collision.get_collider()
			# Only collide at the top half of the mob can be regarded as squash
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				collider_mob.squash()
				return true
			return false
	return false

func _physics_process(delta: float) -> void:
	
	# Get the direction from user inputs
	var dir = handle_movement()
	if dir != Vector3.ZERO:
		# Looking at the direction
		$Pivot.basis = Basis.looking_at(dir) 
	
	var can_jump = is_on_floor() or current_jump_count < JUMP_COMBO
	if is_on_floor():
		current_jump_count = 0
	# handle jump
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y = JUMP_SPEED
		current_jump_count += 1
	
	# Add gravity
	if not is_on_floor():
		velocity.y -= GRAVITY_ACCELERATION * delta
		
	# handle movement
	velocity.x = SPEED * dir.x * (1 + self.is_rushing)
	velocity.z = SPEED * dir.z * (1 + self.is_rushing)
	
	if handle_squash():
		# handle bounce
		velocity.y = BOUNCE_SPEED

	move_and_slide()

func handle_hit() -> void:
	die.emit()
	self.queue_free()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	print("player hit with mob!")
	handle_hit()
