namespace '/api/v1' do
		
	get '/addresses' do
		addresses = Address.all
		[:pool_id].each do |filter| 
		  addresses = addresses.send(filter, params[filter]) if params[filter]
		end
		addresses.to_json
	end

	get '/addresses/:id' do |id|
		address = Address.where(id: id).first
    return_err(404, "Address not found") unless address
		address.to_json
	end

  delete '/addresses' do
    params = json_params
    address = Address.where(pool_id: params["pool_id"]).where(cidr: params["cidr"]).first
    address.destroy if address
    status 204
  end

	post '/addresses' do
    params = json_params
    pool = Pool.where(id: params["pool_id"]).first
    return_err(422, "No pools found with the given pool id, please create a pool first.") unless pool

    address = pool.get_next_free_address

		if address.save
      [201, address.to_json]
		else
      [422, address.errors.messages.to_json]
		end
	end

end