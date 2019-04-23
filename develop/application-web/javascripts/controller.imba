
const URI = 'ws://localhost:3000'

class Application
	prop waiting default: true
	prop counter

	def getDataServer params
		Promise.new do |resolve, reject|
			window.fetch( URI, { method: 'POST', body: JSON.stringify params || {} } )
				.catch( do |error| reject error )
				.then do |response| response.text.then do |resource| resolve resource

	def initialize
		@counter = 10

		let socket = WebSocket.new URI
		socket:onmessage = do|e| console.log e
		socket:onopen = do
			console.log "Connection opened"
			socket.send "Yees"

exports.State = Application.new