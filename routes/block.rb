namespace '/api/v1' do

  get '/blocks' do
    blocks = Block.all
    [:network_view].each do |filter| 
      blocks = blocks.send(filter, params[filter]) if params[filter]
    end
    blocks.to_json
  end

  get '/blocks/:id' do |id|
    block = Block.where(id: id).first
    return_err(404, "Block not found") unless block
    block.to_json
  end

  delete '/blocks/:id' do |id|
    block = Block.where(id: id).first
    block.destroy if block
    status 204
  end

  post '/blocks' do
    block = Block.new(json_params)
    if block.save
      [201, block.to_json]
    else
      [422, block.errors.messages.to_json]
    end
  end

end