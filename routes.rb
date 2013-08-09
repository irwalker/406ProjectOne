require 'sinatra/base'
require 'json'
require 'rest-client'
require 'crack'

#the routes handling class
class MyApp < Sinatra::Base

	#the only incoming post that I actually have to worry about!
	post '/nwen406/init/?' do 
		json = request.body.read	
		puts "resource received: #{json}"
		initialisation = Initialisation.new(json)
	result = 	initialisation.handle_request
		if result == 'cheers'
			return 'cheers'
		end
		#now that we have handled networking stuff, move on to rendering the video
		render = Render.new(json)
		render.execute
		"the server works"
	end

	#Test method for access
	get '/test' do
		"I can't let you do that Dave"
	end

end

class Initialisation

	def initialize(json)
		@json = json
	end

	def handle_request
		json = Crack::JSON.parse(@json)
		

		if json.empty? #last on the list
			return "cheers"
		else
			send_to_host(json,false)
		end
	end

	def send_to_host(json,is_last=false)
		begin
			key = json.keys[0]
			host_info = json[key]
			if host_info = '54.213.119.20' #list just contains us
				#json.delete(key)
				host_address = host_info["orig_server"]
			else
				#json.delete(key)
				host_address = key.to_s
			end
			json.delete('54.213.119.20') #delete myself from the list
			url = "http://#{host_address.to_s}/nwen406/init"			
			puts "URL #{url}"
			puts "SENDING #{json}"
			request = RestClient.post(url, json.to_json, :content_type => 'application/json', :timeout => '5')
			# request = RestClient::Request.new(
			# 					:method => :post,
			# 					:url => url,
			# 					:content_type => 'application/json',
			# 					:payload => json.to_json.to_s										
			# 				)
			puts request.inspect
			response = request.execute
			puts response.code
		rescue Exception => e
			puts e
		end
	end

end

#the actual video rendering stuff
class Render
	def initialize(json)
		@json = json
	end

	def execute
		json = Crack::JSON.parse(@json)

	end

	#retrieve the video from the given location
	def get_video(url,bitrate)

	end

	#buffer the video at the given bitrate
	def buffer

	end
end
