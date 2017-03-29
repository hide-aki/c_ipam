require 'netaddr'

helpers do
	def base_url
		@base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
	end

	def return_err(code, message)
		halt code, { message: message }.to_json
	end

	def json_params
		begin
			JSON.parse(request.body.read)
		rescue
			return_err(400, "Invalid JSON")
		end
	end
end
