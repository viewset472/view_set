extends Node2D


func _on_button_pressed() -> void:
	print("🔴 触发了：逃跑按钮！")
	Global.is_win = false # 逃跑不算赢
	get_tree().change_scene_to_file("res://world_new.tscn")


func _on_button_2_pressed() -> void:
	print("🟢 触发了：胜利按钮！")
	Global.is_win = true # 打赢了！打勾！
	get_tree().change_scene_to_file("res://world_new.tscn")
