extends Node

var time: bool = false
var trans: bool = false

var time_left: int 
var enemies_left: int
var trans_left: int

func calcularResultado(player_class: int, hp_player: int, enemy_class: int , hp_enemy: int) -> Dictionary:
	var combat_results = {}
	
	''' Verifica quien murió: '''
	# Verificar si alguno de los personajes está muerto
	#if hp_player <= 0:
		#player_class = 0
		#hp_player = 0
	if hp_enemy <= 0:
		enemy_class = 0
		hp_enemy = 0
	
	''' Determina quien gana el combate: '''
	# Jugador absorve estadísticas del enemigo si es clase 0 o fantasma:
	if enemy_class == 0:
		player_class = enemy_class
		hp_player += hp_enemy
		hp_enemy = 0
	# Si ambas clases son iguales:
	if enemies_left == player_class:
		# El que tenga más HP gana
		if hp_enemy > hp_player:
			hp_enemy -= hp_player
			hp_player = 0
		elif hp_player > hp_enemy:
			hp_player -= hp_enemy
			hp_enemy = 0
		else:
			hp_enemy = 0
			hp_player = 0
	else:
		match enemy_class:
			1:
				match player_class:
					2:
						hp_player += hp_enemy
					3:
						hp_enemy += hp_player
					_:
						pass
			2:
				match player_class:
					3:
						hp_player += hp_enemy
					1:
						hp_enemy += hp_player
					_:
						pass
			3:
				match player_class:
					1:
						hp_player += hp_enemy
					2:
						hp_enemy += hp_player
					_:
						pass

	''' Verifica quien superó el límite de HP (3): '''
	if hp_enemy > 3:
		hp_enemy = 0
	if hp_player > 3:
		hp_player = 0
	
	# Si el enemigo está en clase 2 o 3 y pierde todos los HP, volver a clase 1 o 2
	# TODO: FALTA HACER QUE SE ACARREE EL DAÑO DEL NIVEL ANTERIOR
	if enemy_class == 2 || 3 and hp_enemy <= 0:
		enemy_class -= 1
		hp_enemy = 3
	
	''' Level Up '''
	if hp_enemy >= 3:
		enemy_class += 1
		hp_enemy = 1
	if hp_player >= 3:
		player_class += 1
		hp_player = 1

	print(player_class)
	print(hp_player)

	combat_results["player"] = [player_class, hp_player]
	combat_results["enemy"] = [enemy_class, hp_enemy]
	
	return combat_results
