extends CharacterBody2D

@export_range(1,9) var health = 1
@export_range(0,3) var enemy_class = 0
@export_range(0,3) var hp_enemy = 1
@export var flip_h: bool = false

var tier: int
var death01_sfx = preload("res://assets/sfx/Impact - punch03.wav")
var death02_sfx = preload("res://assets/sfx/Impact - punch05.wav")
var death03_sfx = preload("res://assets/sfx/Impact - Punch09 - Splat.wav")
var cant_kill_sfx = preload("res://assets/sfx/error1.wav")

@onready var bloodstain_scene: PackedScene = preload("res://scenes/vfx/bloodstain.tscn")
@onready var health_label = $Sprite/HealthLabel
@onready var sprite = $Sprite
@onready var emitter = get_parent().get_parent().get_node("Player")
@onready var animation = $Animation
@onready var tile_map = get_parent().get_parent().get_node("TileMap")
@onready var death_sfx = $DeathSFX
@onready var damage_number = $DamageNumber


func get_damage(player_state, player_health, player_tier):
	death_sfx.play()
	
	if player_state == 0:
		#if animationPlayer.is_playing(): return  
		
		animation.play("death")
		await animation.animation_finished
		queue_free()
		
		
	elif player_state == 1:
		#visible = false
		
		#get_damage_from_enemy({"health": player_health, "tier": player_tier})
		GLOBAL.enemies_left -= 1
		
		#await get_tree().create_timer(0.4).timeout
		#visible = true
	
func tier_check2():
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	match enemy_class:
		1:
			atlas_texture.region = Rect2(48, 160, 16, 16)
		2:
			atlas_texture.region = Rect2(64, 160, 16, 16)
		3:
			atlas_texture.region = Rect2(16, 144, 16, 16)
		_:
			print("ENEMY TERMINATED\n")
			atlas_texture.region = Rect2(96, 80, 16, 16)
	
	sprite.texture = atlas_texture
	health_label.text = str(hp_enemy)
	if enemy_class == 1: health_label.add_theme_color_override("font_color", Color("995544"))
	elif enemy_class == 2: health_label.add_theme_color_override("font_color", Color("ccbbcc"))
	elif enemy_class == 3: health_label.add_theme_color_override("font_color", Color("ffff55"))
	else: health_label.add_theme_color_override("font_color", Color("ffffff"))
	
func tier_check():
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	if health >= 1 and health <= 3:
		tier = 1
		
		atlas_texture.region = Rect2(48, 160, 16, 16)
	elif health >= 4 and health <= 6:
		tier = 2
		
		atlas_texture.region = Rect2(64, 160, 16, 16)
	elif health >= 7 and health <= 9:
		if health > 9:
			health = 9
		tier = 3
		
		atlas_texture.region = Rect2(16, 144, 16, 16)

	sprite.texture = atlas_texture
	health_label.text = str(hp_enemy)

func _ready():
	if flip_h:
		flip_h = true
	
	''' Define Health and Tier, Change sprite: '''
	tier_check2()
	
	''' SFX '''
	#if tier == 1: death_sfx.stream = death01_sfx
	#elif tier == 2: death_sfx.stream = death02_sfx
	#elif tier == 3: death_sfx.stream = death03_sfx
	

func get_damage_from_enemy(player_class, hp_player, new_enemy_class, new_hp_enemy, death):
	#DamageNumbers.display_number(hp_enemy, damage_number.global_position)
	DamageNumbers.display_level_text(damage_number.global_position, true)
	
	if !death:
		enemy_class = new_enemy_class
		hp_enemy = new_hp_enemy
	else:
		if enemy_class == 1: Music.play_sfx(death01_sfx)
		if enemy_class == 2: Music.play_sfx(death02_sfx)
		if enemy_class == 3: Music.play_sfx(death03_sfx)
		
		var bloodstain = bloodstain_scene.instantiate()
		bloodstain.position = self.global_position
		get_parent().get_parent().get_node("Enemies").add_child(bloodstain)
		
		queue_free()
	tier_check2()
	
func check_death():
	if health <= 0: queue_free()

func move(direction):
	''' Get current tile Vector2i: '''
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	''' Get target tile Vector2i: '''
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	''' Get data from target ttile: '''
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	global_position = tile_map.map_to_local(target_tile)

func alert_mode():
	''' Movimiento en direcciones random (o algo así) '''
	$Hitbox.monitorable = false
	animation.play("alert_mode")
	var rng = randf()
	
	if rng >= 0 and rng <= 0.25:
		move(Vector2.UP)
	elif rng >= 0.26 and rng <= 0.5:
		move(Vector2.DOWN)
	elif rng >= 0.51 and rng <= 0.75:
		move(Vector2.LEFT)
	elif rng >= 0.76 and rng <= 1.0:
		move(Vector2.RIGHT)

func _process(_delta):
	''' Chequea modo alerta (Game Over)'''
	if GLOBAL.time_left <= 0 and GLOBAL.time:
		await alert_mode()

