extends CharacterBody2D

@export_range(1,9) var health = 1

var tier: int

var death01_sfx = preload("res://assets/sfx/Impact - punch03.wav")
var death02_sfx = preload("res://assets/sfx/Impact - punch05.wav")
var death03_sfx = preload("res://assets/sfx/Impact - Punch09 - Splat.wav")

@onready var health_label = $Sprite/HealthLabel
@onready var sprite = $Sprite
@onready var emitter = get_parent().get_parent().get_node("Player")
@onready var animation = $Animation
@onready var tile_map = get_parent().get_parent().get_node("TileMap")
@onready var death_sfx = $DeathSFX

func get_damage(player_state, player_health, player_tier):
	if player_state == 0:
		#if animationPlayer.is_playing(): return  
		if tier == 1:
			death_sfx.stream = death01_sfx
		elif tier == 2:
			death_sfx.stream = death02_sfx
		elif tier == 3:
			death_sfx.stream = death03_sfx
		
		animation.play("death")
		death_sfx.play()
		await animation.animation_finished
		
		queue_free()
		
	elif player_state == 1:
		print("concha")

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
	
	health_label.text = str(health)

func _ready():
	''' Define Health and Tier, Change sprite: '''
	tier_check()
	
	#print(tier)
	#print(health)
	
	#emitter.connect("pijers", _on_player_pijers(player))
	
	''' Test: '''
	#get_damage_from_enemy({"health": 2, "tier": 1})

func get_damage_from_enemy(enemy):
	var health_difference = health - enemy.health
	if health_difference <= 0: health = enemy.health
	elif health_difference <= 0: health -= enemy.health
	elif health_difference == 1 && enemy.tier == tier: health -= 2
	elif health_difference <= 2: health -= 1
	elif health_difference <= 5: health += 1
	tier_calculate()

func tier_calculate():
	var health_divided_by_three = health/3
	
	if health_divided_by_three <= 1: tier = 1
	elif health_divided_by_three <= 2: tier = 2
	else: tier = 3

func move(direction):
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
	
	
		
	global_position = tile_map.map_to_local(target_tile)
	#sprite.global_position = tile_map.map_to_local(current_tile)

func alert_mode():
	animation.play("alert_mode")
	var rng = randf()
	
	if rng >= 0 and rng <= 0.25:
		await move(Vector2.UP)
	elif rng >= 0.26 and rng <= 0.5:
		await move(Vector2.DOWN)
	elif rng >= 0.51 and rng <= 0.75:
		await move(Vector2.LEFT)
	elif rng >= 0.76 and rng <= 1.0:
		await move(Vector2.RIGHT)
		

func _process(delta):
	if GLOBAL.time_left <= 0:
		await alert_mode()

#func _on_collision(area):
	#if area.is_in_group("enemy"):
		#get_damage()

#func _on_player_damage(player):
#	player.health = health
#	player.tier_check()

