require 'nokogiri'
require 'rest-client'
require 'json'

class Client

	def initialize(address)
		@end_point = address
	end

	def main
	begin
		json = construct_json
		post(json)
	rescue Exception => e
		puts "EXCEPTION #{e}"
	end
	end

	def test
#		end_point = "http://75.101.238.61:80/test"
		response = RestClient.get(@end_point,:timeout => 5)
		puts response
	end

	def upload_test
		puts "DOING UPLOAD TEST FOR 54.213.119.20"
		request = RestClient.post('http://54.213.119.20/nwen406/receive/',:file => File.new('153iainoutput.mov'), :content_type => 'multipart/form-data')

#		request = RestClient.post('http://54.213.119.20/nwen406/receive/',File.new("153iainoutput.mov"), :content_type => 'multipart/form-data')
		response = request.execute
	end

	def construct_json
		json = {
		:"75.101.238.61" => {#dave
	#	:"54.213.134.218" => {#shakib
			:file_url => 'http://media.xiph.org/video/firebelly/firebelly-chains-dv.mov',
			:bitrate => '54',
			:orig_server => '54.213.119.20',
			:output_url => '54.213.119.20/nwen406/receive/'
		},
			:"54.213.119.20" => {#dave	#	:"54.213.134.218" => {#shakib
			:file_url => 'http://media.xiph.org/video/firebelly/firebelly-chains-dv.mov',
			:bitrate => '1',
			:orig_server => '54.213.119.20',
			:output_url => '54.213.119.20/nwen406/receive/'
		},
			:"12.123.456.78" => {#dave
	#	:"54.213.134.218" => {#shakib
			:file_url => 'http://media.xiph.org/video/firebelly/firebelly-chains-dv.mov',
			:bitrate => '2',
			:orig_server => '54.213.119.20',
			:output_url => '54.213.119.20/nwen406/receive/'
		},
			:"54.213.99.254" => {#dave
	#	:"54.213.134.218" => {#shakib
			:file_url => 'http://media.xiph.org/video/firebelly/firebelly-chains-dv.mov',
			:bitrate => '36',
			:orig_server => '54.213.119.20',
			:output_url => '54.213.119.20/nwen406/receive/'
		}
		}
	end

	def post json
		puts json.to_json
                request = RestClient.post(@end_point + "/nwen406/init", json.to_json, :content_type => 'application/json', :timeout => '5')
		response = request.execute
#		response = RestClient.post(@end_point + "/nwen406/init",:json => json.to_json,:content_type => :json, :accept => :json)
		puts response
	end

end

class CommandLineInterface

	def initialize
#		@client = Client.new('54.213.134.218')#shakib
	
		@client = Client.new('75.101.238.61')#david
#		@client.test
		#@client.upload_test
	  await_input
	end

	def await_input
		puts "go?"
		go = STDIN.gets
		on_input
	end

	def on_input
		@client.main
		await_input
	end
end

cli = CommandLineInterface.new
