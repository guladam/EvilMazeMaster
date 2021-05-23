extends Node2D

signal snapped_to_target()

export(int) var keyboard_pan_speed = 300
export(int) var mouse_pan_speed = 1
export(float) var min_zoom = 1
export(float) var max_zoom = 2.5
export(float) var zoom_step = 0.1
export(float) var zoom_speed = 50

onready var cam = $Camera2D

var current_zoom = 1
var target_zoom = 1
var target = Vector2.ZERO
var snapping_to_target = false

func _process(delta):
	if !cam.current:
		return

	if target != Vector2.ZERO and snapping_to_target:
		if cam.global_position.distance_to(target) > 1.5:
			cam.global_position = lerp(cam.global_position, target, 2 * delta)
			cam.zoom = lerp(cam.zoom, Vector2(min_zoom, min_zoom), 2 * delta)
		else:
			target = null
			snapping_to_target = false
			cam.current = false
			emit_signal("snapped_to_target")
		return


	if Input.is_action_pressed("down"):
		cam.position.y += keyboard_pan_speed * delta
	if Input.is_action_pressed("up"):
		cam.position.y -= keyboard_pan_speed * delta
	if Input.is_action_pressed("left"):
		cam.position.x -= keyboard_pan_speed * delta
	if Input.is_action_pressed("right"):
		cam.position.x += keyboard_pan_speed * delta
	if current_zoom != target_zoom:
		current_zoom = lerp(current_zoom, target_zoom, zoom_speed * delta)
		cam.zoom = Vector2(current_zoom, current_zoom)


func _input(event):
	if !cam.current or snapping_to_target:
		return
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		cam.position += -event.relative * mouse_pan_speed
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			target_zoom = clamp(cam.zoom.x + zoom_step, min_zoom, max_zoom)
		elif event.button_index == BUTTON_WHEEL_UP:
			target_zoom = clamp(cam.zoom.x - zoom_step, min_zoom, max_zoom)


func snap_to_target(node):
	if !snapping_to_target:
		target = node.global_position - Vector2(cam.offset.x, cam.offset.y)
		snapping_to_target = true
