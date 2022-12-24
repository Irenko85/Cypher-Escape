extends Area2D

export (String) var scene

func _ready():
	$AnimationPlayer.play("coin")

func _on_Spike_body_entered(body):
	if body.name == 'Player':
		get_tree().change_scene("res://levels/"+scene+".tscn")
