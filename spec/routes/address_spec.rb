# spec/app_spec.rb
require File.expand_path '../../spec_helper.rb', __FILE__
require 'pp'

describe "address route" do

  it "post should automatically assign a next free address" do
    params = {
      "cidr" => "10.0.0.0/8",
      "network_view" => "test",
      "start_address" => 167772160,
      "end_address" => 184549375,
    }
    block = Block.new(params)
    block.save

    params = {
        "cidr" => "10.0.0.0/24",
        "block_id" => block["id"],
        "start_address" => 167772160,
        "end_address" => 167772415
    }
    pool = Pool.new(params)
    pool.save
    
    post "/api/v1/addresses", { "pool_id": pool["id"].to_s }.to_json
    expect(last_response.status).to eq(201)
    new_address = Address.where({cidr: "10.0.0.1"}).first()
    expect(new_address).to be_instance_of(Address)

    post "/api/v1/addresses", { "pool_id": pool["id"].to_s }.to_json
    expect(last_response.status).to eq(201)
    new_address = Address.where({cidr: "10.0.0.2"}).first()
    expect(new_address).to be_instance_of(Address)
  end

end
