extends Node

@export var mob_scene: PackedScene;

func _ready() -> void:
	$MobTimer.start();

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate();
	# Use 'get_node("SpawnPath/SpawnLocations");' is also OK.
	# var mob_spawn_loc = get_node("SpawnPath/SpawnLocations");
	var mob_spawn_loc = $SpawnPath/SpawnLocations;
	mob_spawn_loc.progress_ratio = randf();
	
	# Call initialize to set position, orientation and velocity of the mob
	var player_pos = $Player.position;
	mob.initialize(mob_spawn_loc.position, player_pos);
	
	# Add mob scene instance into main scene
	add_child(mob);
	mob.squashed.connect(_on_mob_squashed);


func _on_player_die() -> void:
	print("game over!");
	($UI).set_dead();
	$MobTimer.stop();

func _on_mob_squashed() -> void:
	print("score!");
	($UI).get_score();


func _on_ui_retry_game() -> void:
	get_tree().reload_current_scene();
