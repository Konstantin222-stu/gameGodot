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
		var knockback_power = 1000
		
		# Добавляем небольшой случайный разброс по X (например, от -0.2 до 0.2)
		var random_factor = randf_range(-0.2, 0.2)
		direction1.x += random_factor
		
		# Нормализуем снова, чтобы сохранить общую силу
		direction1 = direction1.normalized()
		
		body.velocity.x = direction1.x * knockback_power
		body.velocity.y = -abs(direction1.y) * knockback_power
