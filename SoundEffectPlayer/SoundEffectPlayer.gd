extends AudioStreamPlayer

export(Array, AudioStreamSample) var clips

func play_sound(index):
	if Config.sound_enabled and index < len(clips):
		stream = clips[index]
		play()
