extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var afk_timer = Timer.new()

## Defines the players variables
## To be changed later on
var health = 1
var walk_speed = 1
var up_and_down_speed = 1

## Tracks inactivity
var inactivity_timer = 0.0
const AFK_TIME = 30.0  ## Time in seconds before going AFK
const SUPER_AFK_TIME = 60.0 ## Time in seconds before sitting down
var is_super_afk = false  ## Tracks if "sit down" has been triggered

## Decides where the player goes based on input
## The "left", "right", "up" and "down" inputs are defined in the Project Configurations settings
func get_input(_delta):
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")

	## Check if there's any input
	if left or right or up or down:
		inactivity_timer = 0.0 ## Reset inactivity timer
		is_super_afk = false ## Reset "super afk" status

	## Calculates movement direction through a vector, instead of a single direction
	var movement = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	## Normalizes the vector to ensure diagonal movement is not faster
	if movement != Vector2.ZERO:
		movement = movement.normalized()  ## Keeps the speed consistent for diagonal movement
		animation.play("walk")
	else:
		if inactivity_timer >= AFK_TIME and inactivity_timer < SUPER_AFK_TIME:
			animation.play("afk")
		elif inactivity_timer >= SUPER_AFK_TIME and not is_super_afk:
			animation.play("sit down")
			is_super_afk = true ## Ensures "sit down" is played only once
		else:
			animation.play("idle")

	## Applies movement
	position += movement * walk_speed
	inactivity_timer += _delta ## Increment the inactivity timer

## Kills the player when it doesn't have any lives left
func kills_player():
	if health <= 0:
		queue_free()
		## Could be changed to a death scene I guess
		get_tree().change_scene_to_file("res://start_menu.tscn")

## Switches the players sprite
func _physics_process(_delta):
	get_input(_delta)
	move_and_slide()
	var horizontal_direction = Input.get_axis("left","right")
	
	if horizontal_direction != 0:
		switch_direction(horizontal_direction)

## Flips the sprite, so not to use multiple ones
func switch_direction(horizontal_direction):
	sprite.flip_h = (horizontal_direction == -1)
