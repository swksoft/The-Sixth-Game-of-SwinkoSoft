extends Node

var time: bool = false
var trans: bool = false

var time_left: int 
var enemies_left: int
var trans_left: int
var combat_count: int = 0

func calcularResultado(player_class: int, hp_player: int, enemy_class: int , hp_enemy: int) -> Dictionary:
	print("\n ==============================================================")
	print("==== COMABTE #", combat_count + 1, "====")
	print("STATS PLAYER ANTES: [", player_class, ", ", hp_player, "]")
	print("STATS ENEMIGO ANTES: [", enemy_class, ", ", hp_enemy, "]\n")
	
	# Por si las dudas
	var old_player_class = player_class
	var old_enemy_class = enemy_class
	var old_hp_player = hp_player
	var old_hp_enemy = hp_enemy
	
	print(old_hp_player)
	
	var combat_results = {}
	
	''' Verifica quien murió: '''
	# Verificar si alguno de los personajes está muerto
	#if hp_player <= 0:
		#player_class = 0
		#hp_player = 0
	#if hp_enemy <= 0:
	#	enemy_class = 0
	#	hp_enemy = 0
	
	''' Determina quien gana el combate: '''
	# Jugador absorve estadísticas del enemigo si es clase 0 o fantasma:
	if player_class == 0:
		player_class = enemy_class
		hp_player += hp_enemy
		enemy_class = 0
		hp_enemy = 0
		print("Absorción\n")
	# Si ambas clases son iguales:
	elif enemy_class == player_class:
		# El que tenga más HP gana
		if hp_enemy > hp_player:
			hp_enemy -= hp_player
			hp_player = 0
			player_class = 0
			print("Player pierde")
		elif hp_player > hp_enemy:
			hp_player -= hp_enemy
			hp_enemy = 0
			enemy_class = 0
			print("Player gana")
		else:
			print("Empate\n")
			hp_player = 0
			player_class = 0
			hp_enemy = 0
			enemy_class = 0
			
	else:
		print(old_hp_player)
		match enemy_class:
			1: # ESCLAVO
				match player_class:
					2: # CIUDADANO
						hp_player += hp_enemy
						hp_enemy -= old_hp_player
						print("(CASO 1a: Esclavo pierde contra Ciudadano)")
					3: # EMPERADOR
						hp_enemy += hp_player
						hp_player -= old_hp_enemy
						hp_enemy = 0
						enemy_class = 0
						print("(CASO 1b: Esclavo gana contra Emperador)")
					_:
						pass
			2: # CIUDADANO
				match player_class:
					3: # EMPERADOR
						hp_player += hp_enemy
						hp_enemy -= old_hp_player
						print("CASO 2a: Ciudadano pierde contra Emperador")
					1: # ESCLAVO
						hp_enemy += hp_player
						hp_player -= old_hp_enemy
						print("CASO 2b: Ciudadano gana contra Esclavo")
					_:
						pass
			3: # EMPERADOR
				match player_class:
					1: # ESCLAVO
						hp_player += hp_enemy
						hp_enemy -= old_hp_player
						print("CASO 3a: Emperador pierde contra Esclavo")
					2: # CIUDADANO
						
						hp_enemy += hp_player
						hp_player -= old_hp_enemy
						print("CASO 3b: Emperador gana contra Ciudadano")
					_:
						pass

	''' Verifica quien superó el límite de HP (3): '''
	#if hp_enemy > 3:
		#hp_enemy = 0
	#if hp_player > 3:
		#hp_player = 0
	
	# Si el enemigo está en clase 2 o 3 y pierde todos los HP, volver a clase 1 o 2
	# TODO: FALTA HACER QUE SE ACARREE EL DAÑO DEL NIVEL ANTERIOR
	if (enemy_class == 2 || 3) and (hp_enemy <= 0 and old_player_class != 0 and old_hp_player != old_hp_enemy and old_player_class != old_enemy_class):
	#if (enemy_class >= 2 and hp_enemy <= 0 and (old_player_class != 0 and old_hp_player != old_hp_enemy) and old_player_class != old_enemy_class):
		enemy_class -= 1
		hp_enemy = 3 #ESTO EST+A MAL PORQUE NO ACARREA DAÑO
		print("\n === Level Down Enemy \n ")
	
	''' Level Up '''
	if hp_enemy > 3:
		enemy_class += 1
		hp_enemy = 1
		print("\n === Level up Enemy \n ")
	if hp_player > 3:
		player_class += 1
		hp_player = 1
		print("\n === Level up Player\n ")

	#print(player_class)
	#print(hp_player)

	combat_results["player"] = [player_class, hp_player]
	combat_results["enemy"] = [enemy_class, hp_enemy]
	
	print("STATS PLAYER DESPUES: ", combat_results["player"])
	print("STATS ENEMIGO DESPUES: ", combat_results["enemy"], "\n")
	
	combat_count += 1
	
	return combat_results
