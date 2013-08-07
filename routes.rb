require 'sinatra/base'
require 'json'
require 'nokogiri'
require 'rest-client'
require 'crack'

#the routes handling class
class MyApp < Sinatra::Base

	post '/nwen406/init/?' do 
		json = params[:json]
		puts "resource received: #{json}"
		initialisation = Initialisation.new(json)
		initialisation.handle_request
		"the server works"
		#now that we have handled networking stuff, move on to rendering the video
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

	#the class which handles the initial post request, and sending
	#resources to other hosts in the chain
 class Initialisation

 	def initialize(json)
 		@json = json
 	end

 	def handle_request
 		json = Crack::JSON.parse(@json)
 		#work thru it
 		#save my host's information and handle.
 		key = json.keys[0] 	
 		host_information = json[key]
 		if json.size == 1 #this means that we are the last on the ring
 			send_to_host(key,host_information,json,true)
 		elsif json.empty?#empty, this means we are done.
 			return
 		else
 			json.delete(key)#remove the host from the list, and send to next!
 			send_to_host(key,host_information,json) #TODO CHANGE THIS FOR DEPLOYED CODE TO PORT 80 (DEFAULT)
 		end
 	end

 	#Post JSON to the next host in list at /nwen406/init
 	#if post times out
 	#try once more
 	#remove the host from the list
 	#send to the next host
 	def send_to_host(host_address,host_information,json,is_last=false,port=80,max_attempts = 1,attempt_count=0,new_index=0)
 		begin 			
 			if attempt_count > max_attempts
 				#TODO - if we have attempted to reach the host greater than the prescribed number of times,
 				#remove this host from the list and send to the next host. Rinse 'n' repeat
 			end
 			if is_last == true #we are the last! Just send back to the orig server
 				puts "LAST"
 				data = json[host_address]
 				host_address = data["orig_server"]
 				json.clear
 			end
 			puts "HOST ADDRESS #{host_address}"
 			#if json is empty, do nothing. 
 			url = "http://#{host_address.to_s}nwen406/init"	
 			puts "sending to url #{url}"
			response = RestClient.post(url,:json => json.to_json,:content_type => :json, :accept => :json, :timeout => 5)
			puts response.code			
 		rescue Exception => e
 			#exception handling code
 			puts "EXCEPTION RECEIVED"
 			puts e
 		end	
 	end
 	 
 end