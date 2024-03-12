extends Node2D

#@export var tier: int = 1
@export var health: int = 3

var tier: int

@onready var health_label = $Sprite/HealthLabel
@onready var sprite = $Sprite

func tier_check():
	if health >= 1 and health <= 3:
		tier = 1
	elif health >= 4 and health <= 6:
		tier = 2
	elif health >= 7 and health <= 9:
		tier = 3

func _ready():
	''' Define Health and Tier: '''
	health_label.text = str(health)
	tier_check()
	
	''' Change sprite: '''
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	if tier == 1:
		atlas_texture.region = Rect2(48, 160, 16, 16)
	elif tier == 2:
		atlas_texture.region = Rect2(64, 160, 16, 16)
	elif tier == 3:
		atlas_texture.region = Rect2(16, 144, 16, 16)
	
	sprite.texture = atlas_texture
	
	#print(tier)
	#print(health)
	
	''' Test: '''
	#tier_calculate()
	#get_damage_from_enemy({"health": 5})
	#print(tier)
	#print(health)

func get_damage_from_enemy(enemy):
	var health_substract = health - enemy.health
	if health_substract <= 0: health -= enemy.health
	#elif health_substract <= 2 && enemy.tier == tier: health -= health_substract
	elif health_substract <= 2: health -= health_substract
	elif health_substract <= 5: health += 1
	tier_calculate()

func tier_calculate():
	var health_divided_by_three = health/3
	
	if health_divided_by_three <= 1: tier = 1
	elif health_divided_by_three <= 2: tier = 2
	else: tier = 3

#func _on_collision(area):
	#if area.is_in_group("enemy"):
		#get_damage()

func _on_player_pijers(player):
	player.health = health
	player.tier_check()
	queue_free()
