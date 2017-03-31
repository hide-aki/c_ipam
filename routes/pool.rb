namespace '/api/v1' do
    
  get '/pools' do
    pools = Pool.all
    [:block_id].each do |filter| 
      pools = pools.send(filter, params[filter]) if params[filter]
    end
    pools.to_json
  end

  get '/pools/:id' do |id|
    pool = Pool.where(id: id).first
    return_err(404, "Pool not found") unless pool
    pool.to_json
  end

  delete '/pools/:id' do |id|
    pool = Pool.where(id: id).first
    pool.destroy if pool
    status 204
  end

  post '/pools' do
    params = json_params
    block = Block.network_view(params["network_view"]).first
    return_err(422, "No blocks found with the given network view, please create a block first.") unless block

    pool = block.get_next_free_pool(24)

    if pool.save
      [201, pool.to_json]
    else
      [422, pool.errors.messages.to_json]
    end
  end

end