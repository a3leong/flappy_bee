extends RigidBody2D

@export var jumpForce = 800;
@export var rotationSpeed = PI / 2
@export var rotationalDeadSpeed = PI * 3

signal hit
signal score

var dead = false
var should_reset = false
var start_position = Vector2.ZERO

func _integrate_forces(state):
	if should_reset:
		state.transform.origin = start_position
		should_reset = false

func set_start_position(pos):
	start_position = pos

func start(pos):
	print("Bee started")
	# Need to reset the velocity too
	set_linear_velocity(Vector2.ZERO)
	set_angular_velocity(0)
	rotation = 0
	should_reset = true
	$CollisionShape2D.disabled = false
	dead = false
	set_process_input(true)
	show()
	
func die():
	$CollisionShape2D.disabled = true
	set_process_input(false)
	jump() # Bounce on death
	dead = true
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.animation = "dead"
	set_angular_velocity(rotationalDeadSpeed)
	
func jump():
	$AnimatedSprite2D.animation = "flap"
	$AnimatedSprite2D.play()
	set_linear_velocity(Vector2(0.0, -jumpForce))

func _ready():
	print("Bee on ready")
	hide()

func _process(delta):
	# Process animation frames here based on linear velocity readings
	if (linear_velocity.y < 0 && !dead):
		set_angular_velocity(-rotationSpeed)
	elif (!dead): # If dead don't try to replace the dead sprite
		$AnimatedSprite2D.animation = "neutral"
		set_angular_velocity(rotationSpeed)
	
	# no more turning at a certain angle
	if (!dead && rotation > PI/6 && angular_velocity > 0 ||
		!dead && rotation < -PI/6 && angular_velocity < 0):
		set_angular_velocity(0.0)
		
func _input(event):
	if (event.is_action_pressed("space_bar")):
		jump()
	if (event.is_action_pressed("kill")):
		die()

func _on_body_entered(body):
	hit.emit()
	die()
