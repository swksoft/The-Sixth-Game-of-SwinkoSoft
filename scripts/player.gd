extends Sprite2D

@export_range(0,9) var health = 0

var is_moving = false
var tier = 0

enum State {
	GHOST,
	TRANS,
	ITS_OVER
}

var current_state
var attacking = false

@onready var tile_map = get_parent().get_node("TileMap")
@onready var sprite = $Sprite2D
@onready var raycast = $RayCast2D
@onready var health_label = $Sprite2D/HealthLabel
@onready var attack_sprite = $Sprite2D/AttackSprite
@onready var animation = $AnimationPlayer

func tier_check():
	var atlas_texture = AtlasTexture.new()
	
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	if health <= 0:
		tier = 0
		atlas_texture.region = Rect2(0, 144, 16, 16)
		current_state = State.GHOST
	elif health >= 1 and health <= 3:
		tier = 1
		atlas_texture.region = Rect2(48, 160, 16, 16)
		current_state = State.TRANS
	elif health >= 4 and health <= 6:
		tier = 2
		atlas_texture.region = Rect2(64, 160, 16, 16)
		current_state = State.TRANS
	elif health >= 7:
		if health > 9:
			health = 9
		tier = 3
		atlas_texture.region = Rect2(16, 144, 16, 16)
		current_state = State.TRANS

	sprite.texture = atlas_texture
	health_label.text = str(health)

func _ready():
	''' Define Health and Tier: '''
	tier_check()

func _physics_process(_delta):
	if is_moving == false:
		return
	
	if global_position == sprite.global_position:
		is_moving = false
		return
	
	sprite.global_position = sprite.global_position.move_toward(global_position, 1)

func _process(_delta):
	#print(is_moving)
	if current_state == 2:
		return
	
	if is_moving || attacking:
		return
	
	if current_state == 0 || 1:
		if Input.is_action_pressed("up"):
			move(Vector2.UP)
		elif Input.is_action_pressed("down"):
			move(Vector2.DOWN)
		elif Input.is_action_pressed("left"):
			move(Vector2.LEFT)
		elif Input.is_action_pressed("right"):
			move(Vector2.RIGHT)
		elif Input.is_action_just_pressed("reset"):
			get_tree().reload_current_scene.call_deferred()
	else:
		return
		
func move(direction: Vector2):
	''' Get current tile Vector2i: '''
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	''' Get target tile Vector2i: '''
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#prints(current_tile, target_tile)
	''' Get data from target tile: '''
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	raycast.target_position = direction * 16
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		attacking = true
		
		sprite.global_position = tile_map.map_to_local(target_tile)
		animation.play("Attack")
		await get_tree().create_timer(0.5).timeout
		sprite.global_position = tile_map.map_to_local(current_tile)
		
		attacking = false
		return
	
	# Move Player:
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite.global_position = tile_map.map_to_local(current_tile)
	
	GLOBAL.time_left -= 1

func _on_area_2d_body_entered(body):
	if body.has_method("get_damage"):
		if current_state == 0:
			health += body.health
			body.queue_free()
		else:
			body.get_damage(current_state, health, tier)	
		
		tier_check()
	#if tier == 0:
		#print(raycast.get_collider_shape())
	#	emit_signal("damage", self)

func _on_hud_game_over():
	current_state = 2
