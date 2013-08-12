require 'nokogiri'
require 'rest-client'
require 'json'

class Client

	def initialize(address)
		@end_point = address
	end

	def main
		json = construct_json
		post(json)
	end

	def test
#		end_point = "http://75.101.238.61:80/test"
		response = RestClient.get(@end_point,:timeout => 5)
		puts response
	end

	def construct_json
		json = {
		:"75.101.238.61:80/" => {
			:file_url => 'http://media.xiph.org/video/firebelly/firebelly-chains-dv.mov',
			:bitrate => '2',
			:orig_server => '54.213.119.20:80/',
			:output_url => ''
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
		@client = Client.new('75.101.238.61:80')
#		@client.test
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
