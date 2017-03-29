# spec/app_spec.rb
require File.expand_path '../../spec_helper.rb', __FILE__
require 'pp'

describe "pools route" do

  def create_test_pools(test_ids, block)
    params = {
      "cidr" => "10.0.0.0/24",
      "block_id" => block["id"],
      "start_address" => 167772160,
      "end_address" => 167772415,
    }
    pool = Pool.new(params)
    pool.save
    test_ids.push(pool["id"])

    params = {
      "cidr" => "10.0.1.0/24",
      "block_id" => block["id"],
      "start_address" => 167772416,
      "end_address" => 167772671,
    }
    pool = Pool.new(params)
    pool.save
    test_ids.push(pool["id"])
  end

  it "post should automatically assign a next free /24 pool" do
    params = {
      "cidr" => "10.0.0.0/8",
      "network_view" => "test",
      "start_address" => 167772160,
      "end_address" => 184549375,
    }
    block = Block.new(params)
    block.save

    test_ids = []
    create_test_pools(test_ids, block)

    post "/api/v1/pools", { "network_view": "test" }.to_json
    expect(last_response.status).to eq(201)
    new_pool = Pool.where({cidr: "10.0.2.0/24"}).not_in(:_id => test_ids).first()
    expect(new_pool).to be_instance_of(Pool)

    post "/api/v1/pools", { "network_view": "test" }.to_json
    expect(last_response.status).to eq(201)
    new_pool = Pool.where({cidr: "10.0.3.0/24"}).not_in(:_id => test_ids).first()
    expect(new_pool).to be_instance_of(Pool)
  end

  it "post should automatically assign a free /24 pool from the start of the block" do
    params = {
      "cidr" => "10.0.0.0/8",
      "network_view" => "test",
      "start_address" => 167772160,
      "end_address" => 184549375,
    }
    block = Block.new(params)
    block.save

    test_ids = []

    post "/api/v1/pools", { "network_view": "test" }.to_json
    expect(last_response.status).to eq(201)
    new_pool = Pool.where({cidr: "10.0.0.0/24"}).not_in(:_id => test_ids).first()
    expect(new_pool).to be_instance_of(Pool)

    post "/api/v1/pools", { "network_view": "test" }.to_json
    expect(last_response.status).to eq(201)
    new_pool = Pool.where({cidr: "10.0.1.0/24"}).not_in(:_id => test_ids).first()
    expect(new_pool).to be_instance_of(Pool)
  end

end
