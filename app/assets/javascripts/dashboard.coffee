$(document).ready ->
	$('#show-upload').click ->
	  if $('#file-upload').length > 0
	  	$('#file-upload').toggleClass 'active'

	$('#show-feedback').click ->
	  if $('#feedback').length > 0
	  	$('#feedback').toggleClass 'active'