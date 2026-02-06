# Player.gd
# Attach to: Player (CharacterBody2D) in Player.tscn
extends CharacterBody2D

# ----------------------------
# Core Player State
# ----------------------------
# 1. Replace your health and score variables with the following variables and export it all. 
# Initial values are up to you:
@onready var _animated_sprite = $AnimatedSprite2D
# Replace AnimatedSprite2D with AnimationPlayer
# if you are using animationplayer
@export var jump_velocity: float = -400.0
@export var speed: float = 200.00
@export var max_health: int = 100
@export var player_name: String = "Dora"
@export var starting_level: int = 1
@export var starting_max_health: int = 100
@export var starting_health: int = 100
@export var starting_score: int = 0
@export var starting_experience: int = 0

# 2. Create constant named XP_PER_LEVEL. Initial value is up to you.
const XP_PER_LEVEL: int = 100

# 3. Create an empty dictionary named stats. 
# This will be our single source of truth from this week onwards.
var stats: Dictionary = {}

# 4. Create an empty array for the player’s inventory (relics). 
# If in your game design, inventory items are different from relics. 
# Then you need to create a separate array for inventory items and relics.
# optional - only if multiple rewards or items
var inventory: Array[String] = []
		
func _process(_delta):
	if Input.is_action_pressed("Right"):
		_animated_sprite.flip_h = false
		_animated_sprite.play("dark-knight-run")

	elif Input.is_action_pressed("Left"):
		_animated_sprite.flip_h = true
		_animated_sprite.play("dark-knight-run")

	elif Input.is_action_pressed("Jump"):
		_animated_sprite.play("dark-knight-jump")

	else:
		_animated_sprite.play("dark-knight-idle")

#var relics_collected: Array[String] = []
func _physics_process(delta):

	# Gravity (para bumagsak)
	if not is_on_floor():
		velocity.y += 1200 * delta


	# Left / Right movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


	# Jump (ONE PRESS only)
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity


	move_and_slide()

func _enforce_four_direction(v: Vector2) -> Vector2:
	if v.x != 0.0 and v.y != 0.0:
		if abs(v.x) >= abs(v.y):
			return Vector2(sign(v.x), 0)
		else:
			return Vector2(0, sign(v.y))
	return v

# optional - only if relics are different from inventory items
# var relics_collected: Array[String] = []

# 5. Create the _initialize_stats() function.
func _initialize_stats():
	stats = {
		"name": player_name,
		"level": max(starting_level, 1),
		"experience": max(starting_experience, 0),
		"max_health": max(starting_max_health, 1),
		"health": 0, #assigned below
		"score": max(starting_score, 0)
	}
	# clamp health after max_health exists
	stats["health"] = clamp(starting_health, 0, int(stats["max_health"]))

# 6. Replace the health variable assignment in your _ready() with a function call to _initialize_stats(). 
# Also adjust print to print data from the dictionary.
func _ready() -> void:
	_initialize_stats()
	print("[Player] Ready | %s | HP=%d/%d | Lvl=%d XP=%d | Score = %d" % [
		stats["name"],
		stats["health"], 
		stats['max_health'],
		stats['level'],
		stats['experience'],
		stats['score']
])
	add_score(-5)
	add_score(10)
	add_score(90)
	add_item("Crystal")
	add_item("Gold coin")
	list_inventory()
	collect_relic("Crystal", 10)
	gain_experience(50)
	display_character()

# 7. Test Player Scene only. (F6) Initial stats should be displayed.
# 8. Keep the utility functions.
# 9. Update add_score to use the dictionary.


# Player.gd --------------------------------------------------------------------

#var health: int = 100
#var score: int = 0
#
#func _ready() -> void:
	## TODO (Week 2): Ensure health starts valid and print debug output
	#health = clamp(health, 0, max_health)
	#print("[Player] Ready | health=%d/%d score=%d" % [health, max_health, score])

# ----------------------------
# Week 2: Utility Functions
# ----------------------------

func calculate_score(base_points: int, time_seconds: float, time_limit: float = 60.0) -> int:
	# TODO (Week 2): Implement score calculation
	# Requirements:
	# - Accept base points + timing info
	# - Return an int score result
	# - Print debug output showing how the result was computed
	#
	# Suggested simple design:
	# - time_bonus = max(time_limit - time_seconds, 0)
	# - total = base_points + int(time_bonus)
	# - Never return negative
	
	var time_bonus: int = 0
	if time_seconds >= 0.0:
		time_bonus = int(max(time_limit - time_seconds, 0.0))

	var total: int = max(base_points + time_bonus, 0)
	print("[Player] calculate_score | base=%d time=%.2f bonus=%d total=%d"
		% [base_points, time_seconds, time_bonus, total])
	return total

func get_rank(value: int) -> String:
	# TODO (Week 2): Implement rank/grade converter
	# Requirements:
	# - Convert an integer score to a rank (String)
	# - Keep thresholds simple and readable
	#
	# Example mapping (edit as you like):
	# 90-100: "A"
	# 80-89: "B"
	# 70-79: "C"
	# 60-69: "D"
	# <60: "F"
	
	if value >= 90:
		return "A"
	elif value >= 80:
		return "B"
	elif value >= 70:
		return "C"
	elif value >= 60:
		return "D"
	else:
		return "F"

# ----------------------------
# Week 2: Basic Score Updates
# ----------------------------

func add_score(points: int) -> void:
	# TODO (Week 2): Update score safely and print debug output
	# Requirements:
	# - Ignore or warn on non-positive input
	# - Update score
	# - Print new score and rank
	
	if points <= 0:
		print("[Player] add_score ignored (non-positive): ", points)
		return

	stats["score"] = int(stats["score"]) + points
	print("[Player] Score + %d => %d (Rank: %s)"
		% [points, stats["score"], get_rank(int(stats["score"]))])
		
# ----------------------------
# Week3: Inventory / Relics (Array)
# ----------------------------

# 10. add the following functions for inventory / relics
func add_item(item: String)  -> void:
	var trimmed := item.strip_edges()
	if trimmed == "":
		print("[Player] add_item ignored (empty item)")
		return
	inventory.append(trimmed)
	print("[Player] Item added: ", trimmed)

func renove_item(item: String) -> void:
	var trimmed := item.strip_edges()
	var idx := inventory.find(trimmed)
	if idx == -1:
		print("[Player] remove_item failed (not found):", trimmed)
		return
	
	inventory.remove_at(idx)
	print("[Player] Item removed:", trimmed)

func clear_inventory() -> void:
	inventory.clear()
	print("[Player] Inventory cleared.")

func has_item(item: String) -> bool:
	return inventory.has(item.strip_edges())

func list_inventory() -> void:
	print("=== [Player] Inventory List ===")
	if inventory.is_empty():
		print("(empty)")
		return
	
	for i in range(inventory.size()):
		print("%d %s" % [i + 1, inventory[i]])

func collect_relic(relic_name: String, points: int = 10) -> void:
	add_item("Relic: " + relic_name)
	add_score(points)
	
# 11. Add the following functions for experience and leveling (Dictionary + Loops)
# ----------------------------
# Experience & Leveling (Dictionary + Loops)
# ----------------------------

func gain_experience(amount: int) -> void:
	if amount <= 0:
		print("[Player] gain_experience ignored (non-positive): ", amount)
		return
		
	stats["experience"] = int(stats['experience']) + amount
	print("[Player] Gained %d XP => XP=%d" % [amount, stats["experience"]])
	
	# Loop practice: level up multiple timesif XP is large
	while int(stats["experience"]) >= XP_PER_LEVEL:
		stats["experience"] = int(stats["experience"]) - XP_PER_LEVEL
		level_up()

func level_up() -> void:
	stats["level"] = int(stats["level"]) + 1
	# Simple growth (tweak later)
	stats["max_health"] = int(stats["max_health"]) + 10
	stats["health"] = int(stats["max_health"]) # full heal
	print("[Player] LEVEL UP! => Level=%d | HP=%d/%d | XP=%d"
	% [stats["level"], stats["health"], stats["max_health"], stats["experience"]])
	

# 12. Add the following for debugging purposes:
# ----------------------------
# Week 3: Debug / Display (Loops & Dictionaries)
# ----------------------------
func display_character() -> void:
	print("=== [Player] Character Sheet ===")
	var ordered_keys: Array[String] = ["name", "level", "experience", "health", "max_health", "score"]
	for key in ordered_keys:
		print("%s: %s" % [key, str(stats[key])])
	list_inventory()
	
func debug_stats_dump() -> void:
	print("=== [Player] Stats Dump ===")
	for key in stats.keys():
		print(key, ":", stats[key])


# ------------------------------------------------------------------------------
func take_damage(amount: int) -> void:
	# TODO (later in the semester): Use this when hazards/enemies are added.
	# Keep it here for now to see how Player-owned state evolves.
	if amount <= 0:
		print("[Player] take_damage ignored (non-positive): ", amount)
		return
	stats["health"] = max(int(stats["score"]) - amount, 0)
	print("[Player] Took %d damage => Health=%d/%d" % [amount, stats["health"], stats["max_health"]])
	
	#health = max(health - amount, 0)
	#print("[Player] Took %d damage => health=%d/%d" % [amount, health, max_health])
#
	## TODO (later in the semester): When health hits 0, notify GameStateManager (not implemented yet).
	#if health == 0:
		#print("[Player] Health reached 0 (game over should happen via GameStateManager).")
