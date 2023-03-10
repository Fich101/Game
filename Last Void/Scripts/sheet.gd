extends MeshInstance

export var text = ''

var check = true

func read():
	if text:
		if check == true:
			G.root_gui.read_show(text)
	else:
		G.root_gui.read_hide()
