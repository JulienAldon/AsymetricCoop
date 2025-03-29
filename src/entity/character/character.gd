class_name Character extends Entity

@export var speed: int = 50
@export var camera: Camera2D

var input_direction: Vector2

func _process(_delta):
	camera.enabled = controlled_by == multiplayer.get_unique_id()

@rpc("call_local", "any_peer")
func set_informations(info: Dictionary):
	for key in info:
		if key in self:
			self[key] = info[key]

@rpc("call_local", "any_peer")
func set_input_direction(dir):
	input_direction = dir

func _physics_process(_delta):
	if multiplayer.is_server():
		velocity = velocity.lerp(input_direction.normalized() * speed, 0.5)
		move_and_slide()
