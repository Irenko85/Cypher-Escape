extends KinematicBody2D

var speed: int = 300
var gravity: int = 1500
var jump: int = 550
var velocity: Vector2 = Vector2()
var push: int = 12
onready var sprite: Sprite = get_node("Sprite")



func _ready():
	$AnimationPlayer.play("SpriteAnimation")
	
func _physics_process(delta):
	velocity.x = 0
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= jump
	
	elif Input.is_action_pressed("move_left"):
		velocity.x -= speed
	
	elif Input.is_action_pressed("move_right"):
		velocity.x += speed
	
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
		
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is Block:
			collision.collider.apply_central_impulse(-collision.normal * push)
		if collision.collider is Spikes:
			get_tree().reload_current_scene()
	
	if Input.is_action_pressed("reset_level"):
		get_tree().reload_current_scene()
	
