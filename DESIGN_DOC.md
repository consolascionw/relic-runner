Why the Game Is the Way It Is
Purpose
This is for design justification. It proves that choices were intentional, not accidental. You may use the provided project brief and design documents as guide.

# Required Sections

# High Concept
Gerson Run is a 2D side-scrolling, level-based running game where the player controls Gerson that must reach a specific distance goal in each level while avoiding hazards, defeating enemies, and collecting power-ups.

# Core Design Pillars
1. Movement-First Gameplay
Movement is the core of Gerson Run. Running, jumping, and dashing are the primary actions.
Enemies, hazards, and collectibles exist to test how well the player moves and reacts, not how complex their inputs are.

2. Readable Danger and Fair Failure
All hazards and enemies are clearly visible and behave consistently.
When the player fails, the cause is obvious (missed jump, mistimed dash, poor positioning), reinforcing learning instead of frustration.

3. defeating enemies is optional. Players who choose to engage enemies are rewarded with collectibles such as health (heart icons) and dash-attack or power‑up collectibles.
This creates meaningful decisions between playing safely or taking risks for stronger rewards.

4. Each level has a clear distance goal (example: 5,000 meters).
This gives structure and progression, preventing the game from feeling endless and providing a clear sense of completion.

# Target Platform and Audience
1. Platform: PC (Windows)
2. Engine: Godot 4.x
3. Audience: Casual to mid‑core players
4. Skill Level: Beginner‑friendly, mastery‑rewarding

# Core Gameplay Loop
Run → Avoid Hazards → Defeat Enemies → Collect Power‑Ups → Reach Distance Goal → Complete Level

Players continuously move forward, react to threats, manage resources, and aim to survive until the required distance is reached.

# Mechanics Overview
Player
1. Automatic forward running
2. Jump
3. Roll
4. Dash with limited used
5. Collectibles(exp: Heart-icon,Power-Ups)

# Enemies
1. Basic ground enemies
2. Enemies that drop collectibles when defeated

Enemy behavior is predictable and simple, increasing difficulty through placement rather than stats.

# Hazards
1. Spikes
2. Gaps
3. Environmental obstacles

Hazards are consistent and visually readable to support fair failure.

# Relics & Collectibles
1. Health (Heart icon)
2. Dash power‑ups
3. Visual and audio feedback on pickup

Collectibles reward skillful movement and enemy engagement.

# Level Design
Teaching Mechanics
Levels introduce mechanics gradually:

1. Safe introduction of a hazard or enemy
2. Simple application of the mechanic
3. Combination with another challenge
4. Clear success test through distance completion

# UI and Feedback
Planned UI elements:
1. Health icon
2. Distance progress meter
3. Dash bar
4. Pause menu
5. Game over screen
6. Level complete screen

# Audio and Game Feel
1. Jump sound
2. Dash sound
3. Roll sound
4. Spawn or Respawn sound
5. Checkpoint sound
6. Collectible sound
7. Enemy defeat sound
8. Level complete sound
9. Game over sound

# Save and Progression
1. Level completion tracking
2. Best distance
3. Audio and accessibility settings

# Accessibility Requirements
At least two accessibility features will be implemented:
1. Adjustable audio levels
2. Simple keyboard controls

Accessibility is treated as part of overall design quality.

# Art and Visual Style
1. Simple 2D cartoon style
2. High contrast between player, enemies, and hazards

# Cut or Changed Features
(To be completed later in development if needed)

# Final Design Note
Gerson Run: Distance Trial focuses on clarity, fairness, and polish rather than feature quantity.
Every system exists to support movement, readability, and player learning. Features that do not serve these goals are intentionally excluded.