extends CharacterBody2D
func _ready() -> void:
# 只要打赢了，不管我叫什么名字，直接死！
	if Global.is_win == true:
		print("✅ 怪物阵亡，成功消失！")
		queue_free()

var speed=100.0
var change_direction_timer=0.0
var current_direction=Vector2.ZERO

var is_fighting = false 

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if is_fighting:
		return #
		
	change_direction_timer -=delta
	if change_direction_timer <= 0:
		var direction = [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN,Vector2.ZERO]
		current_direction =direction.pick_random()
		change_direction_timer = randf_range(1.0,3.0)
		
	velocity =current_direction * speed
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body ==self:
		return
	if body.name == "Player" and not is_fighting:
		is_fighting = true
		
		# 告诉生死簿：“我要去打架了，记住我的名字！”
		Global.current_enemy = self.name 
		Global.is_win = false # 默认进去是没打赢（逃跑）
		
	get_tree().change_scene_to_file.call_deferred("res://battle.tscn")


func _on_tree_exiting() -> void:
	Global.is_win = false # 默认进去是没打赢（逃跑）
