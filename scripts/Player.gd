extends KinematicBody2D

var speed: int = 300
var gravity: int = 1500
var jump: int = 550
var velocity: Vector2 = Vector2()
var push: int = 12
onready var sprite: Sprite = get_node("Sprite")
onready var jump_sound = $jump
onready var death_sound = $death
var sounds = []

func _ready():
	$AnimationPlayer.play("SpriteAnimation")
	sounds.append(preload("res://sounds/phrases/1.wav"))
	sounds.append(preload("res://sounds/phrases/2.wav"))
	sounds.append(preload("res://sounds/phrases/4.wav"))
	sounds.append(preload("res://sounds/phrases/5.wav"))
	sounds.append(preload("res://sounds/phrases/6.wav"))
	sounds.append(preload("res://sounds/phrases/7.wav"))
	sounds.append(preload("res://sounds/phrases/8.wav"))
	play_random_sound()

func play_random_sound():
	sounds.shuffle()
	$phrase.stream = sounds[0]
	$phrase.play()

func _physics_process(delta):
	velocity.x = 0
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= jump
		jump_sound.play()
	
	if Input.is_action_just_released("reset_level"):
		get_tree().reload_current_scene()
		
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
			
	if Input.is_action_just_pressed("give_me_a_corpse"):
		$giveMe.play()
