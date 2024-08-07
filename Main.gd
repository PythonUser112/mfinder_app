extends Control

onready var ip = $VBoxContainer/IPAddr.text

func _on_SearchWidget_search(name):
	ip = $VBoxContainer/IPAddr.text
	if not name or "/" in name:
		$VBoxContainer/StatusLabel.text = "Gebe einen Namen ein."
		return
	if not ip:
		$VBoxContainer/StatusLabel.text = "Keine IP Adresse angegeben."
		return
	$VBoxContainer/DataContainer.hide()
	$VBoxContainer/HSeparator3.hide()
	$VBoxContainer/StatusLabel.text = "Suche..."
	var url = "http://"+ip+"/"+name.replace(" ", "_")
	var err = $HTTPRequest.request(url)
	if err == ERR_CANT_CONNECT:
		$VBoxContainer/StatusLabel.text = "Fehler: Konnte nicht verbinden. Stelle sicher, dass du im richtigen Netzwerk bist."
	if err == ERR_INVALID_PARAMETER:
		$VBoxContainer/StatusLabel.text = "Name enthält ungültige Zeichen."


func _on_HTTPRequest_request_completed(result, response_code, _headers, body):
	var cont = false
	if result in [HTTPRequest.RESULT_TIMEOUT, HTTPRequest.RESULT_CANT_CONNECT]:
		$VBoxContainer/StatusLabel.text = "Konnte nicht verbinden"
	elif result in [HTTPRequest.RESULT_CANT_RESOLVE, HTTPRequest.RESULT_CONNECTION_ERROR, HTTPRequest.RESULT_NO_RESPONSE] or response_code == 404:
		$VBoxContainer/StatusLabel.text = "IP-Adresse ungültig"
	elif response_code == 400:
		$VBoxContainer/StatusLabel.text = "Person existiert nicht"
		return
	elif response_code != 200:
		$VBoxContainer/StatusLabel.text = "Ein unerwarteter Stauscode ist aufgetreten: %s"%(response_code)
	elif result == HTTPRequest.RESULT_SUCCESS:
		$VBoxContainer/StatusLabel.text = "Suche abgeschlossen"
		cont = true
	else:
		$VBoxContainer/StatusLabel.text = "Ein unerwarteter Fehler ist aufgetreten. Fehler: %s"%(result)
	if not cont:
		return
	$VBoxContainer/DataContainer.show()
	$VBoxContainer/HSeparator3.show()
	var data = body.get_string_from_utf8().split(",")
	var person = data[0]
	data.remove(0)
	var alter = data[0]
	data.remove(0)
	var vorstrafen = ",\n".join(data)
	$VBoxContainer/DataContainer/PersonData.text = "Name: "+person+"\nAlter: "+alter+"\nVorstrafen: "+vorstrafen
