class_name Player extends Node2D

var character: Character
var direction: Vector2 = Vector2.ZERO

func _enter_tree():
    set_multiplayer_authority(int(str(name)))

@rpc("call_local", "any_peer")
func set_character(character_path: NodePath):
    if get_multiplayer_authority() == multiplayer.get_unique_id():
        print("char node ", character_path)
        character = get_node(character_path)

func _process(_delta):
    if character:
        movement_input()
        action_input()

func action_input():
    if Input.is_action_pressed("action_1"):
        pass

func movement_input():
    var dir = Vector2(
        Input.get_action_strength("right") - Input.get_action_strength("left"),
        Input.get_action_strength("down") - Input.get_action_strength("up"),
    )
    if direction != dir:
        character.set_input_direction.rpc_id(1, dir)
    direction = dir
    
