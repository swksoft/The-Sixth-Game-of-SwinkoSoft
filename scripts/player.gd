extends Sprite2D

@export_range(0,9) var health = 0

var is_moving = false
var tier = 0
var attacking = false

var current_state
enum State {
	GHOST,
	TRANS,
	ITS_OVER
}

@onready var tile_map = get_parent().get_node("TileMap")
@onready var sprite = $Sprite2D
@onready var raycast = $RayCast2D
@onready var health_label = $Sprite2D/HealthLabel
@onready var attack_sprite = $Sprite2D/AttackSprite
@onready var animation = $AnimationPlayer
@onready var attack_sfx = $AttackSFX
@onready var step_sfx = $StepSFX
@onready var blood_particle = $Sprite2D/BloodParticle

func tier_check():
	var atlas_texture = AtlasTexture.new()
	
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	''' Transforma al personaje de forma '''
	if health <= 0:
		tier = 0
		atlas_texture.region = Rect2(0, 144, 16, 16)
		current_state = State.GHOST
	elif health >= 1 and health <= 3:
		tier = 1
		atlas_texture.region = Rect2(64, 144, 16, 16)
		current_state = State.TRANS
	elif health >= 4 and health <= 6:
		tier = 2
		atlas_texture.region = Rect2(48, 144, 16, 16)
		current_state = State.TRANS
	elif health >= 7:
		if health > 9: health = 9
		tier = 3
		atlas_texture.region = Rect2(32, 144, 16, 16)
		current_state = State.TRANS #rights

	sprite.texture = atlas_texture
	health_label.text = str(health)

func _ready():
	''' Define Health and Tier: '''
	tier_check()

func _physics_process(_delta):
	''' Limita movilidad '''
	if is_moving == false:
		return
		
	if global_position == sprite.global_position:
		is_moving = false
		return
	
	''' Sprite sigue a sprite (animación movimiento) '''
	sprite.global_position = sprite.global_position.move_toward(global_position, 1)

func _process(_delta):
	#print(is_moving)
	''' Estado ITS_OVER para Game Over '''
	if current_state == 2: return
	
	''' No te deja moverte mientras atacas '''
	if is_moving || attacking: return
	
	if current_state == 0 || 1:
		if Input.is_action_pressed("up"): move(Vector2.UP)
		elif Input.is_action_pressed("down"): move(Vector2.DOWN)
		elif Input.is_action_pressed("left"): move(Vector2.LEFT)
		elif Input.is_action_pressed("right"): move(Vector2.RIGHT)
		elif Input.is_action_just_pressed("reset"): TransitionLayer.reset_scene()
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
	
	
	''' IMPORTANTE '''
	if raycast.is_colliding():
		attacking = true
		
		sprite.global_position = tile_map.map_to_local(target_tile)
		animation.play("Attack")
		blood_particle.emitting = true 
		await get_tree().create_timer(0.5).timeout
		sprite.global_position = tile_map.map_to_local(current_tile)
		
		attacking = false
		if health > 0: global_position = tile_map.map_to_local(target_tile)
		return
	
	# Move Player:
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite.global_position = tile_map.map_to_local(current_tile)
	
	GLOBAL.time_left -= 1
	
	step_sfx.play()

func _on_area_2d_body_entered(body):
	if body.has_method("get_damage"):
		if current_state == 0:
			GLOBAL.trans_left -= 1
			health += body.health
			body.get_damage(current_state, health, tier)
		else:
			var enemy_health = body.health
			var enemy_tier = body.tier
			
			GLOBAL.enemies_left -= 1
			
			body.get_damage(current_state, health, tier)
			get_damage_from_enemy({"health": enemy_health, "tier": enemy_tier})
		
		tier_check()
		check_death()
		
		attack_sfx.playing = true

func get_damage_from_enemy(enemy):
	var health_difference = health - enemy.health
	
	print(health_difference)
	
	if health_difference <= 0: health -= enemy.health
	elif health_difference == 1 && enemy.tier == tier: health -= 2
	elif health_difference <= 2: health -= 1
	elif health_difference <= 5: health += 1
	
	tier_check()
	check_death()

func check_death():
	''' Personaje pierde víctima (salud no puede bajar de 0)'''
	if health <= 0:
		''' Regresa a estado GHOST '''
		current_state = State.GHOST
		health = 0

func _on_hud_game_over():
	''' Game Over: cambia a estado ITS_OVER '''
	current_state = 2
