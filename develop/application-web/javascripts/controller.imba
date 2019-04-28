const URI = 'http://localhost:3000'

class Application
	prop limit default: 24
	prop waiting default: true
	prop socket default: WebSocket.new URI.replace( 'http', 'ws' )
	prop pagelist
	prop current
	prop counter

	def pages
		Math.ceil @counter / @limit

	def page
		@page || 1

	def page= value
		currentPage @page = value

	def getMimeType value
		Promise.new do |resolve, reject|
			window.fetch( URI, { method: 'post', body: value } )
				.catch( do |error| reject error )
				.then do |resource| resource.json.then do |response| resolve response

	def createSnipper dataset
		Promise.new do |resolve, reject|
			@waiting = !!window.fetch( URI + '/insert', { method: 'post', body: JSON.stringify dataset } ).catch( do |error| reject error )
				.then do |resource| resource.text.then do |iD|
					if pages == page then page = pages
					if @current = dataset then Imba.commit @waiting = resolve iD

	def currentPage pID
		!!pID && Promise.new do |resolve, reject|
			@waiting = !!window.fetch( "{ URI }/list/{ @limit }/{ pID isa Number ? pID : page }", { method: 'get' } ).catch( do |error| reject error )
				.then do |resource| resource.json.then do |response|
					if @pagelist = response then Imba.commit @waiting = resolve response
					else
						Imba.commit @waiting = @pagelist = resolve response

	def currentSnipper iD
		!!iD && Promise.new do |resolve, reject|
			@waiting = !!window.fetch( "{ URI }/view/{ iD }", { method: 'get' } ).catch( do |error| reject error )
				.then do |resource| resource.json.then do |response|
					if @current = response then Imba.commit @waiting = resolve iD
					else
						Imba.commit @waiting = @current = resolve iD

	def initialize
		@socket:onmessage = do|e|
			if !@counter = Number e:data then Imba.commit @waiting = undefined
			else
				currentPage pages == page, currentSnipper !@current && window:location:pathname.includes('view') && Number window:location:pathname.split('/').reverse[0]

		@socket:onopen = do socket.send "start"

exports.State = Application.new