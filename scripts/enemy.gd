extends Node2D

@export_range(1,9) var health = 3

var tier: int

@onready var health_label = $Sprite/HealthLabel
@onready var sprite = $Sprite
@onready var emitter = get_parent().get_node("Player")

func tier_check():
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = load("res://assets/tiles/tilemap_packed.png")
	
	if health >= 1 and health <= 3:
		atlas_texture.region = Rect2(48, 160, 16, 16)
		tier = 1
	elif health >= 4 and health <= 6:
		atlas_texture.region = Rect2(64, 160, 16, 16)
		tier = 2
	elif health >= 7 and health <= 9:
		atlas_texture.region = Rect2(16, 144, 16, 16)
		tier = 3

	sprite.texture = atlas_texture
	
	health_label.text = str(health)

func _ready():
	''' Define Health and Tier, Change sprite: '''
	tier_check()
	
	#print(tier)
	#print(health)
	
	#emitter.connect("pijers", _on_player_pijers(player))
	
	''' Test: '''
	get_damage_from_enemy({"health": 2, "tier": 1})

func get_damage_from_enemy(enemy):
	var health_difference = health - enemy.health
	if health_difference <= 0: health -= enemy.health
	elif health_difference == 1 && enemy.tier == tier: health -= 2
	elif health_difference <= 2: health -= 1
	elif health_difference <= 5: health += 1
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

