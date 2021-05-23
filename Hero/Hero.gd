extends Area2D

signal point_reached

export(float) var speed
export(String) var starting_anim

onready var ray = $RayCast2D
onready var cam = $Camera2D
onready var tween = $Tween
onready var anim = $AnimationPlayer
onready var stat_tracker = $StatTracker
onready var sound = $SoundEffectPlayer

var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
var can_move = true
var current_point
var last_dir
var interact_anim
var just_interacted = false


func _ready():
	anim.play(starting_anim)


func play_sleep_anim():
	if last_dir:
		anim.play("Sleep" + last_dir.capitalize())
		$ZZZ.visible = true
		$ZZZ/AnimationPlayer.play("Animate")


func add_energy(amount):
	stat_tracker.change_energy(amount)


func add_health(amount):
	stat_tracker.change_health(amount)


func can_move_dir(dir):
	if tween.is_active():
		return false

	if stat_tracker.energy <= 0:
		return false

	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	return !ray.is_colliding()


func move(dir):
	if can_move_dir(dir) and can_move:
		anim.play("Walk" + dir.capitalize())
		move_tween(dir)
		sound.play_sound(0)


func move_tween(dir):
	tween.interpolate_property(self, "position", position, position + inputs[dir] * tile_size,
	speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	last_dir = dir


func move_towards_point(point):
	var direction = (point - position).normalized()
	var dist = position.distance_to(point)
	
	# if the distance is 0, we reached that point
	if dist <= tile_size/2:
		current_point = 0
		if stat_tracker.energy > 0:
			emit_signal("point_reached")
		return
	
	# Four basic directions
	# RIGHT
	if direction.x == 1 and direction.y == 0:
		move("right")
	# LEFT
	elif direction.x == -1 and direction.y == 0:
		move("left")
	# UP
	elif direction.x == 0 and direction.y == -1:
		move("up")
	# DOWN
	elif direction.x == 0 and direction.y == 1:
		move("down")
		
	# Four diagonal directions
	# UP RIGHT
	elif direction.x >= 0.01 and direction.x <= 0.99 and direction.y <= -0.01 and direction.y >= -0.99:
		if abs(direction.y) > abs(direction.x):
			if can_move_dir("up"):
				move("up")
			elif can_move_dir("right"):
				move("right")
		elif can_move_dir("right"):
			move("right")
		else:
			move("up")
	# DOWN RIGHT
	elif direction.x >= 0.01 and direction.x <= 0.99 and direction.y >= 0.01 and direction.y <= 0.99:
		if abs(direction.y) > abs(direction.x):
			if can_move_dir("down"):
				move("down")
			elif can_move_dir("right"):
				move("right")
		elif can_move_dir("right"):
			move("right")
		else:
			move("down")
	# UP LEFT
	elif direction.x <= -0.01 and direction.x >= -0.99 and direction.y <= -0.01 and direction.y >= -0.99:
		if abs(direction.y) > abs(direction.x):
			if can_move_dir("up"):
				move("up")
			elif can_move_dir("left"):
				move("left")
		elif can_move_dir("left"):
			move("left")
		else:
			move("up")
	# DOWN LEFT
	elif direction.x <= -0.01 and direction.x > -0.99 and direction.y >= 0.01 and direction.y < 0.99:
		if abs(direction.y) > abs(direction.x):
			if can_move_dir("down"):
				move("down")
			elif can_move_dir("left"):
				move("left")
		elif can_move_dir("left"):
			move("left")
		else:
			move("down")


func _on_LevelNavigaton_path_modified(path):
	if path:
		if !cam.current:
			cam.current = true
		current_point = path[0]
		move_towards_point(current_point)


func _on_Tween_tween_all_completed():
	stat_tracker.change_energy(-1)
	if just_interacted and interact_anim:
		anim.play(interact_anim)
	elif current_point:
		move_towards_point(current_point)


func _on_StatTracker_energy_lost(energy):
	if energy == 0:
		play_sleep_anim()


func _on_AnimationPlayer_interact_anim_ended():
	just_interacted = false
	if current_point:
		move_towards_point(current_point)


func _on_StatTracker_damaged(health):
	if health == 0:
		can_move = false
		$HeroDead.visible = true
		$HeroDead/AnimationPlayer.play("Animate")


func _on_Hero_endpoint_reached():
		$HeroHappy.visible = true
		$HeroHappy/AnimationPlayer.play("Animate")
