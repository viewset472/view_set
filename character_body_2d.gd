extends CharacterBody2D

const SPEED = 500.0

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow

# 记录影子在场景里原本的位置
var shadow_start_pos: Vector2 

var bounce_time = 0.0

func _ready() -> void:
	# 游戏一开始，记住你刚才手动摆好的影子位置
	shadow_start_pos = shadow.position

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
	
	if velocity.length() > 0:
		bounce_time += delta * 12.0
		
		# 1. 身体果冻效果和上下弹跳
		var bounce_y = 1.0 + sin(bounce_time) * 0.02
		var bounce_x = 1.0 - sin(bounce_time) * 0.02
		sprite.scale = Vector2(bounce_x, bounce_y)
		sprite.position.y = abs(sin(bounce_time)) * -3.0 
		# 主角弹跳
		sprite.position.y = abs(sin(bounce_time)) * -3.0 
# 让影子也跟着微微缩小或变淡（模拟离地越高，影子越淡）
		shadow.modulate.a = 1.0 - (abs(sin(bounce_time)) * 0.2)
		
		# 2. 脚底锚点的左右摇晃
		sprite.rotation = cos(bounce_time) * 0.08
		
		# 3. 影子逻辑（绝不动 Y 轴！）
		# 只有水平移动时，影子才根据惯性稍微偏一点
		shadow.position.x = shadow_start_pos.x - velocity.x * 0.01
		# 确保 Y 永远保持在脚底
		shadow.position.y = shadow_start_pos.y
		
		# 根据移动速度让影子稍微变扁（增加速度感）
		shadow.scale.x = 1.0 - (abs(velocity.x) / SPEED) * 0.05
		shadow.scale.y = 1.0 - (abs(velocity.y) / SPEED) * 0.05
		
	else:
		# 停下来时，平滑恢复到原位
		sprite.scale = sprite.scale.lerp(Vector2(1.0, 1.0), delta * 10.0)
		sprite.position.y = lerp(sprite.position.y, 0.0, delta * 10.0)
		sprite.rotation = lerp(sprite.rotation, 0.0, delta * 10.0)
		
		# 影子平滑归位
		shadow.position.x = lerp(shadow.position.x, shadow_start_pos.x, delta * 10.0)
		shadow.position.y = lerp(shadow.position.y, shadow_start_pos.y, delta * 10.0) 
		shadow.scale = shadow.scale.lerp(Vector2(1.0, 1.0), delta * 10.0)
