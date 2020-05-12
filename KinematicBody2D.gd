extends KinematicBody2D

const GRAVITY = 20.0
const WALK_SPEED = 10
const MAXIMUM_SPEED = 120
const JUMP_STRENGTH= 300
onready var playerdir= get_node("Playerdir")
onready var animationTree= $AnimationTree
onready var katana= get_node("Playerdir/Player/leftArm/katana")
var weaponEquipped=false
var velocity = Vector2()

func _physics_process(delta):
	velocity.y += GRAVITY
	if Input.is_action_just_released("equip")&&weaponEquipped:
		weaponEquipped=false
		animationTree.set("parameters/runWithWeapon/blend_amount",0)
		katana.hide()
	elif Input.is_action_just_released("equip")&&!weaponEquipped:
		weaponEquipped=true
		animationTree.set("parameters/runWithWeapon/blend_amount",1)
		katana.show()
	if Input.is_action_pressed("ui_left"):
		animationTree.set("parameters/runIdleJump/blend_amount",-1)
		velocity.x = max(velocity.x-WALK_SPEED, -MAXIMUM_SPEED)
		playerdir.set_scale(Vector2(1,1))
	elif Input.is_action_pressed("ui_right"):
		animationTree.set("parameters/runIdleJump/blend_amount",-1)
		velocity.x = min(velocity.x+WALK_SPEED, +MAXIMUM_SPEED)
		playerdir.set_scale(Vector2(-1,1))
	else:
		animationTree.set("parameters/runIdleJump/blend_amount",0)
		velocity.x = lerp(velocity.x, 0, 0.2)
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= JUMP_STRENGTH
	else:
		animationTree.set("parameters/runIdleJump/blend_amount",1)
	if Input.is_action_just_pressed("attack"):
		animationTree.set("parameters/attack/active",true)
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	velocity = move_and_slide(velocity, Vector2(0,-1))
