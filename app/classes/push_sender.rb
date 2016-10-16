class PushSender

	def self.send_push(tokens, data)
		puts "Send push to \"#{tokens.join(", ")}\" with data #{data}"
		fcm = FCM.new(ENV["FCM_API_KEY"])
		options = {}
		options[:data]         = data[:data]         unless data[:data].nil?
		options[:collapse_key] = data[:collapse_key] unless data[:collapse_key].nil?
		response = fcm.send(tokens, options)
		Rails.logger.info "FCM answer: #{response}"
		puts "FCM answer: #{response}"
	end

end