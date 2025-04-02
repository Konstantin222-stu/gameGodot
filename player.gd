extends CharacterBody2D

@export var speed = 200
@export var jump_force = -500
@onready var anim = get_node("AnimatedSprite2D")	
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("player_jump") && is_on_floor():
		anim.play("Jump")
		velocity.y = jump_force
	var direction = Input.get_axis("player_left","player_right")
	if direction:
		velocity.x = direction * speed
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			anim.play("Idle")
	
	if direction == -1:
		anim.flip_h = true
	elif direction == 1 :
		anim.flip_h = false
		
	if velocity.y > 0:
		anim.play("Fall")
		
	move_and_slide()
