extends KinematicBody2D

const GRAVITY = 20.0
const WALK_SPEED = 10
const MAXIMUM_SPEED = 120
const JUMP_STRENGTH=300
onready var animplayer=get_node("Playerdir/Player/AnimationPlayer") 
onready var playerdir=get_node("Playerdir")
var velocity = Vector2()

func _physics_process(delta):
	velocity.y += GRAVITY

	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x-WALK_SPEED, -MAXIMUM_SPEED)
		playerdir.set_scale(Vector2(1,1))
		animplayer.play("run")
		if is_on_floor():
			animplayer.play("run")
		else:
			animplayer.play("jump")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x+WALK_SPEED, +MAXIMUM_SPEED)
		playerdir.set_scale(Vector2(-1,1))
		if is_on_floor():
			animplayer.play("run")
		else:
			animplayer.play("jump")
	else:
		animplayer.play("idle")
		velocity.x = lerp(velocity.x, 0, 0.2)
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			animplayer.play("idle")
			velocity.y -= JUMP_STRENGTH

	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	velocity = move_and_slide(velocity, Vector2(0,-1))
