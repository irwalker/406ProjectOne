require 'sinatra/base'
require 'json'
require 'rest-client'
require 'crack'

#the routes handling class
class MyApp < Sinatra::Base

	post '/nwen406/init/?' do 
		puts request.body
		json = request.body.read
	
	#	json = params[:data]
		puts json
#		json = Crack::JSON.parse(params[:data])
		puts "resource received: #{json}"
		initialisation = Initialisation.new(json)
		initialisation.handle_request
		"the server works"
		#now that we have handled networking stuff, move on to rendering the video
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
		json = @json.to_json
		if json.size == 1 #last on the list
			send_to_host(json,true)
		else
			send_to_host(json,false)
		end
	end

	def send_to_host(json,is_last=false)
		begin
			key = json.keys[0]
			host_info = json[key]
			if is_last == true
				host_address = host_info["orig_server"]
			else
				host_address = key.to_s
			end
			url = "http://#{host_address.to_s}nwen406/init"
			json.delete(key)
			response = RestClient.post(url,:json => json.to_json,:content_type => :json, :accept => :json, :timeout => 5)		
			puts response.code
		rescue Exception => e
			puts e
		end
	end

end

#the actual video rendering stuff
class Rendering
	def initialize(bitrate,resource_location)

	end

	#retrieve the video from the given location
	def get_video

	end

	#buffer the video at the given bitrate
	def buffer

	end
end
