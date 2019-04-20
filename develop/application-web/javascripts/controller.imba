
const URI = 'http://localhost:9091'

class Application
	prop waiting default: true
	prop counter

	def getDataServer params
		Promise.new do |resolve, reject|
			window.fetch( URI, { method: 'POST', body: JSON.stringify params || {} } )
				.catch( do |error| reject error )
				.then do |response| response.text.then do |resource| resolve resource

	def initialize
		# @waiting = clearTimeout( @waiting ) || setTimeout( &, 166 ) do getDataServer.then do |response|
		# 	@waiting = !console.log response
		# 	@counter = 10
		# 	Imba.commit
		@counter = 10

exports.State = Application.new