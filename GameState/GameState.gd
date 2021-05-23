extends Node2D

signal hero_journey_started()

func start_hero_journey():
	emit_signal("hero_journey_started")
