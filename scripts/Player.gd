# Player.gd
# Attach to: Player (CharacterBody2D) in Player.tscn
extends CharacterBody2D

# ----------------------------
# Core Player State
# ----------------------------

@export var max_health: int = 100

var health: int = 100
var score: int = 0

func _ready() -> void:
	# TODO (Week 2): Ensure health starts valid and print debug output
	health = clamp(health, 0, max_health)
	print("[Player] Ready | health=%d/%d score=%d" % [health, max_health, score])

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

	score += points
	print("[Player] Score +%d => %d (Rank: %s)" % [points, score, get_rank(score)])

# ----------------------------
# Optional (for later weeks)
# ----------------------------

func take_damage(amount: int) -> void:
	# TODO (later in the semester): Use this when hazards/enemies are added.
	# Keep it here for now to see how Player-owned state evolves.
	if amount <= 0:
		print("[Player] take_damage ignored (non-positive): ", amount)
		return

	health = max(health - amount, 0)
	print("[Player] Took %d damage => health=%d/%d" % [amount, health, max_health])

	# TODO (later in the semester): When health hits 0, notify GameStateManager (not implemented yet).
	if health == 0:
		print("[Player] Health reached 0 (game over should happen via GameStateManager).")
