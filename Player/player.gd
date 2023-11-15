extends Area2D

signal pickup

@export var speed = 350

var can_move = false
var velocity = Vector2.ZERO
var screensize = Vector2.ZERO
var rec_path = false
var path = []

func get_stuck():
	can_move = false
	$ParalyzeTimer.start()


func register_position():
	path.append(position)

func _ready():
	screensize = get_viewport_rect().size
	position = screensize / 2

func _process(delta):
	if can_move:
		var margin = 50
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		position += velocity * speed * delta
		position.x = clamp(position.x, margin, screensize.x - margin)
		position.y = clamp(position.y, margin, screensize.y - margin)
	if rec_path:
		register_position()

func _on_area_entered(area):
	if area.is_in_group("particles"):
		area.picked_up()
		$PickupSound.play()
	elif area.is_in_group("boxes"):
		area.used()
		$JumpSound.play()
	elif area.is_in_group("ghosts"):
		area.touched()
		$CollisionSound.play()
		get_stuck()
	

func _on_paralyze_timer_timeout():
	can_move = true