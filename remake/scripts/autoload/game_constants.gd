extends Node
## Flash @ 30fps frame counts converted to seconds for delta-time timers.

const VIEWPORT_SIZE := Vector2(800, 540)

# Power-up durations (Flash 200 frames @ 30fps)
const PU_DURATION_SHORT := 6.667
const PU_DURATION_BOMBS := 20.0
const PU_DURATION_BREAK_HERO := 6.667
const PU_DURATION_BREAK_OPP := 13.333
const PU_DURATION_FIRE := 23.333
const PU_DURATION_STREAKER := 33.333
const PU_SPAWN_INTERVAL := 6.667
const PU_FIELD_LIFETIME := 20.0
const PU_COLLECT_RADIUS := 35.0

const MATCH_TIME_SECONDS := 60.0
const WIN_MARGIN_FIRST_TO_SEVEN := 7

# Physics tuning (ported from Flash initLevel / onFrame_game)
const GROUND_Y := 470.0
const HERO_SPAWN := Vector2(600, 440)
const OPP_SPAWN := Vector2(200, 440)
const BALL_SPAWN := Vector2(400, 230)
const HEAD_RADIUS := 20.0
const BALL_RADIUS := 10.0
const MOVE_ACCEL := 50.0
const MOVE_FRICTION := 0.7
const JUMP_IMPULSE := -150.0
const GRAVITY_EXTRA := 5.0

const UPGRADE_COSTS := [750, 500, 500, 500, 1000, 500, 0]
const UPGRADE_MAX := [3, 3, 3, 3, 3, 1, 1]
const UPGRADE_NAMES := ["jump", "rush", "backtrack", "kick", "special", "goal", "bear"]
const WIN_UPGRADE_POINTS := 100
const LOSS_UPGRADE_POINTS := 300
