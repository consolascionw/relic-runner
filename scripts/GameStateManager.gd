# GameStateManager.gd
# Attach to: a Node named "GameStateManager" in your main/root scene
extends Node

# ----------------------------
# Week 2: Global Game State
# ----------------------------

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER }
var current_state: GameState = GameState.MENU
signal state_changed(old_state: GameState, new_state: GameState)

func _ready() -> void:
	# TODO (Week 2): Print initial state for debugging
	print("[GameStateManager] Ready | state=%s" % state_to_string(current_state))
	debug_test_transitions()
# ----------------------------
# Week 2: State Transitions
# ----------------------------

func change_state(new_state: GameState) -> bool:
	# TODO (Week 2): Implement state transition logic
	# Requirements:
	# - Reject invalid transitions
	# - Print debug output for allowed and rejected transitions
	# - Return true if state change succeeded; false otherwise
	
	if new_state == current_state:
		print("[GameStateManager] change_state ignored (already in %s)" % state_to_string(new_state))
		return false

	if not is_valid_transition(current_state, new_state):
		print("[GameStateManager] INVALID transition: %s -> %s"
			% [state_to_string(current_state), state_to_string(new_state)])
		return false

	var old_state := current_state
	current_state = new_state

	apply_state_effects(current_state)
	state_changed.emit(old_state, new_state)

	print("[GameStateManager] State changed: %s -> %s"
		% [state_to_string(old_state), state_to_string(new_state)])
	return true

func is_valid_transition(from_state: GameState, to_state: GameState) -> bool:
	# TODO (Week 2): Prevent invalid transitions
	# Minimum rules:
	# - Can't pause from MENU
	# - Can't resume from GAME_OVER (GAME_OVER is terminal for now)
	#
	# Suggested model:
	# MENU -> PLAYING
	# PLAYING -> PAUSED or GAME_OVER
	# PAUSED -> PLAYING or GAME_OVER
	# GAME_OVER -> (no transitions)
	
	match from_state:
		GameState.MENU:
			return to_state == GameState.PLAYING
		GameState.PLAYING:
			return to_state == GameState.PAUSED or to_state == GameState.GAME_OVER
		GameState.PAUSED:
			return to_state == GameState.PLAYING or to_state == GameState.GAME_OVER
		GameState.GAME_OVER:
			return false
	return false

func apply_state_effects(state: GameState) -> void:
	# TODO (Week 2): Handle pause side effects
	# Requirement:
	# - When PAUSED, pause the tree
	# - Otherwise, ensure unpaused
	#
	# NOTE: Later weeks may add UI show/hide, scene transitions, etc.
	match state:
		GameState.PAUSED:
			get_tree().paused = true
		_:
			get_tree().paused = false

# ----------------------------
# Debug helpers (Week 2)
# ----------------------------

func state_to_string(state: GameState) -> String:
	match state:
		GameState.MENU:
			return "MENU"
		GameState.PLAYING:
			return "PLAYING"
		GameState.PAUSED:
			return "PAUSED"
		GameState.GAME_OVER:
			return "GAME_OVER"
	return "UNKNOWN"

func debug_test_transitions() -> void:
	# TODO (Week 2): Use this to prove edge cases are handled.
	# Call this from the Remote tab or temporarily from _ready().
	print("=== [GameStateManager] Debug Transition Tests ===")

	current_state = GameState.MENU
	apply_state_effects(current_state)
	print("Start:", state_to_string(current_state))

	print("Try MENU -> PAUSED (should fail): ", change_state(GameState.PAUSED))
	print("Try MENU -> PLAYING (should pass): ", change_state(GameState.PLAYING))
	print("Try PLAYING -> PAUSED (should pass): ", change_state(GameState.PAUSED))
	print("Try PAUSED -> MENU (should fail): ", change_state(GameState.MENU))
	print("Try PAUSED -> PLAYING (should pass): ", change_state(GameState.PLAYING))
	print("Try PLAYING -> GAME_OVER (should pass): ", change_state(GameState.GAME_OVER))
	print("Try GAME_OVER -> PLAYING (should fail): ", change_state(GameState.PLAYING))

	print("=== End Tests ===")
