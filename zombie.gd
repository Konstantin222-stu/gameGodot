extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
@export var chase = false
@export var speed = 100
@export var alive = true


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var player = $"../player"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("Walk")
		else:
			velocity.x = 0
			anim.play("Idle")
		if direction.x>0:
			anim.flip_h = true
		elif direction.x<0:
			anim.flip_h = false
	
	
	move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false

func _on_death_body_entered(body: Node2D) -> void:
	
	if body.name == "player":
		body.velocity.y -= 500
		death()

func death():
	alive = false
	anim.play("Die")
	await anim.animation_finished
	queue_free()


func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var direction1 = (body.position - self.position).normalized()
		
