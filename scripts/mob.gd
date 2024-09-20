extends CharacterBody3D

@export var MIN_SPEED = 10;
@export var MAX_SPEED = 20;

signal squashed;

# Initialize the status of current mob
func initialize(spawn_point: Vector3, player_pos: Vector3):
	# Set position & orientation
	look_at_from_position(spawn_point, player_pos, Vector3.UP);
	# Randomize the orientation (use y axis)
	rotate_y(randf_range(-PI / 4, PI / 4));
	
	# Randomize initial speed (use the same axis with orientation)
	self.velocity = randi_range(MIN_SPEED, MAX_SPEED) * Vector3.FORWARD;
	self.velocity = self.velocity.rotated(Vector3.UP, self.rotation.y);

func _physics_process(delta: float) -> void:
	move_and_slide();


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("destroyed at: ", self.position);
	self.queue_free();

func squash() -> void:
	self.squashed.emit();
	self.queue_free();
