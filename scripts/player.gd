extends Sprite2D

signal enemy_down
signal instant_win

@export_range(0,9) var health = 0
@export_range(0,3) var hp_player = 0
@export_range(0,3) var player_class = 0

var is_moving = false
var tier = 0
var attacking = false
var killed = false
var can_reset = false

var current_state
enum State {
	GHOST,
	TRANS,
	ITS_OVER
}

var cant_kill_sfx = preload("res://assets/sfx/error1.wav")

@onready var tile_map = get_parent().get_node("TileMap")
@onready var sprite = $Sprite2D
#@onready var raycast = $RayCast2D
@onready var raycast = $Sprite2D/RayCast2D

@onready var health_label = $Sprite2D/HealthLabel
@onready var attack_sprite = $Sprite2D/AttackSprite
@onready var animation = $AnimationPlayer
@onready var attack_sfx = $AttackSFX
@onready var step_sfx = $StepSFX
@onready var blood_particle = $Sprite2D/BloodParticle

func tier_check2():
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	match player_class:
		1:
			atlas_texture.region = Rect2(64, 144, 16, 16)
		2:
			atlas_texture.region = Rect2(48, 144, 16, 16)
		3:
			atlas_texture.region = Rect2(32, 144, 16, 16)
		_:
			print("PLAYER ES FANTASMA\n")
			
			atlas_texture.region = Rect2(0, 144, 16, 16)
	
	sprite.texture = atlas_texture
	health_label.text = str(hp_player)
	if player_class == 1: health_label.add_theme_color_override("font_color", Color("995544"))
	elif player_class == 2: health_label.add_theme_color_override("font_color", Color("ccbbcc"))
	elif player_class == 3: health_label.add_theme_color_override("font_color", Color("ffff55"))
	else: health_label.add_theme_color_override("font_color", Color("ffffff"))

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
	#health_label.text = str(health)
	health_label.text = str(hp_player)

func _ready():
	''' Define Health and Tier: '''
	#tier_check()
	tier_check2()

func _physics_process(_delta):
	''' Limita movilidad '''
	if is_moving == false:
		return
		
	if global_position == sprite.global_position:
		is_moving = false
		return
	
	''' Sprite sigue a sprite (animación movimiento) '''
	sprite.global_position = sprite.global_position.move_toward(global_position, 1.5)

func _process(_delta):
	if GLOBAL.during_cutscene:
		return
	
	''' Estado ITS_OVER para Game Over '''
	if current_state == 2: return
	
	''' No te deja moverte mientras atacas '''
	if is_moving || attacking: return
	
	if current_state == 0 || 1:
		if Input.is_action_pressed("up"): move(Vector2.UP)
		elif Input.is_action_pressed("down"): move(Vector2.DOWN)
		elif Input.is_action_pressed("left"): move(Vector2.LEFT)
		elif Input.is_action_pressed("right"): move(Vector2.RIGHT)
	else:
		return

func _input(event):
	if GLOBAL.during_cutscene:
		return

	if event.is_action_pressed("reset") and can_reset:
		can_reset = false
		TransitionLayer.reset_scene()
	elif event.is_action_pressed("next_level") and OS.is_debug_build():
		emit_signal("instant_win")

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
	
	if tile_data == null: return
	
	var is_walkable = tile_data.get_custom_data("walkable")
	var player_is_converted = player_class != 0
	var is_transparent = tile_data.get_custom_data("transparent")
	var is_transparent_and_player_not_converted = is_transparent && !player_is_converted
	var is_restricted = tile_data.get_custom_data("restricted")
	var is_restricted_and_player_converted = player_is_converted && is_restricted
	var is_door_and_same_class = tile_data.get_custom_data("door") == player_class && player_class != 0

	var can_pass = is_walkable || is_transparent_and_player_not_converted || is_door_and_same_class || is_restricted_and_player_converted
	if !can_pass: return
	#if (!tile_data.get_custom_data("transparent") and player_class != 0):
	#	return
	
	raycast.target_position = direction * 16
	raycast.force_raycast_update()
	
	''' IMPORTANTE '''
	if raycast.is_colliding():
		if raycast.get_collider().get_parent().is_in_group("enemy"):
			attacking = true
			
			#global_position = tile_map.map_to_local(target_tile)
			print("white people")
			sprite.global_position = tile_map.map_to_local(target_tile)
			
			animation.play("Attack")
			#blood_particle.emitting = true 
			await get_tree().create_timer(0.5).timeout
			
			sprite.global_position = tile_map.map_to_local(current_tile)
			
			attacking = false
			if health > 0 || killed: 
				global_position = tile_map.map_to_local(target_tile)
				killed = false
			return
	
	# Move Player:
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite.global_position = tile_map.map_to_local(current_tile)
	
	if GLOBAL.time: GLOBAL.time_left -= 1
	
	step_sfx.play()

func _on_area_2d_body_entered(enemy):
	
	if GLOBAL.trans_left <= 0 and player_class == 0:
		Music.play_sfx(cant_kill_sfx)
		return
	else:
		blood_particle.emitting = true 
		attack_sfx.play()
		var combat_results: Dictionary = GLOBAL.calcularResultado(player_class, hp_player, enemy.enemy_class, enemy.hp_enemy)
	
		var death: bool = false
		
		var new_enemy_class = combat_results["enemy"][0]
		var new_hp_enemy = combat_results["enemy"][1]
		
		var new_player_class = combat_results["player"][0]
		var new_hp_player = combat_results["player"][1]
		
		player_class = new_player_class
		hp_player = new_hp_player
		
		#enemy.get_damage_from_enemy(player_class, hp_player)
		
		if new_hp_enemy <= 0 or new_enemy_class <= 0:
			death = true
			killed = true
			emit_signal("enemy_down")
		
		enemy.get_damage_from_enemy(new_player_class, new_hp_player, new_enemy_class, new_hp_enemy, death)
		
		tier_check2()
	
	#print_debug(new_enemy_class)
	#print_debug(new_hp_enemy)

func check_death():
	''' Personaje pierde víctima (salud no puede bajar de 0)'''
	if health <= 0:
		''' Regresa a estado GHOST '''
		current_state = State.GHOST
		health = 0

func _on_hud_game_over():
	''' Game Over: cambia a estado ITS_OVER '''
	current_state = 2

func _on_reset_timer_timeout():
	can_reset = true
