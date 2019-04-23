
const URI = 'ws://localhost:3000'

class Application
	prop limit default: 24
	prop waiting default: true
	prop socket default: WebSocket.new URI
	prop current

	def page
		@page || 1

	def page= value
		if @page = value then @socket.send "list: { page } { @limit }"

	def counter
		@counter

	def counter= value
		if @counter != value &&  @counter = value then @counter >=  ( page - 1 ) * @limit && @counter <  page * @limit && @socket.send "list: { page } { @limit }"

	def current
		@current

	def current= value
		if value then @socket.send "get: { value }"
		else
			@socket.send "list: { page } { @limit }"

	def initialize
		@socket:onmessage = do|e|
			let dataset = JSON.parse e:data
			if dataset isa Number && counter = dataset then Imba.commit
			else if @current = dataset then Imba.commit

		@socket:onopen = do socket.send "start"

exports.State = Application.new