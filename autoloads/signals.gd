extends Node

signal change_screen(old_screen: String, new_screen: String)
signal change_sub_screen(old_screen: String, new_screen: String)

signal change_screen_from_pause(new_screen: String)

signal game_paused()
signal game_resumed()
