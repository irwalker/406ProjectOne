require 'sinatra/base'
require 'json'
require 'nokogiri'

class MyApp < Sinatra::Base

	get '/nwen406/init' do |json|
		puts "resource received: #{json}"
		"Sup!"
	end

	post '/nwen406/init/?' do 
		json = params[:json]
		puts "resource received: #{json}"
		"Sup!"
	end

	get '/' do
		"Hello World"
	end

end


 class Initialisation

 	def initialize(json)
 		@json = json
 	end

 	def handle_request
 		json = Nokogiri::JSON(@json)
 		#work thru it
 		json.each do |key,value|

 		end
 	end

 end
