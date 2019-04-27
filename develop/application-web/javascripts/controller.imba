const URI = 'ws://localhost:3000'

class Application
	prop limit default: 24
	prop socket default: WebSocket.new URI
	prop pagelist
	prop current

	def pages
		Math.ceil @counter / @limit

	def page
		@page || 1

	def page= value
		if @page = value then @socket.send "list: { page } { @limit }"

	def counter
		@counter

	def counter= value
		if @counter != value
			@counter = value
			pages - @limit < @counter && @socket.send "list: { page } { @limit }"

	def getMimeType value
		Promise.new do |resolve, reject|
			window.fetch( URI.replace( 'ws', 'http' ), { method: 'post', body: value } )
				.catch( do |error| reject error )
				.then do |resource| resource.text.then do |response| resolve response

	def createSnipper dataset
		window.fetch( URI.replace( 'ws', 'http' ) + '/insert', { method: 'post', body: JSON.stringify dataset } )
			.catch( do |error| console.log error )
			.then do |resource| resource.text.then do |iD|
				@current = dataset
				window:location:href = "/view/{ iD }"
				Imba.commit

	def initialize
		@socket:onmessage = do|e|
			let dataset = JSON.parse e:data

			if !@counter && !@current && let iD = Number window:location:pathname.split('/').reverse[0] then @socket.send "get: { iD }"

			if dataset isa Number then counter = dataset
			else if Array.isArray dataset then @pagelist = dataset
			else if dataset isa Object then @current = dataset

			Imba.commit

		@socket:onopen = do socket.send "start"

exports.State = Application.new