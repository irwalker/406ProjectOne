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
		render = Render.new(json)
		result = 	initialisation.handle_request
		if result == 'cheers'
			return 'cheers'
		end
		#now that we have handled networking stuff, move on to rendering the video
		
		render.execute
		"the server works"
	end

	# Handle POST-request (Receive and save the uploaded file)
	post '/nwen406/receive/?' do 
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
 		 return "The file was successfully uploaded!"
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
			puts "HOST INFO #{host_info}"
			if key == '54.213.119.20' #list just contains us
				#json.delete(key)
				puts "LIST ONLY CONTAINS US"
				host_address = host_info["orig_server"]
			else
				#json.delete(key)
				host_address = key.to_s
			end
			puts "HOST ADDRESS #{host_address}"
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

	begin
		json = Crack::JSON.parse(@json)
		key = json.keys[0]
		host_info = json[key]
		file_url = host_info["file_url"]
		bitrate = host_info["bitrate"]

		exec("wget -O file #{file_url}")
		exec("x264 --pass1 --bitrate#{bitrate} -o file_encoded file")
		orig_server = host_info["orig_server"]
		#and finally, upload this file to the orig server
		request = RestClient.post(orig_server+"/nwen406/receive",File.new("file_encoded"), :content_type => 'multipart/form')
		request.execute
		end

	rescue Exception => e
		return "woops lol that failed hard #{3}"
	end

end
