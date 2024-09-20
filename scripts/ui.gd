extends Control

signal retry_game();

var game_status_label: Label;
var score_label: Label;
var retry_button: Button;

func _ready() -> void:
	self.retry_button = $InfoPanel/MarginContainer/VBoxContainer/retryBtn;
	self.game_status_label = $InfoPanel/MarginContainer/VBoxContainer/PanelGrid/status;
	self.score_label = $InfoPanel/MarginContainer/VBoxContainer/PanelGrid/score;
	self.retry_button.pressed.connect(self._on_retry_button_pressed);

func get_score() -> void:
	var score = int(self.score_label.text);
	self.score_label.text = str(score + 1);

func set_dead() -> void:
	self.game_status_label.text = "Dead";
	self.retry_button.show();

func _on_retry_button_pressed() -> void:
	self.game_status_label.text = "Healthy";
	self.score_label.text = "0";
	self.retry_button.hide();
	self.retry_game.emit();
