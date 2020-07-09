extends Control
onready var botao = $botao
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"): #poder sair do jogo
		get_tree().quit()
	if botao.pressed == true:
		get_tree().change_scene("res://scenes/teste.tscn")
