extends Node

var loadedRingSounds:Array = [
	load("res://assets/sounds/ring1.wav"),
	load("res://assets/sounds/ring2.wav")
]

enum SFX {
	RING,
}

func playSFX(sfx:String):
	match sfx:
		"ring":
			$Collectables/Ring.stream = loadedRingSounds[randi()%2]
			$Collectables/Ring.play()
		"destroy_badnik":
			$MonitorOrBadnik/Destroy.play()
		"fire_shield":
			$MonitorOrBadnik/FireShield.play()
		"bubble_shield":
			$MonitorOrBadnik/BubbleShield.play()
		"lightning_shield":
			$MonitorOrBadnik/LightningShield.play()
